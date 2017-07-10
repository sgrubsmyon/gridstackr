#' Setup for a gridstackjs
#' @importFrom shiny addResourcePath singleton HTML tags
#' @export
initGS <- function() {

  addResourcePath("gridstackjs", system.file("gridstackjs", package = "gridstackr", mustWork = TRUE))
  addResourcePath("lodash", system.file("lodash", package = "gridstackr", mustWork = TRUE))
  addResourcePath("jquery-ui", system.file("jquery-ui", package = "gridstackr", mustWork = TRUE))

  css <- "

.grid-stack-wrap {
  background: #f2f2f2;
  padding: 10px 0px;
}

.grid-stack-item-content {
    background: #fff;
    border: 1px solid #e2e2e2;
    border-radius: 3px;
}

.chart-title {
    border-bottom: 1px solid #d7d7d7;
    color: #666;
    font-size: 14px;
    font-weight: 500;
    padding: 7px 10px 4px;
    cursor: move; /* fallback if grab cursor is unsupported */
    cursor: grab;
    cursor: -moz-grab;
    cursor: -webkit-grab;
}

/* https://stackoverflow.com/questions/5697067/css-for-grabbing-cursors-drag-drop */
.chart-title:active {
    cursor: grabbing;
    cursor: -moz-grabbing;
    cursor: -webkit-grabbing;
}

.chart-stage {
    overflow: auto;
    padding: 5px 10px;
    position: relative;
    height: 90%;  /* This is annoying.  Someone smarter than me please fix.  :) */
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
    background-image: url('data:image/svg+xml;base64,PHN2ZyB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiIHdpZHRoPSIxMSIgaGVpZ2h0PSIxNCIgdmlld0JveD0iMCAwIDExIDE0Ij4KPHBhdGggZD0iTTEwLjE0MSAxMC4zMjhxMCAwLjMxMi0wLjIxOSAwLjUzMWwtMS4wNjIgMS4wNjJxLTAuMjE5IDAuMjE5LTAuNTMxIDAuMjE5dC0wLjUzMS0wLjIxOWwtMi4yOTctMi4yOTctMi4yOTcgMi4yOTdxLTAuMjE5IDAuMjE5LTAuNTMxIDAuMjE5dC0wLjUzMS0wLjIxOWwtMS4wNjItMS4wNjJxLTAuMjE5LTAuMjE5LTAuMjE5LTAuNTMxdDAuMjE5LTAuNTMxbDIuMjk3LTIuMjk3LTIuMjk3LTIuMjk3cS0wLjIxOS0wLjIxOS0wLjIxOS0wLjUzMXQwLjIxOS0wLjUzMWwxLjA2Mi0xLjA2MnEwLjIxOS0wLjIxOSAwLjUzMS0wLjIxOXQwLjUzMSAwLjIxOWwyLjI5NyAyLjI5NyAyLjI5Ny0yLjI5N3EwLjIxOS0wLjIxOSAwLjUzMS0wLjIxOXQwLjUzMSAwLjIxOWwxLjA2MiAxLjA2MnEwLjIxOSAwLjIxOSAwLjIxOSAwLjUzMXQtMC4yMTkgMC41MzFsLTIuMjk3IDIuMjk3IDIuMjk3IDIuMjk3cTAuMjE5IDAuMjE5IDAuMjE5IDAuNTMxeiI+PC9wYXRoPgo8L3N2Zz4K');
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
gridstack <- function(..., height = "500px") {
  tags$div(class ="grid-stack-wrap", height = height,
    tags$div(class = "grid-stack", ...)
  )
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
