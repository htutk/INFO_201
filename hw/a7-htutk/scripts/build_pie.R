# load libraries
library("dplyr")
library("plotly")

# given a state1, get its all counties
counties <- function(midwest, state1) {
  counties <- midwest %>%
    dplyr::filter(state == state1) %>%
    select(county) %>%
    unique()

  return(unlist(counties$county))
}

# all races labels
labels_names <- c(
  "white%", "black%", "american-indian%",
  "asian%", "other%"
)

# make a pie chart
build_pie <- function(midwest, state1, county1, hole_size, rotation1) {
  row <- midwest %>%
    dplyr::filter(state == state1) %>%
    dplyr::filter(county == county1)

  # get the percents
  values_counts <- c(
    row$percwhite, row$percblack, row$percamerindan,
    row$percasian, row$percother
  )

  plot <- plot_ly(
    labels = labels_names,
    values = values_counts,
    rotation = as.numeric(rotation1)
  ) %>%
    add_pie(hole = as.numeric(hole_size)) %>%
    layout(
      title = paste0(
        "Visualization of Race Distribution in ",
        county1, ", ", state1
      ),
      showlegend = TRUE,
      xaxis = list(
        showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE
      ),
      yaxis = list(
        showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE
      )
    )
}
