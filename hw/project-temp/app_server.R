# load libraries

# source
source("scripts/build_all_stars_map.R")
source("scripts/load_csv.R")


server <- function(input, output) {
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
      h5("Table 1: Top Three States"))
    ))
  })
  output$all_stars_labels2 <- renderUI({
    if (is.null(v$data)) return()
    return(HTML(paste0(
      br(),
      h5("Table 2: Top Three Cities"))
    ))
  })
}
