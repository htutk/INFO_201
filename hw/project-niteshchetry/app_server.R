# load libraries
library("dplyr")

# source files
source("scripts/build_all_stars_map.R") # Alex
source("scripts/salary_by_position.R") # Joo
source("scripts/build_violin_salary_plot.R") # Nitesh
source("scripts/build_playoffs.R")
source("scripts/load_csv.R")
source("app_ui.R")

server <- function(input, output) {
  ## Alex ##
  output$front_page_image <- renderImage({
    return(list(src = "img/all_stars.jpg"))
  },
  deleteFile = FALSE)

  output$front_page_image_text <- renderUI({
    return(HTML(paste0(
      br(),
      h5("Fig: National League All-Stars at the 2018 All-Star Game")
    )))
  })

  output$front_page_header <- renderImage({
    return(list(src = "img/header.jpg"))
  },
  deleteFile = FALSE)

  output$team1Selection <- renderUI({
    selectInput(
      "team1",
      label = "Team 1",
      choices = c(playoff_teams %>%
        filter(input$year == Year) %>%
        select(Team))
    )
  })
  output$team2Selection <- renderUI({
    selectInput(
      "team2",
      label = "Team 2",
      choices = c(playoff_teams %>%
        filter(input$year == Year) %>%
        select(Team))
    )
  })
  output$head_to_head_function <- renderPlot({
    return(head_to_head_function(
      input$year, input$team1, input$team2,
      input$stat
    ))
  })
  output$sort_table_function <- renderDataTable({
    return(sort_table_function(function_table, input$designation))
  },
  options = list(pageLength = 10))
  output$playoff_space <- renderUI({
    return(HTML(paste0(br(), br())))
  })
  output$playoff_conclusion <- renderText({
    message <- paste(
      "A number of conclusions can be drawn from the playoff",
      "data table, head-to-head comparison chart, and scatter plot.",
      "First, it is incredibly rare for a team that makes the playoffs",
      "to be below average in any statistic.",
      "In the few instances that it occurs",
      "(e.g. 2000 Atlanta Braves in \"runs scored\"),",
      "the team compensates for said statistic with exceptional",
      "(not just above-average) performance in a different facet",
      "of the game (e.g. 4.05 team ERA, which was outstanding",
      "in the steroid era). This relationship stands even for teams",
      "that ride above league averages in every major category.",
      "Many of the World Series winners since 2000 display notable strength",
      "on one side of the ball (e.g. pitching) while sacrificing",
      "some aptitudein its counterpart, but the resounding theme is",
      "if one skill falters, another picks up the slack.",
      "This is evidenced clearly in our scatter plot, as success-defining",
      "stats like batting average and ERA suggest a positive slope",
      "when pitted against each other (a high batting average is favorable",
      "offensive production, while a high ERA denotes poor pitching;",
      "a positive trend in the graph illustrates a tradeoff between",
      "the two variables).  That said, almost every World Series winner",
      "this century has had a team ERA under 4.00 and less than",
      "half have exceeded .270 in team BA.",
      "Every organization should strive for balance in their roster,",
      "but our data implies that if a front office is able to top-load",
      "any portion of the squad, it should be the pitchers.")

    message
  })
  output$scatter_plot_function <- renderPlotly({
    return(scatter_plot_function(
      world_series_winners, input$variable1,
      input$variable2
    ))
  })

  v <- reactiveValues(data = NULL)

  observeEvent(input$all_stars_button, {
    v$data <- create_all_stars_df(
      allstar, college, school, fielding,
      input$all_stars_year, input$all_stars_position
    )
  })

  output$all_stars_map <- renderLeaflet({
    if (is.null(v$data)) return()
    plot_all_stars_map(v$data)
  })
  output$all_stars_states_table <- renderTable({
    if (is.null(v$data)) return()
    return(get_top_three_states(v$data))
  })
  output$all_stars_cities_table <- renderTable({
    if (is.null(v$data)) return()
    return(get_top_three_cities(v$data))
  })
  output$all_stars_labels1 <- renderUI({
    if (is.null(v$data)) return()
    return(HTML(paste0(
      h5("Fig: Visualization of All-Stars Talents in United States"),
      br(),
      h5("Table 1: Top Three States")
    )))
  })
  output$all_stars_labels2 <- renderUI({
    if (is.null(v$data)) return()
    return(HTML(paste0(
      br(),
      h5("Table 2: Top Three Cities")
    )))
  })

  ## Joo ##
  output$salary_by_position <- renderPlotly({
    return(salary_by_position(
      salary, batting, fielding, player,
      input$year, input$position, input$x_value
    ))
  })

  ## Nitesh ##
  output$violin_salary_plot <- renderPlotly({
    return(build_violin_salary_plot(
      salary, fielding, input$violin_year,
      input$violin_pos
    ))
  })
}
