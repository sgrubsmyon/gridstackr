library(gridstackr)
library(highcharter)

options(highcharter.theme = hc_theme_smpl())

hc1 <- hchart(AirPassengers)
hc2 <- hchart(rnorm(300))
hc3 <- hchart(sample(letters[1:6], size = 100, prob = 1:6, replace = TRUE))
hc4 <- hchart(density(rexp(3000)), type = "area")

shinyApp(
  fluidPage(
    initGS(),
    gridstack(
      gs_item(hc1, x = 0, y = 0, w = 4),
      gs_item(hc2, x = 2, y = 2, w = 4),
      gs_item(hc3, x = 4, y = 0, w = 4),
      gs_item(hc4, x = 4, y = 4, w = 4)
    )
  ),
  function(input, output) {}
)

