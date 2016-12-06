library(gridstackr)

shinyApp(
  fluidPage(
    initGS(),
    gridstack(
      gs_item("1", x = 0, y = 0, w = 4, h = 2),
      gs_item("2", x = 4, y = 0, w = 4, h = 4),
      gs_item("3", x = 0, y = 4, w = 2, h = 2)
      )
    ),
  function(input, output) {}
  )
