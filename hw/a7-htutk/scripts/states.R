library("dplyr")
library("ggplot2")

# get the different states as a vector
states <- midwest %>%
  select(state) %>%
  unique()

states <- unlist(states$state)
