# A4 Data Wrangling

# Loading and Exploring Data -------------------------------- (**28 points**)

# To begin, you'll need to download the Kickstarter Projects data from the
# Kaggle website: https://www.kaggle.com/kemical/kickstarter-projects
# Download the `ks-projects-201801.csv` file into a new folder called `data/`

# Load the `dplyr` package
library(dplyr)

# Load your data, making sure to not interpret strings as factors
kickstarter <- read.csv(
  "data/ks-projects-201801.csv",
  stringsAsFactors = FALSE
)

# To start, write the code to get some basic information about the dataframe:
# - What are the column names?
# - How many rows is the data frame?
# - How many columns are in the data frame?
ks_cols <- colnames(kickstarter)
ks_nrow <- nrow(kickstarter)
ks_ncol <- ncol(kickstarter)

# Use the `summary` function to get some summary information
summary(kickstarter)

# Unfortunately, this doesn't give us a great set of insights. Let's write a
# few functions to try and do this better.
# First, let's write a function `get_col_info()` that takes as parameters a
# column name and a dataframe. If the values in the column are of type *double*,
# the function should return a list with the keys:
# - `min`: the minimum value of the column
# - `max`: the maximum value of the column
# - `mean`: the mean value of the column
# If the column is *not* double and there are fewer than 10 unique values in
# the column, you should return a list with the keys:
# - `n_values`: the number of unique values in the column
# - `unique_values`: a vector of each unique value in the column
# If the column is *not* double and there are 10 or *more* unique values in
# the column, you should return a list with the keys:
# - `n_values`: the number of unique values in the column
# - `sample_values`: a vector containing a random sample of 10 column values
# Hint: use `typeof()` to determine the column type
get_col_info <- function(col, my_df) {
  col_type <- typeof(my_df[[col]])
  if (col_type == "double") {
    return(list(
      min = min(my_df[[col]], na.rm = TRUE),
      max = max(my_df[[col]], na.rm = TRUE),
      mean = mean(my_df[[col]], na.rm = TRUE)
    ))
  } else {
    unique_values <- unique(my_df[[col]])
    n_values <- length(unique_values)
    if (n_values < 10) {
      return(list(
        n_values = n_values,
        unique_values = unique_values
      ))
    } else {
      sample_values <- sample(unique_values, 10)
      return(list(
        n_values = n_values,
        sample_values = sample_values
      ))
    }
  }
}

# Demonstrate that your function works by passing a column name of your choice
# and the kickstarter data to your function. Store the result in a variable
# with a meaningful name
goal_info <- get_col_info("goal", kickstarter)

# To take this one step further, write a function `get_summary_info()`,
# that takes in a data frame  and returns a *list* of information for each
# column (where the *keys* of the returned list are the column names, and the
# _values_ are the summary information returned by the `get_col_info()` function
# The suggested approach is to use the appropriate `*apply` method to
# do this, though you can write a loop
get_summary_info <- function(my_df) {
  result_list <- list()
  for (col in colnames(my_df)) {
    result_list[[col]] <- get_col_info(col, my_df)
  }
  result_list
}

# Demonstrate that your function works by passing the kickstarter data
# into it and saving the result in a variable
# ks for kickstarter
ks_cols_summary <- get_summary_info(kickstarter)

# Take note of 3 observations that you find interesting from this summary
# information (and/or questions that arise that want to investigate further)
# YOUR COMMENTS HERE
# LIKELY ON MULTIPLE LINES
# 1. The max goal is 100 million?!. Which projects have that goal?
# 2. State factor: how many have failed, succeeded, etc.
# 3. Country buckets: which country leads the chart?
#    There are only 23 countries listed. Why so little?
# 4. Category buckets: which category leads the chart?

# Asking questions of the data ----------------------------- (**29 points**)

# Write the appropriate dplyr code to answer each one of the following questions
# Make sure to return (only) the desired value of interest (e.g., use `pull()`)
# Store the result of each question in a variable with a clear + expressive name
# If there are multiple observations that meet each condition, the results
# can be in a vector. Make sure to *handle NA values* throughout!
# You should answer each question using a single statement with multiple pipe
# operations!

# What was the name of the project(s) with the highest goal?
highest_goal_name <- kickstarter %>%
  filter(goal == max(goal, na.rm = TRUE)) %>%
  pull(name)

# What was the category of the project(s) with the lowest goal?
# category, not main category
lowest_goal_category <- kickstarter %>%
  filter(goal == min(goal, na.rm = TRUE)) %>%
  pull(category)

# How many projects had a deadline in 2018?
num_proj_2018 <- nrow(
  kickstarter %>%
    filter(grepl("2018", deadline))
)

### how about "live"? Should it considered not successful?
# What proportion or projects weren't successful? Your result can be a decimal
num_successful_proj <- nrow(
  kickstarter %>%
    filter(state == "successful")
)
percent_unsuccessful <- (1 - (num_successful_proj / ks_nrow))

# What was the amount pledged for the project with the most backers?
most_backers_pledged <- kickstarter %>%
  filter(backers == max(backers, na.rm = TRUE)) %>%
  pull(usd.pledged)

# Of all of the projects that *failed*, what was the name of the project with
# the highest amount of money pledged?
highest_pledged_failed <- kickstarter %>%
  filter(state == "failed") %>%
  filter(usd.pledged == max(usd.pledged, na.rm = TRUE)) %>%
  pull(usd.pledged)

### again, how about "live" projects? 2799 total
# How much total money was pledged to projects that weren't successful?
total_pledged_unsuccessful <- sum(
  kickstarter %>%
    filter(state != "successful") %>%
    pull(usd.pledged),
  na.rm = TRUE
)

# Write (and answer) two meaningful questions of the data that can be answered
# using similar operations (`filter`, `pull`, `summarize`, `mutate`, etc.).
# 1. What is the average backers on the succesful projects?

# succ_average_backers <- mean(
#   kickstarter %>%
#   filter(state == "successful") %>%
#   pull(backers)
# )

# 2. What is the successful project with the lowest amount of backers and
#    what is its pledged amount? (NA values removed)

# succ_proj_with_least_backers <- kickstarter %>%
#   filter(state == "successful") %>%
#   filter(!is.na(usd.pledged) & !is.na(backers)) %>%
#   filter(backers == min(backers)) %>%
#   select(name, usd.pledged, backers) %>%
#   arrange(-usd.pledged)


# Performing analysis by *grouped* observations ----------------- (38 Points)

# Which category had the most money pledged (total)?
most_pledged_category <- kickstarter %>%
  group_by(category) %>%
  summarize(total_pledged = sum(usd.pledged, na.rm = TRUE)) %>%
  filter(total_pledged == max(total_pledged, na.rm = TRUE)) %>%
  pull(category)

# Which country had the most backers?
most_backers_country <- kickstarter %>%
  group_by(country) %>%
  summarize(total_backers = sum(backers, na.rm = TRUE)) %>%
  filter(total_backers == max(total_backers)) %>%
  pull(country)

# Which year had the most money pledged (hint: you may have to create a new
# column)?
### launched or deadline?
kickstarter <- mutate(kickstarter, year = substr(deadline, 1, 4))
most_pledged_year <- kickstarter %>%
  group_by(year) %>%
  summarize(total_pledged = sum(usd.pledged, na.rm = TRUE)) %>%
  filter(total_pledged == max(total_pledged, na.rm = TRUE)) %>%
  pull(year)

# What were the top 3 main categories in 2018 (as ranked by number of backers)?
ranked_backers <- kickstarter %>%
  filter(year == "2018") %>%
  group_by(main_category) %>%
  summarize(total_backers = sum(backers, na.rm = TRUE)) %>%
  arrange(-total_backers) %>%
  pull(main_category)

ranked_backers_top3_cat <- ranked_backers[1:3]

### again what to do with "live" projects?
# What was the most common day of the week on which to launch a project?
# (return the name of the day, e.g. "Sunday", "Monday"....)
kickstarter <- kickstarter %>%
  mutate(launched_day = weekdays(as.Date(substr(launched, 1, 10))))

most_launched_day <- kickstarter %>%
  group_by(launched_day) %>%
  summarize(total_launched = n()) %>%
  filter(total_launched == max(total_launched, na.rm = TRUE)) %>%
  pull(launched_day)

# What was the least successful day on which to launch a project? In other
# words, which day had the lowest success rate (lowest proportion of projects
# that were successful)? This might require some creative problem solving....
total_launched_day <- kickstarter %>%
  group_by(launched_day) %>%
  summarize(total_launched = n())

succ_launched_day <- kickstarter %>%
  filter(state == "successful") %>%
  group_by(launched_day) %>%
  summarize(total_succ_launched = n())

combined_launched_day <- left_join(
  total_launched_day,
  succ_launched_day,
  by = c("launched_day" = "launched_day") # gives a warning if omitted
)

combined_launched_day <- combined_launched_day %>%
  mutate(succ_percent = total_succ_launched / total_launched) %>%
  arrange(succ_percent)

least_succ_day <- (combined_launched_day %>%
  pull(launched_day))[1]


# Write (and answer) two meaningful questions of the data that can be answered
# by _grouping_ the data and performing summary calculations.
# 1. Which country has the most number of successful projects?
# Similarly, success rate will be a better analysis
# most_succ_country <- (kickstarter %>%
#   group_by(country) %>%
#   filter(state == "successful") %>%
#   summarize(total_succ = n()) %>%
#   arrange(-total_succ) %>%
#   pull(country))[1]
# 2. Which main category has the most failed project?
# most_failed_category <- (kickstarter %>%
#   filter(state == "failed") %>%
#   group_by(main_category) %>%
#   summarize(total_failed = n()) %>%
#   arrange(-total_failed) %>%
#   pull(main_category))[1]
