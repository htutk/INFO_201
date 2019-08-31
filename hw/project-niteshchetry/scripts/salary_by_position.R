library("dplyr")
library("data.table")
library("plotly")

salary_by_position <- function(salary, batting, position, player,
                               year, pos, x_value) {

  # Sort by player's position
  position <- filter(position, yearID == toString(year)) %>%
    select(playerID, POS) %>%
    data.table() %>%
    setkey(playerID)
  position <- position[, paste(unique(POS), collapse = ", "), by = playerID]

  # Filter year matches 2016(most recent year in the data set)
  salary <- filter(salary, yearID == toString(year)) %>%
    select(salary, playerID, salary)

  # Join position and salary data set with batting
  # Filter to exclude pitchers
  # Extract only top 100 salaries
  combined <- left_join(batting, position, by = "playerID") %>%
    left_join(salary, by = "playerID") %>%
    filter(yearID == toString(year)) %>%
    rename(POS = V1) %>%
    filter(POS %in% pos) %>%
    top_n(100, salary)

  # Change playerID to player's real name
  player <- select(player, playerID, nameFirst, nameLast)
  combined <- left_join(combined, player, "playerID") %>%
    mutate(playerID = paste(nameFirst, nameLast)) %>%
    rename(player = playerID)

  variable <- x_value
  if (x_value == "BA") {
    x_value <- combined$H / combined$AB
  } else if (x_value == "OBP") {
    x_value <- (combined$H + combined$BB + combined$HBP) /
      (combined$AB + combined$BB + combined$HBP + combined$SF)
  } else if (x_value == "SLG") {
    X1B <- combined$H - (combined$X2B + combined$X3B + combined$HR)
    TB <- X1B + 2 * combined$X2B + 3 * combined$X3B + 4 * combined$HR
    x_value <- TB / combined$AB
  }

  # Make a scatter plot
  plot <- plot_ly(
    data = combined,
    type = "scatter",
    mode = "markers",
    x = ~x_value, y = ~salary,
    hoverinfo = "text",
    marker = list(size = 7, color = "rgba(116, 178, 55, 0.9)"),
    text = ~paste0(
      "Player: ",
      player, "<br>",
      variable, ": ",
      round(x_value, 3),
      "<br>", "Salary: $",
      salary)) %>%
    layout(title = paste0("100 Top Players in ", variable),
           xaxis = list(title = variable),
           yaxis = list(title = "Salary (USD)"),
           margin = list(t = 50))
  plot
}
