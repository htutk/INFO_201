library(shiny)
library(dplyr)
library(plotly)

build_violin_salary_plot <- function(salary, position, year, pos) {

  # filters salary data for only selected year
  salary_df <- salary %>%
    filter(yearID == year)

  # gets column of player names for selected position and year
  # for all position
  if (pos == "All") {
    players_df <- position %>%
      filter(yearID == year) %>%
      select(playerID) %>%
      pull()
    # for specific position
  } else {
    players_df <- position %>%
      filter(yearID == year, POS == pos) %>%
      select(playerID) %>%
      pull()
  }

  # gets salaries from positions
  filtered_salary_df <- salary_df %>%
    filter(playerID %in% players_df)

  # creates title for plot based on selected year and position
  title <- paste0(
    "Baseball Player Salaries in ", year,
    " by Position: ", pos
  )

  # creates plot based on selected year and position
  filtered_salary_df %>%
    plot_ly(
      y = ~salary,
      type = "violin",
      box = list(
        visible = T
      ),
      meanline = list(
        visible = T
      ),
      x0 = paste(pos, "Players")
    ) %>%
    layout(
      title = title,
      yaxis = list(
        title = "Salary (USD)",
        zeroline = F
      ),
      margin = list(t = 50)
    )
}
