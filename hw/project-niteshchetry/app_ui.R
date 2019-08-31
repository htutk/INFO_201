# load libraries
library("shiny")
library("plotly")
library("leaflet")
library("ggplot2")
library("stringr")

# source files
source("scripts/build_playoffs.R")

front_page <- tabPanel(
  "Project Overview",
  fluidRow(
    column(2),
    column(
      8,
      includeMarkdown("markdown/overview.md"),
      htmlOutput("front_page_image_text"),
      imageOutput("front_page_image")
    ),
    column(2)
  )
)

conclusion_page <- tabPanel(
  "Conclusion",
  includeMarkdown("markdown/conclusion.md")
)

# ***ONE PAGE WITH THREE PLOTS***

# Sidebar content

chart_sidebar_content <- sidebarPanel(
  selectInput(
    "year",
    label = "Year",
    choices = 2000:2018
  ),
  uiOutput("team1Selection"),
  uiOutput("team2Selection"),
  selectInput(
    "stat",
    label = "Statistic",
    choices = choice_statistics
  )
)

table_sidebar_content <- sidebarPanel(
  selectInput(
    "designation",
    label = "Playoff Designation",
    choices = list(
      "All teams" = "All",
      "Wild Card teams" = "WCWin",
      "Division winners" = "DivWin",
      "League Championship winners" = "LgWin",
      "World Series champions" = "WSWin"
    )
  )
)

scatter_plot_sidebar_content <- sidebarPanel(
  selectInput(
    "variable1",
    label = "Variable 1",
    choices = scatter_choice_statistics
  ),
  selectInput(
    "variable2",
    label = "Variable 2",
    choices = scatter_choice_statistics
  )
)

# Main content

chart_main_content <- mainPanel(
  plotOutput("head_to_head_function")
)

table_main_content <- mainPanel(
  dataTableOutput("sort_table_function")
)

scatter_plot_main_content <- mainPanel(
  plotlyOutput("scatter_plot_function"),
  htmlOutput("playoff_space"),
  textOutput("playoff_conclusion")
)

table_layout <- sidebarLayout(
  table_sidebar_content,
  table_main_content
)

chart_layout <- sidebarLayout(
  chart_sidebar_content,
  chart_main_content
)

scatter_plot_layout <- sidebarLayout(
  scatter_plot_sidebar_content,
  scatter_plot_main_content
)

playoffs_page <- tabPanel(
  "Playoff Past Successes",
  h2("Playoff Teams Since 2000"),
  table_layout,
  h2("Head-to-Head Comparisons"),
  chart_layout,
  h2("Statistical Relationships"),
  scatter_plot_layout
)

positions_choices <- list(
  "All" = "All", "Pitcher" = "P", "First Base" = "1B", "Second Base" = "2B",
  "Shortstop" = "SS", "Third Base" = "3B", "Outfield" = "OF", "Catcher" = "C"
)

map_sidebar_content <- sidebarPanel(
  selectInput(
    inputId = "all_stars_position",
    label = h3("Position to Scout"),
    choices = positions_choices,
    selected = "P"
  ),
  selectInput(
    inputId = "all_stars_year",
    label = h3("Starting Year"),
    choices = as.character(1900:2018),
    selected = "2000"
  ),
  helpText(
    "Note: The output map and tables",
    "only feature players who have been",
    "selected as All-Stars at least once",
    "in the \"starting year\" you have chosen."
  ),
  helpText(
    "In addition, a single player may have",
    "been slotted at more than one position",
    "throughout his career; each of those",
    "positions will be counted in the results."
  ),
  actionButton("all_stars_button", "Update"),
  helpText(
    "Disclaimer: Due to API requests, plot may take up to 45 seconds to render."
  )
)

map_main_content <- mainPanel(
  leafletOutput("all_stars_map"),
  htmlOutput("all_stars_labels1"),
  tableOutput("all_stars_states_table"),
  htmlOutput("all_stars_labels2"),
  tableOutput("all_stars_cities_table")
)

map_panel <- tabPanel(
  "Scouting Talent",
  titlePanel(h2("All-Star Player Colleges")),
  sidebarLayout(
    map_sidebar_content,
    map_main_content
  )
)

salaries_scatter_side_panel <- sidebarPanel(
  sliderInput(
    "year",
    label = h3("Year"),
    min = 1985,
    max = 2016,
    value = 2016,
    sep = ""
  ),

  selectInput(
    "x_value",
    label = h3("Statistic"),
    choices = list(
      "Batting Average" = "BA",
      "On-base Percentage" = "OBP",
      "Slugging Percentage" = "SLG"
    ),
    selected = "BA"
  ),

  checkboxGroupInput(
    "position",
    label = h3("Position"),
    choices = list(
      "First Base" = "1B", "Second Base" = "2B",
      "Third Base" = "3B", "Shortstop" = "SS", "Outfield" = "OF",
      "Catcher" = "C", "Pitcher" = "P"
    ),
    selected = c("P", "1B", "2B", "3B", "SS", "OF", "C")
  )
)

salaries_scatter_main_panel <- mainPanel(
  plotlyOutput(outputId = "salary_by_position")
)

salaries_scatter_plot <- sidebarLayout(
  salaries_scatter_side_panel,
  salaries_scatter_main_panel
)

salaries_violin_side_panel <- sidebarPanel(
  # creates slider bar to choose year of salary
  sliderInput("violin_year",
    label = h3("Year"), min = 1985,
    max = 2016, value = 2016, sep = ""
  ),
  # creates dropdown selection to sort by position
  selectInput(
    inputId = "violin_pos",
    label = h3("Position"),
    choices = positions_choices
  )
)

salaries_violin_main_panel <- mainPanel(
  plotlyOutput(outputId = "violin_salary_plot")
)

salaries_violin_plot <- sidebarLayout(
  salaries_violin_side_panel,
  salaries_violin_main_panel
)

salaries_panel <- tabPanel(
  "Salaries",
  h2("Player Statistics vs. Salaries"),
  salaries_scatter_plot,
  hr(),
  h2("Player Salaries Distribution"),
  salaries_violin_plot
)

ui <- list(
  includeCSS("www/styles.css"),
  navbarPage(
    "MLB Analysis",
    front_page,
    playoffs_page,
    map_panel,
    salaries_panel,
    conclusion_page
  )
)
