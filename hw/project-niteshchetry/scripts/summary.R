# load libraries
library("dplyr")

mvp_summary <- function(awards, players, salaries, college) {

  # get latest mvp
  latest_mvp <- awards %>%
    dplyr::filter(yearID == "2017") %>%
    dplyr::filter(awardID == "Most Valuable Player")

  # get first and last names
  latest_mvp <- latest_mvp %>%
    left_join(
      players,
      by = "playerID"
    ) %>%
    select(playerID, awardID, yearID, lgID, nameFirst, nameLast)

  # get their salaries
  latest_mvp <- latest_mvp %>%
    left_join(
      salaries,
      by = c("playerID")
    ) %>%
    select(
      playerID, awardID, yearID.x, yearID.y, lgID.x,
      nameFirst, nameLast, salary
    ) %>%
    dplyr::filter(yearID.y == "2016")

  # get their colleges they went to
  latest_mvp <- latest_mvp %>%
    left_join(
      college,
      by = c("playerID")
    )

  return(latest_mvp)
}
