library(gridstackr)
library(shiny)

shinyApp(
  ui = bootstrapPage(gridstackrOutput("gstack")),
  server = function(input, output) {
    output$gstack = renderGridstackr({
      gridstackr::gridstackr()
      })
  }
)
