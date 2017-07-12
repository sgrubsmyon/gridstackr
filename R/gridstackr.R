#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
gridstackr <- function(items = NULL, width = NULL, height = NULL, elementId = NULL) {

  # forward options using x
  x = list(
    items = items
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'gridstackr',
    x,
    width = width,
    height = height,
    package = 'gridstackr',
    elementId = elementId
  )
}

#' Shiny bindings for gridstackr
#'
#' Output and render functions for using gridstackr within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a gridstackr
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name gridstackr-shiny
#'
#' @export
gridstackrOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'gridstackr', width, height, package = 'gridstackr')
}

#' @rdname gridstackr-shiny
#' @export
renderGridstackr <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, gridstackrOutput, env, quoted = TRUE)
}

# Add custom HTML to wrap the widget to allow for a zoom in/out menu
gridstackr_html <- function(id, style, class, ...) {
  htmltools::tags$div(
    id = id, class = class, style = style,
      htmltools::tags$div(class = "grid-stack")
  )
}

#' Create a gridstackr proxy object
#'
#' @param id Name of the gridstackr widget
#' @param session Valid session object
#'
#' @return grid proxy object
#' @export
gridstackrProxy <- function(id, session = shiny::getDefaultReactiveDomain()) {
  object        <- list( id = id, session = session )
  class(object) <- "gridstackrProxy"

  return(object)
}

#' Adds a new widget to the gridstack
#'
#' Right now, assuming entire widget is draggable.
#'
#' @param gridstackrProxy Proxy gridstackr object
#' @param ui Shiny UI content.  If just text, need to use HTML(...)
#'
#' @return gridstackrProxy
#' @export
addWidget <- function(gridstackrProxy, ui = HTML("I am a widget!")) {
  data <- list(id = gridstackrProxy$id,
               content = as.character(tags$div(
                 tags$div(class = "grid-stack-item-content ui-draggable-handle")
               )))

  gridstackrProxy$session$sendCustomMessage("addWidget", data)

  # addWidget JS function appends new grid-stack-item to the end, so we need
  # to make sure the selector grabs the content of the last grid-stack-item.
  insertUI(
    selector = paste0("#", data$id, " .grid-stack-item:last-child .grid-stack-item-content"),
    ui = ui
  )

  return(gridstackrProxy)
}
