#' @importFrom htmltools tags
#' @export
div <- htmltools::tags$div

#' @export
gridstack <- function(...) {

  div(class = "grid-stack", ...)

}
}

#' @export
gs_item <- function(..., x = 0, y = 0, w = 4, h = 4) {

  div(class = "grid-stack-item",
      data-gs-x = x, data-gs-y = y,
      data-gs-w = w, data-gs-h = h,
      div(class = "grid-stack-item-content", ...)
      )

}
