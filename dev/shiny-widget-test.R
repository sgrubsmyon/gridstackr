library(gridstackr)
library(shiny)

shinyApp(
  ui <- bootstrapPage(gridstackrOutput("gstack1"),
                     gridstackrOutput("gstack2")),
  server <- function(input, output) {
    output$gstack1 <- renderGridstackr({
      gridstackr::gridstackr()
    })

    output$gstack2 <- renderGridstackr({
      gridstackr::gridstackr()
    })
  }
)
