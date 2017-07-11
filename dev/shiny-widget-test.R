library(gridstackr)
library(magrittr)
library(shiny)

shinyApp(
  ui <- bootstrapPage(
    actionButton("btn1","Create widget in stack 1"),
    gridstackrOutput("gstack1"),
                     gridstackrOutput("gstack2")),
  server <- function(input, output) {
    observeEvent(input$btn1, {
      gridstackrProxy("gstack1") %>% addWidget()
    })

    output$gstack1 <- renderGridstackr({
      gridstackr()
    })

    output$gstack2 <- renderGridstackr({
      gridstackr()
    })
  }
)
