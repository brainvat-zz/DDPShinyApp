
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Change Point Detection in Time Series"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("stream",
                  "Stream:",
                  min = 1,
                  max = 10,
                  value = 3)
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("linePlot")
    )
  )
))
