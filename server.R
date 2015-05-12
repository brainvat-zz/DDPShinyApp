
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
source("data_generator.R")

shinyServer(function(input, output) {
  
  output$linePlot <- renderPlot({

    # plot the stream indicated in the slider
    x <- input$stream
    p <- ggplot(data.frame(x=days, y=loginSeqs[[x]][1:300]), aes(x=x, y=y))
    p + geom_line()
  })

})
