# load library
library("dplyr")
library("data.table")
library("ggplot2")

salary_to_ba <- function(batting, position, salary, player) {

  # Sort by player's position
  position <- filter(position, yearID == "2016") %>%
    select(playerID, POS) %>%
    data.table() %>%
    setkey(playerID)
  position <- position[, paste(unique(POS), collapse = ", "), by = playerID]

  # Filter year matches 2016(most recent year in the data set)
  salary <- filter(salary, yearID == "2016") %>%
    select(salary, playerID, salary)

  # Join position and salary data set with batting
  # Filter to exclude pitchers
  # Extract only top 100 salaries
  combined <- left_join(batting, position, by = "playerID") %>%
    left_join(salary, by = "playerID") %>%
    filter(yearID == "2016") %>%
    rename(POS = V1) %>%
    filter(POS != "P") %>%
    top_n(100, salary)

  # Change playerID to player's real name
  player <- select(player, playerID, nameFirst, nameLast)
  combined <- left_join(combined, player, "playerID") %>%
    mutate(playerID = paste(nameFirst, nameLast)) %>%
    rename(player = playerID)

  # Make a scatter plot
  plot <- plot_ly(data = combined, type = "scatter", mode = "markers",
                  x = ~H / AB, y = ~salary,
                  marker = list(size = 7,
                                color = "rgba(116, 178, 55, 0.9)"),
                  text = ~paste("Player: ", player, "<br>Hits:", H)) %>%
    layout(title = "Top 100 Players to Batting Average",
           xaxis = list(title = "batting average"))
  plot
}