library("dplyr")
library("plotly")
library("stringr")

build_hist <- function(midwest, variable, size, color) {
  var <- c(variable)
  # summarize with the desired variable
  summary <- midwest %>%
    group_by(state) %>%
    summarize(total = sum(get(var)))

  # create the plot
  p <- plot_ly(summary) %>%
    add_bars(
      x = ~state,
      y = ~total,
      color = I(color),
      width = as.numeric(size)
    ) %>%
    layout(
      yaxis = list(title = paste(variable, "count")),
      title = paste(str_to_title(variable), "Count Per Each State")
    )
}
