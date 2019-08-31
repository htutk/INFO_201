# load libraries
library("shiny")
library("leaflet")
library("shinythemes")

# source
positions_choices <- c("All", "P", "1B", "2B", "SS", "3B", "OF", "C")

map_sidebar_content <- sidebarPanel(
  selectInput(
    inputId = "all_stars_position",
    label = "Choose a position to scout",
    choices = positions_choices,
    selected = "P"
  ),
  selectInput(
    inputId = "all_stars_year",
    label = "Choose the starting year",
    choices = as.character(1900:2018),
    selected = "2000"
  ),
  helpText("Note: The output map and tables",
           "only feature the players who have been",
           "selected as all-stars at least once",
           "the \"starting year\" you have chosen."),
  helpText("Also, a single player may have played",
           "different positions throughout his carreer;",
           "all of them will be counted towards the results."),
  actionButton("all_stars_button", "Update")
)

map_main_content <- mainPanel(
  leafletOutput("all_stars_map"),
  htmlOutput("all_stars_labels1"),
  tableOutput("all_stars_states_table"),
  htmlOutput("all_stars_labels2"),
  tableOutput("all_stars_cities_table")
)

map_panel <- tabPanel(
  "Scouting Talents",
  titlePanel("Where did All-stars players play in college?"),
  sidebarLayout(
    map_sidebar_content,
    map_main_content
  )
)

ui <- navbarPage(
  theme = shinytheme("superhero"),
  "",
  map_panel
)