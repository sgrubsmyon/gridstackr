#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
gridstackr <- function(items = NULL, width = NULL, height = NULL, elementId = NULL) {
  # NOTE:  width and height aren't working properly.  Check this!!!
  # When does this get called?  shinyWidgetOutput or shinyRenderOutput?

  # Default options
  options = list(
    float = FALSE,
    cellHeight = 10,
    verticalMargin = 10,
    animate = TRUE,
    draggable = list(
      handle = '.grid-stack-item-content' # This is already default in gridstack.js, but want to make explicit here.
    )
    # height = 0   # Future:  Put in code to match Shiny container height $('#'+el.id).height()
  )

  if (!is.null(height)) {
    # Assumes height is "###px".
    options.height <- floor(as.integer(substr(height, 1, nchar(height)-2)) / options.cellHeight)

    # Make height a multiple of cellHeight to match options.height
    height <- paste0(as.character(options.height * options.cellHeight), "px")
  }

  # No data validation yet
  x = list(
    items = modifyList(options, items)
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

# Shiny autogen ----

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
gridstackrOutput <- function(outputId, width = '100%', height = 'auto'){
  htmlwidgets::shinyWidgetOutput(outputId, 'gridstackr', width, height, package = 'gridstackr')
}

#' @rdname gridstackr-shiny
#' @export
renderGridstackr <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, gridstackrOutput, env, quoted = TRUE)
}

# API ----

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
#' @param id ID for gridstack item
#' @param content Code for gridstack item UI
#' @param uiWrapperClass Class/ID of element for Shiny UI (class within content)
#' @param ui Shiny UI content.  If just text, need to use HTML(...)
#'
#' @return gridstackrProxy
#' @export
addWidget <- function(gridstackrProxy,
                      id = "",
                      content = "",
                      uiWrapperClass = ".grid-stack-item-content",
                      ui = HTML("I am a widget!")) {

  data <- list(gridID = gridstackrProxy$id,
               itemID = id,
               content = as.character(tags$div(  # Becomes .grid-stack-item
                 tags$div(class = "grid-stack-item-content",
                          content)
                 )
                 )
               )

  gridstackrProxy$session$sendCustomMessage("addWidget", data)

  # addWidget JS function appends new grid-stack-item to the end, so we need
  # to make sure the selector grabs the content of the last grid-stack-item.
  insertUI(
    selector = paste0("#", data$gridID, " .grid-stack-item:last-child ", uiWrapperClass),
    ui = ui
  )

  return(gridstackrProxy)
}

#' Removes a widget from the gridstack
#'
#' @param gridstackrProxy
#' @param id Name of the gridstackr widget
#' @param el Element to be removed
#'
#' @return gridstackrProxy
#' @export
#'
#' @examples
removeWidget <- function(gridstackrProxy,
                         gridID = "",
                         itemID = "") {

  # Deciding to utilize removeUI for now.  This is possibly overkill - the other option is
  # to just use gridstack's removeWidget JS function, in combination with Shiny.bindAll()
  # and Shiny.unbindAll().  These last two functions seem to have some issues at the moment,
  # so going the cleaner, yet more code-wordy, route.
  removeUI(selector = paste0("#", itemID, " .chart-shim :first-child"),
           session = gridstackrProxy$session)

  data <- list(gridID = gridID,
               itemID = itemID
               )

  gridstackrProxy$session$sendCustomMessage("removeWidget", data)

  return(gridstackrProxy)
}

