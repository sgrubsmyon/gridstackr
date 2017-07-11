library(gridstackr)
library(magrittr)
library(shiny)

shinyApp(
  ui <- fluidPage(
    actionButton("btn1","Create widget in stack 1"),
    actionButton("btn2","Create widget in stack 2"),
    gridstackrOutput("gstack1"),
    gridstackrOutput("gstack2")
    ),
  server <- function(input, output) {
    observeEvent(input$btn1, {
      gridstackrProxy("gstack1") %>% addWidget()
    })

    observeEvent(input$btn2, {
      gridstackrProxy("gstack2") %>% addWidget()
    })

    output$gstack1 <- renderGridstackr({
      gridstackr()
    })

    output$gstack2 <- renderGridstackr({
      gridstackr()
    })
  }
)
