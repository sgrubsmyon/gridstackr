library(gridstackr)
library(crosstalk)
library(d3scatter)
library(DT) # Crosstalk currently requires GitHub dev version of DT

## For handlers
# Close handle:  https://github.com/troolee/gridstack.js/issues/108
wrapme <- function(..., x = 0, y = 0, w = 4, h = 4) {
  gs_item(
    tags$div(
      class = "chart-title",
      tags$span("Chart Title", contenteditable=TRUE),
      tags$span(class = "gs-close-handle")),
    tags$div(class = "chart-stage",
             tags$div(class = "chart-shim",
                      ...)),
    x = x,
    y = y,
    w = w,
    h = h
  )
}

shinyApp(
  ui = fluidPage(initGS(),
                   gridstack(
                     wrapme(
                       d3scatterOutput('plot'),
                       x = 6,
                       y = 0,
                       w = 6,
                       h = 16
                     ),
                     wrapme(
                       DT::dataTableOutput('tbl'),
                       x = 0,
                       y = 0,
                       w = 6,
                       h = 16
                     )
                   )),
  server = function(input, output) {
    shared_iris <- SharedData$new(iris)
    output$plot <- renderD3scatter({
      d3scatter(shared_iris,
                ~Sepal.Length,
                ~Sepal.Width,
                ~Species,
                height="100%")
    })

    output$tbl = renderDataTable(
      shared_iris,
      extensions = "Scroller",
      options = list(lengthChange = FALSE),
      server = FALSE
    )
  }
)
