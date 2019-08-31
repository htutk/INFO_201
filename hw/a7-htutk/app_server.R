# source scripts files
source("scripts/build_hist.R")
source("scripts/build_pie.R")

server <- function(input, output) {
  output$hist <- renderPlotly({
    return(build_hist(
      midwest,
      input$pop_total,
      input$hist_size,
      input$hist_color
    ))
  })
  # this is another select input,
  # which depends on inputId state
  output$county_selection <- renderUI({
    selectInput(
      inputId = "county",
      label = "Select a county",
      choices = counties(midwest, input$state)
    )
  })
  output$pie <- renderPlotly({
    return(build_pie(
      midwest,
      input$state,
      input$county,
      input$hole_size,
      input$rotation
    ))
  })
}
