library(gridstackr)
library(magrittr)
library(crosstalk)
library(d3scatter)
library(shiny)
library(DT)

# Needed to deal with flexdashboard/shiny issues.
# See https://github.com/rstudio/flexdashboard/issues/28 and https://github.com/rstudio/flexdashboard/commit/854a2ceb867522fa892d66417a43733e476c92ec
options(DT.fillContainer = TRUE)
options(DT.autoHideNavigation = TRUE)

# Custom widget code.  Adds a title element, a close "button", and a place for content.
#
# The first argument, and return object, must be a gridstackrProxy for this function to
# work with the %>% operator.
#
# Notice in the call to addWidget that the uiWrapperClass is changed to chart-shim,
# telling gridstackr where to place the Shiny UI content.
myWidget <- function(gridstackrProxy,
                     id = "",
                     ui = HTML("Hello, World!"),
                     title = "Chart Title") {

  content <- tagList(
    tags$div(
      class = "chart-title",
      tags$span(title),
      tags$span(class = "gs-remove-handle")
    ),
    tags$div(class = "chart-stage",
             tags$div(class = "chart-shim"))
  )

  return(addWidget(gridstackrProxy,
                   id = id,
                   content = content,
                   ui = ui,
                   uiWrapperClass = ".chart-shim"))
}

shinyApp(
  ui <- fluidPage(
    includeCSS("www/myWidget.css"),
    # includeScript("www/myWidget.js"), # Taking out for now while I test built-in support
    actionButton("btn1","Create dataset widget"),
    actionButton("btn2","Create plot widget"),
    gridstackrOutput("gstack", height="400px")
    ),
  server <- function(input, output) {
    shared_iris <- SharedData$new(iris)

    observeEvent(input$btn1, {
      # ui
      id <- paste0("tbl-",input$btn1)

      gridstackrProxy("gstack") %>%
        myWidget(id = paste0(id, "-item"),
                 ui = DT::dataTableOutput(id))

      # server
      output[[id]] = DT::renderDataTable(
        shared_iris,
        server = FALSE
      )
    })

    observeEvent(input$btn2, {
      # ui
      id <- paste0("plot-",input$btn2)

      gridstackrProxy("gstack") %>%
        myWidget(id = paste0(id, "-item"),
                 ui = d3scatterOutput(id))

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
      gridstackr(list(
        draggable = list(handle = ".chart-title")
        ))
    })

    observeEvent(input$jsRemove, {
      gridstackrProxy("gstack") %>%
        removeWidget(gridID = input$jsRemove$gridID,
                     itemID = input$jsRemove$itemID)
    })
  }
)
