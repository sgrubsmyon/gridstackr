library(gridstackr)
library(magrittr)
library(crosstalk)
library(d3scatter)
library(shiny)
library(DT)

shinyApp(
  ui <- fluidPage(
    actionButton("btn1","Create widget in stack 1"),
    actionButton("btn2","Create widget in stack 2"),
    gridstackrOutput("gstack1"),
    gridstackrOutput("gstack2")
    ),
  server <- function(input, output) {
    shared_iris <- SharedData$new(iris)

    observeEvent(input$btn1, {
      # ui
      id <- paste0("tbl-",input$btn1)

      gridstackrProxy("gstack1") %>%
        addWidget(ui = DT::dataTableOutput(id))

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

      gridstackrProxy("gstack2") %>%
        addWidget(ui = d3scatterOutput(id))

      # server
      output[[id]] <- renderD3scatter({
        d3scatter(shared_iris,
                  ~Sepal.Length,
                  ~Sepal.Width,
                  ~Species,
                  height="100%")
      })
    })

    output$gstack1 <- renderGridstackr({
      gridstackr()
    })

    output$gstack2 <- renderGridstackr({
      gridstackr()
    })

  }
)
