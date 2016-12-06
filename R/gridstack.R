#' Setup for a gridstackjs
#' @importFrom shiny addResourcePath singleton HTML tags
#' @export
initGS <- function() {

  addResourcePath("gridstackjs", system.file("gridstackjs", package = "gridstackr", mustWork = TRUE))
  addResourcePath("lodash", system.file("lodash", package = "gridstackr", mustWork = TRUE))
  addResourcePath("jquery-ui", system.file("jquery-ui", package = "gridstackr", mustWork = TRUE))

  css <- ".grid-stack {background: lightgoldenrodyellow;} .grid-stack-item-content {color: #2c3e50; background-color: #18bc9c;}"
  initconf <- "$(function () { $('.grid-stack').gridstack({ cellHeight: 80, verticalMargin: 10 }); });"

  singleton(
    tags$head(
      tags$script(src = file.path("jquery-ui", "jquery-ui.js")),
      tags$script(src = file.path("lodash", "lodash.min.js")),
      tags$link(src = file.path("gridstackjs", "gridstack-extra.min.css")),
      tags$script(src = file.path("gridstackjs", "gridstack.min.js")),
      tags$script(src = file.path("gridstackjs", "gridstack.jQueryUI.js")),
      tags$script(HTML(initconf)),
      tags$style(HTML(css))
      )
    )
}

#' div tag element
div <- htmltools::tags$div

#' Gridstack container
#' @param ... \code{gs_item} elements to include in the grid.
#' @export
gridstack <- function(...) {

  div(class = "grid-stack", ...)

}

#' Gridstack Item
#' @param ... Elements to include within the grid item.
#' @param x x position to put the grid item.
#' @param y y position to put the grid item.
#' @param w weight of the grid item.
#' @param h height  of the grid item.
#' @export
gs_item <- function(..., x = 0, y = 0, w = 4, h = 4) {

  div(
    class = "grid-stack-item",
    "data-gs-x" = x, "data-gs-y" = y,
    "data-gs-w" = w, "data-gs-h" = h,
    div(class = "grid-stack-item-content", ...)
    )

}
