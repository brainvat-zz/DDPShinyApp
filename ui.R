
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Predicting Stock Prices with Change Point Detection"),
  
  includeHTML("intro.html"),
  
  fluidRow(
    column(4, 
          selectInput("stream", label = h3("1. Choose stock pairs"), 
                      choices = my.labels),
          tableOutput("streamHelp"),
          selectInput("method", label = h3("2. Choose change point algorithm"),
                      choices = cpm.methods)
    ),

    column(8,
          plotOutput("linePlot")
    )
  ),
  
  h3("3. Explore change points detected"),
  helpText("Can you find an algorithm where you could discovered stock price changes early enough 
           in one company to have made a profit by buying stock in its pair? daysDelta is the number
           of days between when the algorithm was able to detect the change and when the actual
           change occurred in the market."),  
  dataTableOutput("cpmTable")
))
