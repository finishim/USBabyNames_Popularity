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

# Define server logic required to draw a histogram
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
    
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
  })
  
})
