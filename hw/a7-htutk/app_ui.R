# load libraries
library("shiny")
library("plotly")

source("scripts/states.R")

# histogram sider
hist_sidebar_content <- sidebarPanel(
  selectInput(
    inputId = "pop_total",
    label = "Total population of a race",
    choices = c(
      "poptotal", "popwhite", "popblack",
      "popamerindian", "popasian", "popother"
    ),
    selected = "poptotal"
  ),
  sliderInput(
    inputId = "hist_size",
    label = "Size of hist bars",
    min = 0,
    max = 1,
    value = 0.5,
    step = 0.1
  ),
  selectInput(
    inputId = "hist_color",
    label = "Color of bars",
    choices = c(
      "blue", "red", "forestgreen",
      "black", "deeppink"
    ),
    selected = "forestgreen"
  )
)

# histogram plot
hist_main_content <- mainPanel(
  plotlyOutput(
    outputId = "hist"
  )
)

# histogram "page"
hist_panel <- tabPanel(
  "Histogram",
  titlePanel("Race Popoulation in Each State"),
  sidebarLayout(
    hist_sidebar_content,
    hist_main_content
  )
)

# pie side bar
pie_sidebar_content <- sidebarPanel(
  selectInput(
    inputId = "state",
    label = "Choose a state",
    choices = states,
    selected = states[1]
  ),
  uiOutput("county_selection"),
  sliderInput(
    inputId = "hole_size",
    label = "Size of the donut hole",
    min = 0,
    max = 0.6,
    value = 0.3,
    step = 0.1
  ),
  sliderInput(
    inputId = "rotation",
    label = "Rotate the pie",
    min = 0,
    max = 360,
    value = 90,
    step = 10
  )
)

# pie chart
pie_main_content <- mainPanel(
  plotlyOutput(
    outputId = "pie"
  )
)

# pie chart "page"
pie_panel <- tabPanel(
  "Pie",
  titlePanel("Pie Chart of Race Distribution"),
  sidebarLayout(
    pie_sidebar_content,
    pie_main_content
  )
)

ui <- navbarPage(
  "Midwest Analysis",
  hist_panel,
  pie_panel
)
