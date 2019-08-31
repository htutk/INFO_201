# A3 using data

# Before you get started, set your working directory using the Session menu

###################### Data Frame Manipulation (24 POINTS) #####################

# Create a vector `students` holding 1,000 values representing students
# They should have the values "Student 1", "Student 2",..., "Student 1000"
students <- c(paste("Student", seq(1, 1000)))

# Create a vector `math_grades` that holds 1000 random values in it
# (these represent grades in a math course)
# These values should be normally distributed with a mean of 88 and a
# standard deviation of 10
student_count <- 1000

# default rnorm() gives the results near mean and sd, but not exact.
# modified rnorm() to create random values with fixed mean and sd
rnorm_fixed <- function(n, mean, sd) {
  mean + sd * scale(rnorm(n))
}

math_grades_mean <- 88
math_grades_sd <- 10
math_grades <- rnorm_fixed(student_count, math_grades_mean, math_grades_sd)


# Replace any values in the `math_grades vector` that are above 100 with
# the number 100
math_grades <- replace(math_grades, math_grades > 100, 100)

# Create a vector `spanish` that holds 1000 random values in it
# (these represent grades in a spanish course)
# These values should be normally distributed with a mean of 85 and a
# standard deviation of 12
spanish_mean <- 85
spanish_sd <- 12
spanish_grades <- rnorm_fixed(student_count, spanish_mean, spanish_sd)

# Replace any values in the `spanish_grades` that are above 100 with
# the number 100
spanish_grades <- replace(spanish_grades, spanish_grades > 100, 100)

# Create a data.frame variable `grades` by combining
# the vectors `first_names`, `math_grades`, and `spanish_grades`
# Make sure to properly handle strings
grades <- data.frame(
  first_names = students,
  math_grades = math_grades,
  spanish_grades = spanish_grades,
  stringsAsFactors = FALSE
)

# Create a variable `num_students` that contains the
# number of rows in your dataframe `grades`
num_students <- nrow(grades)

# Create a variable `num_courses` that contains the number of columns
# in your dataframe `grades` minus one (b/c of their names)
num_courses <- ncol(grades) - 1

# Add a new column `grade_diff` to your dataframe, which is equal to
# `students$math_grades` minus `students$spanish_grades`
grades$grade_diff <- grades$math_grades - grades$spanish_grades

# Add another column `better_at_math` as a boolean (TRUE/FALSE) variable that
# indicates that a student got a better grade in math
grades$better_at_math <- grades$math_grades > grades$spanish_grades

# Create a variable `num_better_at_math` that is the number
# (i.e., one numeric value) of students better at math
num_better_at_math <- nrow(grades[grades$better_at_math, ])

# Write your `grades` dataframe to a new .csv file inside your data/ directory
# with the filename `grades.csv`. Make sure *not* to write row names.
# (you'll need to create the `data/` directory, which you can do outside of R)
write.csv(grades, "data/grades.csv", row.names = FALSE)


########################### Built in R Data (28 points) ########################

# In this section, you'll work with the `Titanic` data set
# Which is built into the R environment.
# This data set actually loads in a format called a *table*
# See https://cran.r-project.org/web/packages/data.table/data.table.pdf
# Use the `is.data.frame()` function to test if it is a table.
is.data.frame(Titanic)

# Create a variable `titanic_df` by converting `Titanic` into a data frame;
# you can use the `data.frame()` function or `as.data.frame()`
# Be sure to **not** treat strings as factors!
titanic_df <- as.data.frame(Titanic, stringsAsFactors = FALSE)

# It's important to understand the _meaning_ of each column before analyzing it
# Using comments below, describe what information is stored in each column
# For categorical variables, list all possible values
# Class: Level of tickets purchased and stay
# Sex: Sex of people on board (Male or Female)
# Age: Age bucket of people on board (Child or Adult)
# Survived: Whether a person survived the incident (Yes or No)
# Freq: The number of people that belong to that category of combination


# Create a variable `children` that are the *only* the rows of the data frame
# with information about the number children on the Titanic.
children <- titanic_df[titanic_df$Age == "Child", ]

# Create a variable `num_children` that is the total number of children.
# Hint: remember the `sum()` function!
num_children <- sum(children$Freq)

# Create a variable `most_lost` which has the *row* with the
# largest absolute number of losses (people who did not survive).
# Tip: if you want, you can use multiple statements (lines of code)
# if you find that helpful to create this variable.
all_dead <- titanic_df[titanic_df$Survived == "No", ]
most_lost <- all_dead[all_dead$Freq == max(all_dead$Freq), ]

# Define a function called `survival_rate()` that takes in two arguments:
# - a ticket class (e.g., "1st", "2nd"), and
# - the dataframe itself (it's good practice to explicitly pass in data frames)
# This function should return the following
# sentence that states the *survival rate* (# survived / # in group)
# of adult men and "women and children" in that ticketing class.
# It should read (for example):
# Of Crew class, 87% of women and children survived and 22% of men survived.
# The approach you take to generating the sentence to return is up to you.
# A good solution will likely utilize filtering to produce the required data.
# You must round values and present them as percentages in the sentence.
survival_rate <- function(class, my_df) {
  # c stands for class block
  c <- my_df[my_df$Class == class, ]
  # s stands for survived block
  s <- c[c$Survived == "Yes", ]

  # suffix 'wc' is for women and children, 'm' for men
  c_wc <- c[c$Age == "Child" | (c$Age == "Adult" & c$Sex == "Female"), ]
  c_m <- c[(c$Age == "Adult" & c$Sex == "Male"), ]

  s_wc <- s[s$Age == "Child" | (s$Age == "Adult" & s$Sex == "Female"), ]
  s_m <- s[(s$Age == "Adult" & s$Sex == "Male"), ]

  rate_wc <- round(sum(s_wc$Freq) / sum(c_wc$Freq) * 100)
  rate_m <- round(sum(s_m$Freq) / sum(c_m$Freq) * 100)

  paste0(
    "Of ", class, " class, ", rate_wc, "% of women and children ",
    "survived and ", rate_m, "% of men survived."
  )
}

# Create variables `first_survived`, `second_survived`, `third_survived` and
# `crew_survived` by passing each class and the `titanic_df` data frame
# to your `survival_rate` function
# (`Crew`, `1st`, `2nd`, and `3rd`), passing int
first_survived <- survival_rate("1st", titanic_df)
second_survived <- survival_rate("2nd", titanic_df)
third_survived <- survival_rate("3rd", titanic_df)
crew_survived <- survival_rate("Crew", titanic_df)


# What notable differences do you observe in the survival rates across classes?
# Note at least 2 observations.
# YOUR ANSWER HERE:
# 1. Unsprisingly, the 1st class has the highest total survial rates.
# 2. Crew class also has a high survival rate compared to 3rd class.
# 3. 3rd class is the only class that has less than 50 percent survival rate
# of women and children.

# What notable differences do you observe in the survival rates between the
# women and children versus the men in each group?
# Note at least 2 observations.
# YOUR ANSWER HERE
# 1. Men's survival rate is significantly lower than women and children's
# regardless of class
# 2. In 3rd class, the ratio of survival rates between women & children, and
# men is relatively small.


########################### Reading in Data (43 points)#########################
# In this section, you'll work with .csv data of life expectancy by country
# First, you should download a .csv file of Life Expectancy data from GapMinder:
# https://www.gapminder.org/data/
# You should save the .csv file into your `data` directory

# Before getting started, you should explore the GapMinder website to understand
# the *original* source of the data (e.g., who calculated these estimates)
# Place a brief summary of the each data source here (e.g., 1 - 2 sentences
# per data source)
# WRITE SUMMARY HERE
# LIKELY MULTIPLE LINES
# Period 1800 - 1970: main source: v7, by Mattias Lindgren
# Lindgren's version 7 complied data sources such as Human Mortality Database
# (HMD), UN's World Population Prospects, Historian James C Riley's publications
# and files, the Human Life-Table Database (HLD), data from national agenices,
# and other scientific literature.
#
# Human Mortality Database (HMD)
# The HMD contains the original calculations of death rates and life tables
# for national populations in 40 countries. Its goal is to record the longeity
# revolution of the modern era and to facilitate research into its causes
# and consequences
#
# UN's World Population Prospects (WPP)
# This open data source has many different datasets that can be used to
# calculate important topics which researchers may find helpful. The best
# way to browse this domain is to have an idea in mind beforehand; otherwise
# one may get lost in the sea of many different datasets.
#
# James C Riley's publications and files
# The historian Riley has published many humanities-related papers and books.
# One of his most popular books is on rising life expectancy. The gapminder
# uses many of his work to create this dataset.
#
# The Human Life-Table Database (HLD)
# HLD is developed by the same group who created HMD. HLD is basically a dataset
# that contains population life tables for many countries over many years. Note
# that some tables are not officially published by the governments, but rather
# predicted/estimated by researchers.
#
# Period 1970 - 2016: main source: IHME
# The Institute of Health Metrics and Evaluation (IHME) published Global Burden
# of Disease Study 2016. It estimated the burden of diseases, injuries and risk
# factors for 195 countries and territories. It also determines the life
# expectancy estimation and all-cause mortality.
#
# Period 2017 - 2099: main source: UN
# The downloaded csv files does not include this info, thus omitted.


# Using the `read.csv` function, read the life_expectancy_years.csv file into
# a variable called `life_exp`. Makes sure not to read strings as factors
life_exp <- read.csv(
  "data/life_expectancy_years.csv",
  stringsAsFactors = FALSE
)

# Write a function `get_col_mean()` that takes in a column name and a data frame
# and returns the mean of that column. Make sure to properly handle NA values
get_col_mean <- function(col, my_df) {
  mean(my_df[[col]], na.rm = TRUE)
}

# Create a list `col_means` that has the mean value of each column in the
# data frame (except the `Country` column). You should use your function above.
col_means <- list()

# the first position is country
for (year in colnames(life_exp[-1])) {
  col_means[[year]] <- get_col_mean(year, life_exp)
}

# Create a variable `avg_diff` that holds the difference in average country life
# expectancy between 1800 and 2018?
avg_diff <- col_means$X2018 - col_means$X1800

# Create a column `life_exp$change` that is the change
# in life expectancy from 2000 to 2018. Increases in life expectancy should
# be *positive*
life_exp$change <- life_exp$X2018 - life_exp$X2000

# Create a variable `most_improved` that is the *name* of the country
# with the largest gain in life expectancy
# Make sure to filter NA values!
most_improved_score <- max(life_exp$change, na.rm = TRUE)
most_improved <- life_exp[
  !is.na(life_exp$change) &
    life_exp$change == most_improved_score,
  "country"
]

# Create a variable `num_small_gain` that has the *number* of countries
# whose life expectance has improved less than 1 year between 2000 and 2018
# Make sure to filter NA values!
num_small_gain <- nrow(
  life_exp[!is.na(life_exp$change) &
    life_exp$change < 1, ]
)

# Write a function `country_change()` that takes in a country's name,
# two (numeric) years, and the `life_exp` dataframe as parameters.
# It should return the phrase:
# "Between YEAR1 and YEAR2, the life expectancy in COUNTRY went DIRECTION by
# SOME_YEARS years".
# Make sure to properly indictate the DIRECTION as "up" or "down"

# assume year2 is always greater than year1
country_change <- function(country, year1, year2, my_df) {
  country_row <- my_df[my_df$country == country, ]
  change <- country_row[[year2]] - country_row[[year1]]
  if (change == 0) {
    return("The life expectancy stayed the same between YEAR1 and YEAR2.")
  }

  dir <- if (change > 0) "up" else "down"
  paste0(
    "Between ", year1, " and ", year2, ", the life expectancy in ",
    country, " went ", dir, " by ", round(abs(change), 1), " years."
  )
}

# Using your `country_change()` function, create a variable `sweden_change`
# that is the change in life expectancy from 1960 to 1990 in Sweden
sweden_change <- country_change("Sweden", "X1960", "X1990", life_exp)

# Write a function `compare_change()` that takes in two country names and your
# `life_exp` data frame as parameters, and returns a sentence that describes
# their change in life expectancy from 2000 to 2018 (the `change` column)
# For example, if you passed the values "China", and "Bolivia" to you function,
# It would return this:
# "The country with the bigger change in life expectancy was China (gain=6.9),
#  whose life expectancy grew by 0.6 years more than Bolivia's (gain=6.3)."
# Make sure to round your numbers to one digit (though only after calculations!)
compare_change <- function(c1, c2, my_df) {
  c1_change <- my_df[my_df$country == c1, "change"]
  c2_change <- my_df[my_df$country == c2, "change"]

  net_change <- round(c1_change - c2_change, 1)
  c1_change <- round(c1_change, 1)
  c2_change <- round(c2_change, 1)

  if (net_change > 0) {
    first_c <- c1
    second_c <- c2
    first_change <- c1_change
    second_change <- c2_change
  } else {
    first_c <- c2
    second_c <- c1
    first_change <- c2_change
    second_change <- c1_change
  }

  paste0(
    "The country with the bigger change in life expectancy was ",
    first_c, " (gain=", first_change, "), whose life expectancy grew by ",
    abs(net_change), " years more than ", second_c,
    " (gain=", second_change, ")."
  )
}

# Using your `bigger_change()` function, create a variable `usa_or_france`
# that describes who had a larger gain in life expectancy (the U.S. or France)
usa_or_france <- compare_change("United States", "France", life_exp)

# Write your `life_exp` data.frame to a new .csv file to your
# data/ directory with the filename `life_exp_with_change.csv`.
# Make sure not to write row names.
write.csv(life_exp, "data/life_exp_with_change.csv", row.names = FALSE)
