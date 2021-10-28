#Create a quick app to "guess" five card suits and then plot the results

library(shiny)
library(DT)
library(tidyverse)

ui <- fluidPage(
    titlePanel("Guessing Cards!"),

    column(2, 
           wellPanel(
            actionButton("sample", label = "Generate 1 Guess"),
            br(),
            actionButton("sample10", label = "Generate 10 Guesses"),
            br(),
            actionButton("sample100", label = "Generate 100 Guesses")
           )
    ),
    column(10,
           fluidRow(
            column(5,
                   dataTableOutput("guesses")
                   ),
            column(7, 
                   wellPanel(
                       plotOutput("dotplot")
                   ),
                   wellPanel(
                       checkboxInput("addc", label = "Add prediction (c)", value = FALSE),
                       conditionalPanel("input.addc", 
                                        sliderInput("c", "Select value for c", min = 0, max = 5, value = 0, step = 0.05),
                                        radioButtons("metric", "Choose metric", 
                                                           choices = c("MAE", "MSE", "MQE"), selected = "MSE"
                                                           ),
                                        verbatimTextOutput("metricValue")
                                        )
                   )
                   )
           )
        )
)

#create cards
suits <- c("D", "H", "C", "S")
card <- pull(tidyr::unite(expand.grid(cards = c("A", 2:10, "J", "Q", "K"),
                                      suits),
                          col = card, sep = "-"), card)
#helper functions for sampling
sampleCards <- function(){sample(card, 5, replace = TRUE)}
sampleSuits <- function(){sample(suits, 5, replace = TRUE)}
numCorrect <- function(cards, suits){
    sum(sub('.*-', "", cards) == suits)
}

#new row
addOne <- function(){
    samp1 <- sampleCards()
    samp2 <- sampleSuits()
    numberCorrect <- numCorrect(samp1, samp2)
    cols <- paste0("Card", 1:5)
    cards <- as.data.frame(t(samp1), row.names = "Cards")
    names(cards) <- cols
    guesses <- as.data.frame(t(samp2), row.names = "Guesses")
    names(guesses) <- cols
    return(list(cards = cards, guesses = guesses, numberCorrect = numberCorrect))
}

#plot helpers
addArrow <- function(c, x, freq){
    count <- filter(freq, Correct == x)$Counts
    if(length(count) == 0) count <- 0
    arrows(x0 = c, x1 = x, y0 = count, y1 = count, lwd = 2)
}

addText <- function(c, x, freq, metric){
    count <- filter(freq, Correct == x)$Counts
    n <- sum(freq$Counts)
    if(length(count) == 0) count <- 0
    if(x == 0 | x == 1){
        y <- count-max(freq$Counts/40)
    } else {
        y <- count+max(freq$Counts/40)
    }
    if(metric == "MSE"){
        text(x = x, y = y, label = paste0("(",count, "/", n, ")*(", x, "-", c, ")^2=", round((count/n)*(x-c)^2,2)))
    } else if(metric == "MAE") {
        text(x = x, y = y, label = paste0("(",count, "/", n, ")*|", x, "-", c, "|=", round((count/n)*abs(x-c),2)))
    } else if(metric == "MQE"){
        text(x = x, y = y, label = paste0("(",count, "/", n, ")*(", x, "-", c, ")^4=", round((count/n)*(x-c)^4,2)))
    }
}

buildString <- function(c, x, freq, metric){
    count <- filter(freq, Correct == x)$Counts
    n <- sum(freq$Counts)
    if(length(count) == 0) count <- 0
    if(metric == "MSE") {
        paste0("(",count, "/", n, ")*(", x, "-", c, ")^2")
    } else if(metric =="MAE"){
        paste0("(",count, "/", n, ")*|", x, "-", c, "|")
    } else if(metric == "MQE"){
        paste0("(",count, "/", n, ")*(", x, "-", c, ")^4")
    }
}

buildMetric <- function(c, x, freq, metric){
    count <- filter(freq, Correct == x)$Counts
    n <- sum(freq$Counts)
    if(length(count) == 0) count <- 0
    if(metric == "MSE") {
        (count/n)*(x-c)^2
    } else if(metric =="MAE"){
        (count/n)*abs(x-c)
    } else if(metric == "MQE"){
        (count/n)*(x-c)^4
    }
}

server <- function(input, output) {

    values <- reactiveValues(
        data = data.frame(Card1 = character(),
                          Card2 = character(),
                          Card3 = character(),
                          Card4 = character(),
                          Card5 = character(),
                          Correct = character()
                          )
    )
    
    observeEvent(input$sample, {
        grab <- addOne()
        values$data <- rbind(values$data, cbind(rbind(grab$cards, grab$guesses), Correct = c(grab$numberCorrect, "")))
   })
    
    observeEvent(input$sample10, {
        replicate(10, {
        grab <- addOne()
        values$data <- rbind(values$data, cbind(rbind(grab$cards, grab$guesses), Correct = c(grab$numberCorrect, "")))
        })
    })
    
    observeEvent(input$sample100, {
        replicate(100, {
            grab <- addOne()
            values$data <- rbind(values$data, cbind(rbind(grab$cards, grab$guesses), Correct = c(grab$numberCorrect, "")))
        })
    })

    
    output$guesses <- renderDataTable({
        datatable(values$data, options = list(pageLength = 50, lengthMenu = 50))
    })
    
    
    output$dotplot <- renderPlot({
        if(nrow(values$data) == 0){
            
        } else if(!input$addc) {
            plotData <- values$data %>% 
                transmute(Correct = as.numeric(Correct)) 
            hist(plotData$Correct, main = "Histogram of # Correct", xlab = "Number Correct", breaks = 0:11/2-0.25)
        } else {
            plotData <- values$data %>% 
                transmute(Correct = as.numeric(Correct))
            freq <- plotData %>% 
                group_by(Correct) %>%
                summarize(Counts = n()) %>%
                tidyr::drop_na()
            hist(plotData$Correct, main = "Histogram of # Correct", xlab = "Number Correct", breaks = 0:11/2-0.25)
            abline(v = input$c, lwd = 3)
            print(max(freq$Counts/2))
            text(x = input$c+0.2, y = max(freq$Counts/2), labels = paste("c=", input$c, sep =""))
            addArrow(input$c, 0, freq)
            addArrow(input$c, 1, freq)
            addArrow(input$c, 2, freq)
            addArrow(input$c, 3, freq)
            addArrow(input$c, 4, freq)
            addArrow(input$c, 5, freq)
            addText(input$c, 0, freq, input$metric)
            addText(input$c, 1, freq, input$metric)
            addText(input$c, 2, freq, input$metric)
            addText(input$c, 3, freq, input$metric)
            addText(input$c, 4, freq, input$metric)
            addText(input$c, 5, freq, input$metric)
        }
    })
    
    output$metricValue <- renderText({
        plotData <- values$data %>% 
            transmute(Correct = as.numeric(Correct))
        freq <- plotData %>% 
            group_by(Correct) %>%
            summarize(Counts = n()) %>%
            drop_na()

        paste0("The MSE using a c value of ", input$c, " is: \n", 
               buildString(input$c, 0, freq, input$metric), " + \n",
               buildString(input$c, 1, freq, input$metric), " + \n",
               buildString(input$c, 2, freq, input$metric), " + \n",
               buildString(input$c, 3, freq, input$metric), " + \n",
               buildString(input$c, 4, freq, input$metric), " + \n",
               buildString(input$c, 5, freq, input$metric), 
               " = ", 
               round(sum(buildMetric(input$c, 0, freq, input$metric),
                         buildMetric(input$c, 1, freq, input$metric),
                         buildMetric(input$c, 2, freq, input$metric),
                         buildMetric(input$c, 3, freq, input$metric),
                         buildMetric(input$c, 4, freq, input$metric),
                         buildMetric(input$c, 5, freq, input$metric)), 4))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
