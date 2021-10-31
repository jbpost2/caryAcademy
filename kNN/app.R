library("FNN")
library("ElemStatLearn")
library("plotrix")
library("shiny")
library(zoo)

#read in data here, randomly generate for now
set.seed(1)
#create data for minesweeper for first pass
bombs <- rep(30:55, each = 10)
minesweeper <- data.frame(bombs = bombs, clicks = 25 - bombs/3 + round(rnorm(length(bombs), mean = 0, sd = 2)))


ui <- fluidPage(
   
  headerPanel('k-Nearest Neighbours Classification'),
  sidebarLayout(
    sidebarPanel(
      sliderInput('k', 'Select the Number of Nearest Neighbours (end groups will use 10 less)', value = 10, min = 10, max = nrow(minesweeper), step = 20)
      ),
    mainPanel(
      plotOutput('plot1', width = "600px", height = "600px")
      )
    )
)

server <- function(input, output) {
   
  output$plot1 <- renderPlot({
    
    #create groups based off of number of neighbors
    k <- input$k

    #grid for plotting
    grid <- data.frame(bombs = seq(from = min(minesweeper$bombs)-0.5, to = max(minesweeper$bombs)+0.5, by = 0.1))
    #predictions using knn
    pred <- knn.reg(train = minesweeper[1], test = grid, y = minesweeper[2], k = k)
    
    #plot with overlay
    plot(x = minesweeper$bombs, y= minesweeper$clicks, main = "kNN predictions vs SLR", xlab = "Bombs", ylab = "Clicks")
    lines(x = grid$bombs, y = pred$pred, type = "S", lwd = 2)
    #add linear fit
    fit <- lm(clicks ~ bombs, data = minesweeper)
    abline(fit)
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

