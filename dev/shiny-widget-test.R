library(gridstackr)
library(magrittr)
library(crosstalk)
library(d3scatter)
library(shiny)
library(DT)

myWidget <- function(gridstackrProxy,
                     ui = HTML("Hello, World!"),
                     title = "Chart Title") {

  contentWrapperCode <- tagList(
    tags$div(
      class = "chart-title",
      tags$span(title),
      tags$span(class = "gs-close-handle")
    ),
    tags$div(class = "chart-stage",
             tags$div(class = "chart-shim"))
  )

  return(addWidget(gridstackrProxy,
                   contentWrapperCode = contentWrapperCode,
                   ui = ui,
                   uiWrapperClass = ".chart-shim"))
}

myGridstackr <- function() {
  gridstackr(list(draggable = list(handle = ".chart-title")))
}

shinyApp(
  ui <- fluidPage(
    includeCSS("www/myWidget.css"),
    includeScript("www/myWidget.js"),
    actionButton("btn1","Create dataset widget"),
    actionButton("btn2","Create plot widget"),
    gridstackrOutput("gstack")
    ),
  server <- function(input, output) {
    shared_iris <- SharedData$new(iris)

    observeEvent(input$btn1, {
      # ui
      id <- paste0("tbl-",input$btn1)

      gridstackrProxy("gstack") %>%
        myWidget(ui = DT::dataTableOutput(id))

      # server
      output[[id]] = DT::renderDataTable(
        shared_iris,
        extensions = "Scroller",
        options = list(lengthChange = FALSE),
        server = FALSE
      )
    })

    observeEvent(input$btn2, {
      # ui
      id <- paste0("plot-",input$btn1)

      gridstackrProxy("gstack") %>%
        myWidget(ui = d3scatterOutput(id))

      # server
      output[[id]] <- renderD3scatter({
        d3scatter(shared_iris,
                  ~Sepal.Length,
                  ~Sepal.Width,
                  ~Species,
                  height="100%")
      })
    })

    output$gstack <- renderGridstackr({
      myGridstackr()
    })

  }
)
