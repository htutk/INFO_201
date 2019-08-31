# Final Project
Final Project can be found [here](https://htutk.shinyapps.io/mlb-analysis/).

## Domain of interest
**Why are you interested in this field/domain?**

Baseball is the most data-driven sport in the world today and has a rich recorded history of statistics. Sabermetrics to aid managerial decision-making has exploded in recent years and the methods used to evaluate players have become increasingly complex, making it a fascinating game to explore.

**What other examples of data driven projects have you found related to this domain (share at least 3)?**

1. [Fantasy Sports MLB Trade Analyzer](https://www.fantasysp.com/mlb_trade_analyzer/?fbclid=IwAR3aASX4mZMcu3b0yrOr7Tmnx6GLTKW3GIAjQgW9oi1fVzlA6Nom27KGF78) provides analysis on the favorability of dealing certain individuals in trades.

2. [Machine Learning to Predict Player Decline](http://www.baseballdatascience.com/machine-learning-to-predict-player-decline/?fbclid=IwAR1z6x4ZzHSbp1tzwBQW34Sf066BJdKkMKTm-YvZteT7zZ6ERZC4af3Dkrc) estimates the arrival of "Father Time" for various players and the accompanying reduction in performance.

3. [Tracking an increase in the number of home runs hit](https://baseballwithr.wordpress.com/?fbclid=IwAR27Q7MOaOzLgyyDFZD_IrmZYVKr0FoKBRD93xFnfMhWaWDQrboNojFkOwM) monitors a resurgence of home runs in recent years.

**What data-driven questions do you hope to answer about this domain (share at least 3)?**

1. What type of consistency do the majority of players exhibit over the course of their careers?

  Answered most effectively through visualization techniques mapping progression across the player life cycle; clear to see dips in batting average, RBIs, etc; grouping records by player and then running simple summary statistics could also illuminate consistency trends, as higher standard deviations in a certain category would indicate performance volatility.

2. High performance in which statistics translate to the greatest payoff in player salaries?

  Answered by identifying the highest-paid players and carefully observing their numbers in periods before contract renewal; a regression could be run to predict certain salaries given a specified set of stats.

3. What type of relationship, if any, exists between a player's individual performance and the number of wins his team accrues in a given season?

  A data scientist would first look to the highest-performing teams and then turn to the team's stats in aggregate. Some clubs are likely to have standout performers that account for the majority of their production, while others will feature a more balanced attack. To minimize third-variable causation, the most refined analysis should take place within the bounds of one team across years in which the roster changed little but a single player's contribution changed a lot.

4. What benchmark of team performance is requisite for making the playoffs? (The Mariners need an answer to this question.)

  Filtering league data down to only playoff teams and retrieving summary statistics for important traits like team batting average would be a good start to tackling this query.

## Finding Data

### [MLB API v6.5 by Sportradar](https://developer.sportradar.com/docs/read/baseball/MLB_v65)
**Where did you download the data (e.g., a web URL)?**

MLB v6.5 is an API provided by Sportradar, a corporation based in Switzerland that collects and analyzes sport data. It was found via a [GitHub page](https://github.com/baseballhackday/data-and-resources/wiki/Resources-and-ideas).

**How was the data collected or generated? Make sure to explain who collected the data (not necessarily the same people that -host the data), and who or what the data is about?**

Sportradar collects their own data in different fields of sports and sell access to developers for a fee. A trial authentication API key is also available.

**How many observations (rows) are in your data?**

Unlike a traditional .csv files, the API has different numbers of rows/columns depending on the query made by the developer.

**How many features (columns) are in the data?**

See the above question.

**What questions (from above) can be answered using the data in this dataset?**
- Sportradar API provides a player profile where we can analyze their consistency/performance over the years and answer the question of how their overall future will look like.

- This API has many different _datasets_ on players, stadiums, teams, pitches, runs scored. Thus, we can basically answer any type of question we may come up with in the future.

### [Baseball Databank by Sean Lahman](http://www.seanlahman.com/baseball-archive/statistics)
**Where did you download the data (e.g., a web URL)?**

Baseball Database is created by Sean Lahman, an award winning reporter for the _USA TODAY_, who collects historical databases for use in his projects. The latest database is available in his personal website(link provided above).

**How was the data collected or generated? Make sure to explain who collected the data (not necessarily the same people that -host the data), and who or what the data is about?**

Many parts of the raw data found in the database are from the work of _Pete Palmer_, a statistician who contributed in many baseball encyclopedias published since 1974. There also has been a group of researchers who volunteered to track and update the database, _Derek Adair_, _Mike Crain_, _Kevin Johnson_, to name a few.

**How many observations (rows) are in your data?**

The database contains more than 20 categories of data. And the **People.csv** has information for 19,618 players.

**How many features (columns) are in the data?**

As mentioned above, there are a lot of different categories, and each dataset has a different number of features.

**What questions (from above) can be answered using the data in this dataset?**

Various questions can be answered with this data; Finding a relationship between a player's performance and his salary tendency is one of them.

### [Moneyball](https://www.kaggle.com/wduckett/moneyball-mlb-stats-19622012)
**Where did you download the data (e.g., a web URL)?**

Moneyball is a dataset headlined under the keyword "baseball" on Kaggle.com. Its title is hyperlinked for easy access to the source.

**How was the data collected or generated? Make sure to explain who collected the data (not necessarily the same people that -host the data), and who or what the data is about?**

This particular data was collected from baseball-reference.com, perhaps the most comprehensive reservoir of the game's statistics on the Internet. MLB scouts and statisticians aggregated the information over time and have subsequently mined it to aid general managers in making informed transactions. The sabermetrics movement began with Oakland GM Billy Beane, who faced the task of delivering a winning product despite a measly organizational budget. The data spans 1962 to 2012 with a particular emphasis on overall team performance in areas such as on-base percentage, slugging, and runs for and against.  

**How many observations (rows) are in your data?**

1233

**How many features (columns) are in the data?**

15

**What questions (from above) can be answered using the data in this dataset?**

- What threshold of offensive production ensures a winning season and/or a playoff appearance?
- Does on-base percentage or slugging have a greater impact on a team's ability to win?
- How important is run differential in determining a team's longevity, including playoffs?
- How likely are Wild Card teams to win a World Series?
