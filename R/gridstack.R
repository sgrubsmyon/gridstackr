#' Setup for a gridstackjs
#' @importFrom shiny addResourcePath singleton HTML tags
#' @export
initGS <- function() {

  addResourcePath("gridstackjs", system.file("gridstackjs", package = "gridstackr", mustWork = TRUE))
  addResourcePath("lodash", system.file("lodash", package = "gridstackr", mustWork = TRUE))
  addResourcePath("jquery-ui", system.file("jquery-ui", package = "gridstackr", mustWork = TRUE))

#   css <- "
# .grid-stack {
#   background: lightgoldenrodyellow;
# }
#
# .grid-stack-item-content {
#   color: #2c3e50;
#   text-align: center;
#   background-color: #18bc9c;
# }"

  css <- "

.grid-stack {
  background: #f2f2f2;
}

.grid-stack-item-content {
    background: #fff;
    border: 1px solid #e2e2e2;
    border-radius: 3px;
    margin-bottom: 8px;
    margin-right: 8px;
}

.chart-title {
    border-bottom: 1px solid #d7d7d7;
    color: #666;
    font-size: 14px;
    font-weight: 500;
    padding: 7px 10px 4px;
}

.chart-stage {
    overflow: auto;
    padding: 5px 10px;
    position: relative;
    height: 90%;
}

.chart-shim {
    position: absolute;
    left: 8px;
    top: 8px;
    right: 8px;
    bottom: 8px;
}

.gs-close-handle {
    opacity: 90;
    width: 15px;
    height: 15px;
    top: 8px;
    right: 15px;
    background-image: url('data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgNTAwIDUwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48Y2lyY2xlIGN4PSIyNDkuOSIgY3k9IjI1MC40IiByPSIyMDQuNyIgc3Ryb2tlPSIjMDAwIiBzdHJva2UtbWl0ZXJsaW1pdD0iMTAiLz48Y2lyY2xlIGN4PSIyNDkuOSIgY3k9IjI0Ny40IiBmaWxsPSIjRkZGIiByPSIxODEuOCIgc3Ryb2tlPSIjMDAwIiBzdHJva2UtbWl0ZXJsaW1pdD0iMTAiLz48cGF0aCBmaWxsPSJub25lIiBzdHJva2U9IiMwMDAiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIgc3Ryb2tlLW1pdGVybGltaXQ9IjEwIiBzdHJva2Utd2lkdGg9IjIyIiBkPSJNMTYyIDE1OS41bDE3NS44IDE3NS44TTMzNy44IDE1OS41TDE2MiAzMzUuMyIvPjwvc3ZnPg==');
    background-position: top left;
    background-repeat: no-repeat;
    z-index: 90;
    cursor: pointer;
    position: absolute;
    transition: opacity 300ms ease 50ms,background-color 300ms ease 50ms;
}
"

## For options:
# Draggable title:  https://github.com/troolee/gridstack.js/issues/100

  initconf <- "
$(function () {
  var options = {
    float: true,
    cellHeight: 20,
    verticalMargin: 10,
    draggable: {
        handle: '.chart-title',
    }
  };
  var grid = $('.grid-stack').gridstack(options);
  grid.on('click', '.gs-close-handle', function() {
    var el = $(this).parents('.grid-stack-item');
    el.fadeOut(200, function(){
      $('.grid-stack').data('gridstack').removeWidget(el, true);
    });
  });
});";

  singleton(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = file.path("gridstackjs", "gridstack.css")),

      tags$script(src = file.path("jquery-ui", "jquery-ui.js")),
      tags$script(src = file.path("lodash", "lodash.min.js")),

      tags$script(src = file.path("gridstackjs", "gridstack.min.js")),
      tags$script(src = file.path("gridstackjs", "gridstack.jQueryUI.js")),

      tags$style(HTML(css)),
      tags$script(HTML(initconf))

    )
  )
}

#' Gridstack container
#' @param ... \code{gs_item} elements to include in the grid.
#' @export
gridstack <- function(..., height = "500") {

  tags$div(class = "grid-stack", height = height, ...)

}

#' Gridstack Item
#' @param ... Elements to include within the grid item.
#' @param x x position to put the grid item.
#' @param y y position to put the grid item.
#' @param w weight of the grid item.
#' @param h height of the grid item.
#' @export
gs_item <- function(..., x = 0, y = 0, w = 4, h = 4) {

  tags$div(
    class = "grid-stack-item",
    "data-gs-x" = x, "data-gs-y" = y,
    "data-gs-width" = w, "data-gs-height" = h,
    tags$div(class = "grid-stack-item-content", ...)
  )

}
