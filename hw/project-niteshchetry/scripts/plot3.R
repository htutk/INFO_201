library(ggplot2)
library(dplyr)

get_salary_plot <- function(salaries) {

  # chooses salaries from only 2016
  salaries_table <- salaries %>%
    filter(yearID == "2016")

  # plots a violin plot of the player salaries for 2016
  salary_plot <- ggplot(salaries_table) +
    geom_violin(mapping = aes(x = yearID, y = salary)) +
    labs(
      title = "Baseball Player Salaries in MLB in 2016",
      y = "Salary (USD)"
    ) +
    theme(
      axis.text.x = element_blank(), # removes all formatting from x-axis
      axis.title.x = element_blank(),
      axis.ticks = element_blank(),
      plot.title = element_text(hjust = 0.5)
    ) + # centers plot title
    scale_y_continuous(labels = scales::comma) # displays salaries using commas

  return(salary_plot)
}