
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
library(cpm)

shinyServer(function(input, output) {
  
  output$linePlot <- renderPlot({

    # plot the stream indicated in the slider
    x <- which(my.labels == input$stream)
    #p <- ggplot(data.frame(x=days, y=loginSeqs[[x]][1:300]), aes(x=x, y=y))
    #p + geom_line()
    p1 <- plotPair(unlist(my.pairs[x]))
    p2 <- plotPair(c(my.pairs[[x]][1], my.pairs[[x]][1]))
    p3 <- plotPair(c(my.pairs[[x]][2], my.pairs[[x]][2]))
    
    p1
  })
  
  output$streamHelp <- renderTable({
    x <- which(my.labels == input$stream)
    df <- data.frame(Symbol = data,
                     Description = data.labels)
    df[c((x*2)-1, (x*2)),]
  })
  
  output$cpmTable <- renderDataTable({
    x <- which(my.labels == input$stream)
    symbol1 <- my.pairs[[x]][1]
    symbol2 <- my.pairs[[x]][2]
    t.method <- input$method
    
    result <- tryCatch( 
      expr = {
        cpm1 <- processStream(x = as.vector(get(symbol1)[,paste0(symbol1, ".Adjusted")]),
                              cpmType = t.method)
        cp1.price <- as.vector(get(symbol1)[cpm1$changePoints, c(paste0(symbol1, ".Adjusted"))])
        cp1.date <- row.names(data.frame(get(symbol1)[cpm1$changePoints, c(paste0(symbol1, ".Adjusted"))]))
        dt1.price <- as.vector(get(symbol1)[cpm1$detectionTimes, c(paste0(symbol1, ".Adjusted"))])
        dt1.date <- row.names(data.frame(get(symbol1)[cpm1$detectionTimes, c(paste0(symbol1, ".Adjusted"))]))
        
        resMW1 <- data.frame(symbol = symbol1,
                             changeDate = cp1.date,
                             changePrice = cp1.price,
                             detectionDate = dt1.date,
                             detectionPrice = dt1.price,
                             priceDelta = paste0(ifelse((dt1.price-cp1.price) > 0, "+", ""), round(100 * (dt1.price - cp1.price)/dt1.price, 2), "%"),
                             daysDelta = as.Date(dt1.date) - as.Date(cp1.date))
        
        cpm2 <- processStream(x = as.vector(get(symbol2)[,paste0(symbol2, ".Adjusted")]),
                              cpmType = t.method)
        cp2.price <- as.vector(get(symbol2)[cpm2$changePoints, c(paste0(symbol2, ".Adjusted"))])
        cp2.date <- row.names(data.frame(get(symbol2)[cpm2$changePoints, c(paste0(symbol2, ".Adjusted"))]))
        dt2.price <- as.vector(get(symbol2)[cpm2$detectionTimes, c(paste0(symbol2, ".Adjusted"))])
        dt2.date <- row.names(data.frame(get(symbol2)[cpm2$detectionTimes, c(paste0(symbol2, ".Adjusted"))]))
        
        resMW2 <- data.frame(symbol = symbol2,
                             changeDate = cp2.date,
                             changePrice = cp2.price,
                             detectionDate = dt2.date,
                             detectionPrice = dt2.price,
                             priceDelta = paste0(ifelse((dt2.price-cp2.price) > 0, "+", ""), round(100 * (dt2.price - cp2.price)/dt2.price, 2), "%"),
                             daysDelta = as.Date(dt2.date) - as.Date(cp2.date))
        
        rbind(resMW1, resMW2)
      }, 
      error = function(x) {
        data.frame(error = paste("Unable to use change point method", t.method, "for this data set."))
      })
    result
  }, options = list(pageLength = 10, orderClasses = TRUE), )
})
