# load library
library("dplyr")
library("plotly")
library("httr")
library("jsonlite")

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

  response <- httr::GET(resource_url, query = query_params)
  df <- jsonlite::fromJSON(
    httr::content(response, type = "text", encoding = "UTF-8")
  )

  coord <- df$results$geometry$location

  return(c(coord$lat, coord$lng))
}

allstar_plot <- function(allstar, college, school) {
  # filter all star players since 2000
  allstar_after_2000 <- allstar %>%
    dplyr::filter(yearID >= "2000")

  # get all the unique all star players
  allstar_after_2000 <- unique(allstar_after_2000$playerID)

  # join the players with college
  # NOTE: all colleges are in U.S.
  # thus non-American all-star will be removed
  # from the results.
  allstar_after_2000 <- college %>%
    dplyr::filter(playerID %in% allstar_after_2000) %>%
    select(playerID, schoolID)

  # filter unique pair of (player, college)
  # NOTE: a player may go to more than one colleges
  # and thus, they may have more than one pair.
  allstar_after_2000 <- unique(allstar_after_2000)

  # join allstar_after_2000 with school for locations
  allstar_after_2000 <- allstar_after_2000 %>%
    left_join(school, by = "schoolID") %>%
    select(playerID, schoolID, city, state) %>%
    mutate(city_state = paste0(city, ", ", state))

  # summary table to include the total number
  # of the players from each city
  summary <- allstar_after_2000 %>%
    group_by(city_state) %>%
    summarize(total = n())

  # get coordinates from geocoder()
  summary$coord <- lapply(
    summary$city_state,
    geocoder
  )

  for (i in 1:nrow(summary)) {
    summary$lat[i] <- summary$coord[[i]][1]
    summary$lon[i] <- summary$coord[[i]][2]
  }

  # scatter plot
  # size and color defines the total number
  g <- list(
    scope = "usa",
    projection = list(type = "albers usa"),
    showland = TRUE,
    showlakes = FALSE,
    countrycolor = toRGB("gray85")
  )

  plot <- plot_geo(
    summary,
    lat = ~lat,
    lon = ~lon
  ) %>%
    add_markers(
      text = ~ paste(
        "Location: ", city_state, "<br>",
        "Total: ", total
      ),
      color = ~total,
      symbol = I("circle"),
      size = ~ total * 50,
      hoverinfo = "text"
    ) %>%
    colorbar(title = "Total Number of All-Stars") %>%
    layout(
      title = "All-Star Players by State Since 2000",
      geo = g
    )
  return(plot)
}
