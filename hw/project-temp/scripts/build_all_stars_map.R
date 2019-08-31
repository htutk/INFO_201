# load libraries
library("httr")
library("jsonlite")
library("dplyr")
library("grDevices")

# source api key
source("api-keys.R")


# given 'location', returns a vecotr of lat, lon
# uses google maps geocoding api
geocoder <- function(location) {
  base_uri <- "https://maps.googleapis.com"
  endpoint <- "/maps/api/geocode/json"
  resource_url <- paste0(base_uri, endpoint)
  query_params <- list(
    address = location,
    key = api_google
  )

  response <- GET(resource_url, query = query_params)
  df <- fromJSON(
    content(response, type = "text", encoding = "UTF-8")
  )

  coord <- df$results$geometry$location

  return(c(coord$lat, coord$lng))
}

create_all_stars_df <- function(
  allstar, college, school, fielding, year, position) {
  # filter all star players since 2000
  allstar_after_2000 <- allstar %>%
    filter(yearID >= year)

  # get all the unique all star players
  allstar_after_2000 <- unique(allstar_after_2000$playerID)

  # join the players with college
  # NOTE: all colleges are in U.S.
  # thus non-American all-star will be removed
  # from the results.
  allstar_after_2000 <- college %>%
    filter(playerID %in% allstar_after_2000) %>%
    select(playerID, schoolID)

  # filter unique pair of (player, college)
  # NOTE: a player may go to more than one colleges
  # and thus, they may have more than one pair.
  allstar_after_2000 <- unique(allstar_after_2000)

  # join allstar_after_2000 with school for locations
  allstar_after_2000 <- allstar_after_2000 %>%
    left_join(school, by = "schoolID") %>%
    select(playerID, schoolID, city, state)

  allstar_after_2000 <- allstar_after_2000 %>%
    mutate(city_state = paste0(city, ", ", state))


  # add a column of their positions
  allstar_after_2000 <- allstar_after_2000 %>%
    left_join(fielding, by = "playerID") %>%
    select(playerID, schoolID, city, state, city_state, POS) %>%
    unique()

  if (position != "All") {
    allstar_after_2000 <- allstar_after_2000 %>%
      filter(POS == position)
  }
  allstar_after_2000
}

plot_all_stars_map <- function(my_df) {
  # summary table to include the total number
  # of the players from each city
  summary <- my_df %>%
    group_by(city_state) %>%
    summarize(total = n())

  # get coordinates from geocoder()
  summary$coord <- lapply(
    summary$city_state,
    geocoder
  )

  summary$lat <- c()
  summary$lon <- c()

  for (i in 1:nrow(summary)) {
    summary$lat[i] <- summary$coord[[i]][1]
    summary$lon[i] <- summary$coord[[i]][2]
  }

  pal <- colorNumeric(
    palette = grDevices::heat.colors(4, 0.75),
    domain = summary$total
  )

  popup <- paste0(
    "Location: ", summary$city_state,
    "<br>Total Players: ", summary$total
  )

  map <- leaflet(summary) %>%
    addProviderTiles("CartoDB.Positron") %>%
    setView(lng = -96, lat = 37.8, zoom = 4) %>%
    addCircleMarkers(
      lat = ~lat,
      lng = ~lon,
      popup = ~popup,
      color = ~ pal(total),
      radius = ~ (summary$total * 3),
      stroke = FALSE,
      fillOpacity = 0.75
    ) %>%
    addLegend(
      "bottomright",
      pal = pal,
      values = ~ summary$total,
      title = "Number of Players",
      opacity = 0.7
    )
}

# retrieve the state with most all-stars
get_top_three_states <- function(my_df) {
  my_df <- my_df %>%
    group_by(state) %>%
    summarize(total = n()) %>%
    arrange(-total)

  colnames(my_df) <- c("State", "Number of Players")

  return(head(my_df, 3))
}

# retrieve the city with most all-stars
get_top_three_cities <- function(my_df) {
  my_df <- my_df %>%
    group_by(city_state) %>%
    summarize(total = n()) %>%
    arrange(-total)

  colnames(my_df) <- c("City", "Number of Players")

  return(head(my_df, 3))
}
