#Create a quick app to "guess" five card suits and then plot the results

library(shiny)
library(DT)
ui <- fluidPage(
    titlePanel("Guessing Cards!"),

    column(2,
            actionButton("sample", label = "Generate 1 Guess"),
            br(),
            actionButton("sample10", label = "Generate 10 Guesses"),
            br(),
            actionButton("sample100", label = "Generate 100 Guesses")
    ),
    column(10,
           fluidRow(
            column(5,
                   dataTableOutput("guesses")
                   ),
            column(7,
                   plotOutput("dotplot")
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
            
        } else {
            plotData <- values$data %>% 
                transmute(Correct = as.numeric(Correct)) 
            hist(plotData$Correct, main = "Histogram of # Correct", xlab = "Number Correct", breaks = 0:11/2-0.25)
        }
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
