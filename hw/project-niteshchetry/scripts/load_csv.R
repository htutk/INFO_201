folder <- "data/baseballdatabank-2019.2/core"
allstar <- read.csv(
  paste0(folder, "/AllstarFull.csv"),
  stringsAsFactors = FALSE
)

college <- read.csv(
  paste0(folder, "/CollegePlaying.csv"),
  stringsAsFactors = FALSE
)

school <- read.csv(
  paste0(folder, "/Schools.csv"),
  stringsAsFactors = FALSE
)

batting <- read.csv(
  paste0(folder, "/Batting.csv"),
  stringsAsFactors = FALSE
)

salary <- read.csv(
  paste0(folder, "/Salaries.csv"),
  stringsAsFactors = FALSE
)

fielding <- read.csv(
  paste0(folder, "/Fielding.csv"),
  stringsAsFactors = FALSE
)

player <- read.csv(
  paste0(folder, "/People.csv"),
  stringsAsFactors = FALSE
)

team_stats <- read.csv(
  paste0(folder, "/Teams.csv"),
  stringsAsFactors = FALSE
)

franchises <- read.csv(
  paste0(folder, "/TeamsFranchises.csv"),
  stringsAsFactors = FALSE
)

awards <- read.csv(
  paste0(folder, "/AwardsPlayers.csv"),
  stringsAsFactors = FALSE
)

team_colors <- read.csv(
  paste0(folder, "/TeamColors.csv"),
  stringsAsFactors = FALSE
)