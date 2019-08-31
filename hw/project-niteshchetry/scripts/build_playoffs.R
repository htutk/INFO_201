library("stats", warn.conflicts = FALSE)
library("shiny", warn.conflicts = FALSE)
library("ggplot2", warn.conflicts = FALSE)
library("dplyr", warn.conflicts = FALSE)
library("leaflet", warn.conflicts = FALSE)
library("plotly", warn.conflicts = FALSE)
library("rsconnect", warn.conflicts = FALSE)
library("stringr", warn.conflicts = FALSE)

source("scripts/load_csv.R")

# Create batting average, on-base percentage, slugging percentage,
# and on-base plus slugging percentage columns in team_stats dataframe
# BA: H/AB
# OBP: (H+BB+HBP)/(AB+BB+HBP+SF)
# SLG: TB/AB
# TB is needed to calculate SLG...TB given by 1*1B + 2*2B + 3*3B + 4*HR
# 1B = H-(2B+3B+HR)

# Batting average

team_stats$BA <-
  round(team_stats$H / team_stats$AB, digits = 3)

# On-base percentage

team_stats$OBP <-
  round( (team_stats$H + team_stats$BB +
    team_stats$HBP) / (team_stats$AB +
    team_stats$BB +
    team_stats$HBP +
    team_stats$SF), digits = 3)

# Slugging percentage

team_stats$X1B <- team_stats$H -
  (team_stats$X2B + team_stats$X3B +
    team_stats$HR)

team_stats$TB <- team_stats$X1B +
  2 * team_stats$X2B +
  3 * team_stats$X3B + 4 * team_stats$HR

team_stats$SLG <- round(team_stats$TB /
  team_stats$AB,
digits = 3
)

# On-base plus slugging percentage

team_stats$OPS <- round(team_stats$OBP +
  team_stats$SLG, digits = 3)

# ***PITCHING & FIELDING***

# Create WHIP column
# Total innings pitched = IPouts/3 = IP
# WHIP = (BBA+HA)/IP

team_stats$IP <- team_stats$IPouts / 3
team_stats$WHIP <- round( (team_stats$BBA +
  team_stats$HA) /
  team_stats$IP, digits = 2)

# The objective of this table is to showcase some of the most important
# pitching/fielding and hitting statistics in the game and the corresponding
# performances of playoff participants in these categories.
# To avoid information overload, I am limiting the number of statistics in
# each facet of the game to four.

# Hitting: BA, OBP, SLG, and OPS
# Pitching/Fielding: ERA, WHIP, SOA, FP

# Columns to keep (in order): yearID, W, L, R, RA, BA, OBP, SLG, OPS,
# ERA, WHIP, SOA, FP, franchName

# Join "team_stats" and "franchises" dataframes by 'franchID'

team_stats <- left_join(team_stats, franchises,
  by = "franchID"
)

# Determine column indices to omit from eventual data table

colnames(team_stats)

# Remove unnecessary columns

team_stats <- team_stats[-c(
  2:8, 16:26, 28, 30:36, 38:39, 41:48,
  51:52, 55, 58:59
)]


# Reorder columns

team_stats <- team_stats[c(1, 18, 2:7, 8:9, 13:16, 10, 17, 11:12)]

# Rename columns to make headers more professional/appropriate

colnames(team_stats)[1] <- "Year"
colnames(team_stats)[2] <- "Team"
colnames(team_stats)[9] <- "RS"

# Add run differential for additional insight purposes
# Position column right after "RA"

team_stats$DIFF <- team_stats$RS - team_stats$RA

# Reposition "DIFF" column

function_table <- team_stats[c(1:10, 19, 11:18)]
function_table <- function_table %>% filter(Year >= 2000)

# Define `playoff_teams` dataframe for future use

playoff_teams <- team_stats %>%
  filter(DivWin == "Y" | WCWin == "Y") %>%
  filter(Year >= 2000)
playoff_teams <- playoff_teams[-c(5:8)]

# ***TABLE SHOWING PLAYOFF TEAMS SINCE 2000***
# Dynamic variable is `playoff_teams`, set to show an output with either
# all division winners, wild card teams, league championship winners,
# or World Series champs

sort_table_function <- function(function_table, designation) {
  if (designation == "All") {
    status <- return(playoff_teams)
  }
  if (designation == "DivWin") {
    div_winners <- function_table %>% filter(DivWin == "Y")
    div_winners <- div_winners[-c(5:8)]
    status <- return(div_winners)
  }
  if (designation == "WCWin") {
    wild_card_teams <- function_table %>% filter(WCWin == "Y")
    wild_card_teams <- wild_card_teams[-c(5:8)]
    status <- return(wild_card_teams)
  }
  if (designation == "LgWin") {
    league_winners <- function_table %>% filter(LgWin == "Y")
    league_winners <- league_winners[-c(5:8)]
    status <- return(league_winners)
  }
  if (designation == "WSWin") {
    world_series_winners <- function_table %>% filter(WSWin == "Y")
    world_series_winners <- world_series_winners[-c(5:8)]
    status <- return(world_series_winners)
  }
  return(status)
}

# Write a function with dynamic variables to allow for interactivity

head_to_head_function <- function(year, team1, team2, stat) {
  # Alphabetize team1 and team2 in a vector
  alphabetized_teams <- sort(c(team1, team2))
  team1_abc <- alphabetized_teams[1]
  team2_abc <- alphabetized_teams[2]
  # First define new variable "stat_name" as a dplyr pull from the
  # team_stats dataframe
  stat_name <- team_stats %>% pull(stat)
  # Acquire all records for a given statistic in the selected year
  year_stats <- team_stats %>% filter(Year == year)
  # Acquire all playoff team records for a given statistic in the selected year
  playoff_stats <- playoff_teams %>% filter(Year == year)
  # Determine **league average** value for chosen statistic in the given year
  league_average <- mean(year_stats[[stat]])
  # Determine **league maximum** value for chosen statistic in the given year
  # (1.05 times this will be the upper limit of the y-axis)
  league_maximum <- max(year_stats[[stat]])
  # Determine **league minimum** value for chosen statistic in the given year
  league_minimum <- min(year_stats[[stat]])
  # Determine **playoff team average** value for chosen statistic in the given
  # year
  playoff_team_average <- mean(playoff_stats[[stat]])
  # Prepare head-to-head dataframe to transform into a bar chart
  h2h <- playoff_teams %>%
    group_by(Team) %>%
    filter(Team == team1 | Team == team2) %>%
    filter(Year == year) %>%
    select(stat)
  h2h_df <- as.data.frame(h2h)
  # Define team colors for manual fill
  team1_color <- team_colors %>%
    filter(franchName == team1_abc) %>%
    pull(Color)
  color1 <- c(paste(team1_color))
  team2_color <- team_colors %>%
    filter(franchName == team2_abc) %>%
    pull(Color)
  color2 <- c(paste(team2_color))
  # Define team1 and team2 stat values for axis tick marks
  team1_value <- h2h_df[1, 2]
  team2_value <- h2h_df[2, 2]
  team_values_vector <- c(team1_value, team2_value)
  # Construct the comparison bar chart using the h2h dataframe
  # Ensure that two horizontal dashed lines are included in the visualization;
  # these represent the league average and playoff team average for the chosen
  # statistic in the given year (red and black, respectively)
  comparison_bar_chart <- ggplot(data = h2h_df) +
    geom_col(mapping = aes(
      x = Team, y = h2h_df[, 2],
      fill = Team
    ), width = 0.4) +
    ggtitle(paste(year, team1, "vs.", team2, "in", stat)) +
    xlab("Team") + ylab(stat) +
    theme(
      plot.title = element_text(hjust = 0.5, size = 16, face = "bold.italic"),
      axis.title.x = element_text(face = "bold"),
      axis.title.y = element_text(face = "bold")
    ) +
    theme(legend.position = "none") +
    scale_fill_manual(values = c(color1, color2)) +
    geom_hline(
      yintercept = league_average, linetype = "dashed",
      col = "black"
    ) +
    geom_text(aes(0, league_average,
      label = paste(
        "League Average:",
        round(league_average,
          digits = 3
        )
      ),
      hjust = -0.1, vjust = 2
    )) +
    coord_cartesian(ylim = c(league_minimum, league_maximum))
  return(comparison_bar_chart)
}

# ***BATTING AVERAGE VS. ERA SCATTER PLOT***

# Prepare dataframe for making the scatter plot

colnames(playoff_teams)
world_series_winners <- function_table %>% filter(WSWin == "Y")

scatter_plot_function <- function(world_series_winners, variable1, variable2) {
  variable1_name <- world_series_winners %>% pull(variable1)
  variable2_name <- world_series_winners %>% pull(variable2)
  pal <- c(
    "firebrick4", "firebrick2", "blue2", "black", "deepskyblue3",
    "darkorange2", "royalblue1", "red", "midnightblue", "red",
    "darkorange1", "darkred"
  )
  scatter_plot <- plot_ly(
    data = world_series_winners, x = ~variable1_name,
    y = ~variable2_name, color = ~Team,
    colors = pal
  ) %>%
    layout(
      title = paste("World Series Winners:", variable1, "vs.", variable2),
      xaxis = list(
        title = variable1
      ),
      yaxis = list(
        title = variable2
      ),
      margin = list(t = 50)
    ) %>%
    layout(showlegend = FALSE) %>%
    add_markers(
      text = ~ paste(paste("Team:", Team),
        paste("Year:", Year),
        paste0(variable1, ":", " ", variable1_name),
        paste0(variable2, ":", " ", variable2_name),
        sep = "<br />"
      ),
      hoverinfo = "text"
    )
  return(scatter_plot)
}

# Choice statistics for bar chart

unfiltered_choice_statistics <- colnames(playoff_teams)
choice_statistics <- unfiltered_choice_statistics[-c(1:2)]

# Make list of input variables for interactivity of scatter plot

scatter_choice_statistics <- choice_statistics[-c(1:2, 13)]
