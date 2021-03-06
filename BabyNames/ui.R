#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Baby Name Popularity by Year"),
  
  # Sidebar with a text, radio button and slider input 
  sidebarLayout(
      sidebarPanel(
          h3("Please fill out name, select gender and choose the year range below, to see how popular the name was throughout the years."),
          textInput(inputId="name", label = "Enter Name:"),
          radioButtons("sex", "Choose Gender:",c("Male" = "M","Female" = "F")),
          sliderInput("range", "Choose Year:",min = 1880, max = 2015, value = c(1950,2015))
      ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot")
    )
  )
))
