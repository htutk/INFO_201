# load necessary libraries
library(dplyr)
library(leaflet)
library(plotly)

# read csv file and save it as a df
# s stands for shooting
s_df <- read.csv("data/shootings-2018.csv", stringsAsFactors = F)

# number of shootings occurred
num_of_shootings <- nrow(s_df)

# total lives lost
num_of_lives_lost <- sum(s_df$num_killed)

# total injured
num_of_injured <- sum(s_df$num_injured)

# city that was most impacted by shootings
# define 'impact'
city_with_most_shooting <- s_df %>%
  group_by(city) %>%
  summarize(occurence = n()) %>%
  filter(occurence == max(occurence)) %>%
  pull(city)

# city with most people murdered
city_with_most_killed <- s_df %>%
  group_by(city) %>%
  summarize(total_killed = sum(num_killed)) %>%
  filter(total_killed == max(total_killed)) %>%
  select(city, total_killed)

# state with most people impacted
state_with_most_impacts <- s_df %>%
  group_by(state) %>%
  summarize(total_impacts = sum(num_killed) + sum(num_injured)) %>%
  filter(total_impacts == max(total_impacts)) %>%
  select(state, total_impacts)

# summary table
# retrieve month to group by
s_df <- s_df %>%
  mutate(month = substr(as.Date(date, "%B %d, %Y"), 6, 7))
s_df$month <- month.abb[as.numeric(s_df$month)]

# create a table with monthly stats
monthly_stat <- s_df %>%
  group_by(month) %>%
  summarize(
    total_shooting = n(),
    total_killed = sum(num_killed),
    total_injured = sum(num_injured)
  ) %>%
  arrange(-total_shooting) # rearrange the occurence col


# Particular incident
# Pick the row of the dealiest shooting
shooting_most_killed <- s_df %>%
  filter(num_killed == max(num_killed))

# Interactive map
# label for popups
label <- paste0(
  "location: ", s_df$city, ", ", s_df$state,
  "<br>num killed: ", s_df$num_killed,
  "<br>num injured: ", s_df$num_injured,
  "<br>incident occurred on: ", s_df$date
)

# adjust the size based on the impacts
radius <- s_df$num_killed * 2 + s_df$num_injured

# create map with leaeflet
map <- leaflet(data = s_df) %>%
  addProviderTiles("CartoDB.Positron") %>%
  setView(lng = -96, lat = 37.8, zoom = 4) %>% # center of US
  addCircleMarkers(
    lat = ~lat,
    lng = ~long,
    popup = ~label,
    color = "red",
    radius = ~radius,
    stroke = FALSE,
    fillOpacity = 0.4
  )

# Plot
# group by state to give state-wise stats
state_stat <- s_df %>%
  group_by(state) %>%
  summarize(
    total_killed = sum(num_killed),
    total_injured = sum(num_injured)
  ) %>%
  arrange(- (total_killed + total_injured))

# df that we are interested in
s <- state_stat$state
t_k <- state_stat$total_killed
t_i <- state_stat$total_injured

# make a bar chart
state_plot <- plot_ly(
  x = ~t_i,
  y = ~ reorder(s, t_i + t_k),
  type = "bar",
  orientation = "h",
  name = "total_injured"
) %>%
  add_trace(
    x = ~t_k,
    name = "total_killed"
  ) %>%
  layout(
    xaxis = list(title = "Total impacted"),
    yaxis = list(title = "State"),
    barmode = "stack",
    title = "Total numbers of people impacted by the shooting in each state"
  ) %>%
  add_annotations( # add annontations for accessibility
    xref = "x",
    yref = "y",
    x = t_k + t_i + 5,
    y = reorder(s, t_i + t_k),
    text = paste0(t_i + t_k),
    font = list(
      family = "Arial",
      size = 12,
      color = "rgb(244, 65, 65)",
      shadow = FALSE
    ),
    showarrow = FALSE
  )
