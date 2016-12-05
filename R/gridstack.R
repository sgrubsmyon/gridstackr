#' @export
initGS <- function(cell_height = 80, vertical_margin = 10, handles = NULL) {

  shiny::tags$head()

}



#' @importFrom htmltools tags
#' @export
div <- htmltools::tags$div

#' Gridstack container
#' @export
gridstack <- function(...) {

  div(class = "grid-stack", ...)

}

#' Gridstack Item
#' @export
gs_item <- function(..., x = 0, y = 0, w = 4, h = 4) {

  div(
    class = "grid-stack-item",
    "data-gs-x" = x, "data-gs-y" = y,
    "data-gs-w" = w, "data-gs-h" = h,
    div(class = "grid-stack-item-content", ...)
    )

}
