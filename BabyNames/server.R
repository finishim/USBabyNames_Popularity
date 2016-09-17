#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(reshape2)
library(ggplot2)

# Define server logic required to draw a plot
shinyServer(function(input, output) {
   
    # Grab the Data and Combine into One Dataframe
    
    ## The following code to merge the data files is sourced from Hadley's Github on babynames:
    ## https://github.com/hadley/babynames/blob/master/data-raw/names.R
    
    if (!file.exists(".\\data\\names")) {
        tmp <- tempfile(fileext = ".zip")
        download.file("https://www.ssa.gov/oact/babynames/names.zip", tmp, quiet = TRUE)
        unzip(tmp, exdir = ".\\data\\names")
        unlink(tmp)
    }
    all <- dir(".\\data\\names", "\\.txt$", full.names = TRUE)
    year <- as.numeric(gsub("[^0-9]", "", basename(all))) # grab the year from filenames
    
    data <- lapply(all, read.csv, header=F, stringsAsFactors = F) # read all the files in to one list
    
    one <- do.call(rbind,data) # bind all lists into one dataframe
    names(one) <- c("name", "sex", "n")
    one$year <- rep(year, vapply(data, nrow, integer(1))) # add years as a column
    
  output$distPlot <- renderPlot({
    
    # filter the dataframe based on inputs from ui.R
    one_filtered <- filter(one, year <= input$range[2] & year > input$range[1], name == input$name, sex == input$sex)
    
    # use ggplot to plot the user selected name usage throughout the years
    g <- ggplot(data = one_filtered, aes(x=year,y=n)) + 
        geom_line() + 
        xlab("Years") + 
        ylab("Number of Baby Names")
    g
    
  })
  
})
