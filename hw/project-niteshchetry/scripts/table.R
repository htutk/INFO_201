library("dplyr")
library("kableExtra")

# NOTE: The data we are using is already grouped_by.
# Thus, we never have to "group_by" manually.
table <- function(team_stats, franchises) {
  world_series_winners <- team_stats %>% filter(WSWin == "Y")
  winners_this_century <- world_series_winners %>% filter(yearID >= 2000)

  # Join "winners_this_century" and "franchises" dataframes by 'franchID'

  winners_this_century <- left_join(winners_this_century, franchises,
    by = "franchID"
  )

  # ***HITTING***

  # Create batting average, on-base percentage, slugging percentage,
  # and on-base plus slugging percentage columns
  # BA: H/AB
  # OBP: (H+BB+HBP)/(AB+BB+HBP+SF)
  # SLG: TB/AB
  # TB is needed to calculate SLG...TB given by 1*1B + 2*2B + 3*3B + 4*HR
  # 1B = H-(2B+3B+HR)

  # Batting average

  winners_this_century$BA <- round(
    winners_this_century$H / winners_this_century$AB,
    digits = 3
  )

  # On-base percentage

  winners_this_century$OBP <-
    round( (winners_this_century$H + winners_this_century$BB +
      winners_this_century$HBP) / (winners_this_century$AB +
      winners_this_century$BB +
      winners_this_century$HBP +
      winners_this_century$SF), digits = 3)

  # Slugging percentage

  winners_this_century$X1B <- winners_this_century$H -
    (winners_this_century$X2B + winners_this_century$X3B +
      winners_this_century$HR)

  winners_this_century$TB <- winners_this_century$X1B +
    2 * winners_this_century$X2B +
    3 * winners_this_century$X3B + 4 * winners_this_century$HR

  winners_this_century$SLG <- round(winners_this_century$TB /
    winners_this_century$AB,
  digits = 3
  )

  # On-base plus slugging percentage

  winners_this_century$OPS <- round(winners_this_century$OBP +
    winners_this_century$SLG, digits = 3)

  # ***PITCHING & FIELDING***

  # Create WHIP column
  # Total innings pitched = IPouts/3 = IP
  # WHIP = (BBA+HA)/IP

  winners_this_century$IP <- winners_this_century$IPouts / 3
  winners_this_century$WHIP <- round( (winners_this_century$BBA +
    winners_this_century$HA) /
    winners_this_century$IP, digits = 2)

  # The objective of this table is to showcase some of the most important
  # pitching/fielding and hitting statistics in the game and the corresponding
  # performances of World Series winners in these categories.
  # To avoid information overload, I am limiting the number of statistics in
  # each facet of the game to four.

  # Hitting: BA, OBP, SLG, and OPS
  # Pitching/Fielding: ERA, WHIP, SOA, FP

  # Columns to keep (in order): yearID, W, L, R, RA, BA, OBP, SLG, OPS,
  # ERA, WHIP, SOA, FP, franchName

  # Determine column indices to omit from eventual data table

  colnames(winners_this_century)

  # Remove unnecessary columns

  winners_this_century <- winners_this_century[-c(
    2:8, 11:14, 16:26, 28, 30:36,
    38:39,
    41:48, 50:51,
    54:55, 58
  )]

  # Reorder columns
  # yearID, franchName, W, L, R, RA, BA, OBP, SLG, OPS, ERA, WHIP, SOA, FP

  colnames(winners_this_century)
  winners_this_century <- winners_this_century[c(1, 9, 2:5, 10:13, 6, 14, 7, 8)]

  # Rename columns to make headers more professional/appropriate

  colnames(winners_this_century)[1] <- "Year"
  colnames(winners_this_century)[2] <- "Team"
  colnames(winners_this_century)[5] <- "RS"

  # Add run differential for additional insight purposes
  # Position column right after "RA"

  winners_this_century$DIFF <- paste0(
    "+",
    winners_this_century$RS -
      winners_this_century$RA
  )
  winners_this_century <- winners_this_century[c(1:6, 15, 7:14)]
  return(winners_this_century)
}
