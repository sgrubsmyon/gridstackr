library(gridstackr)

shinyApp(
  fluidPage(
    gridstack(
      initGS(),
      gs_item(tags$p("hola"), x = 0, y = 0, w = 4),
      gs_item(tags$p("chau"), x = 2, y = 2, w = 4),
      gs_item(tags$h1("chau"), x = 4, y = 0, w = 12)
      )
  ),
  function(input, output) {}
  )

|
