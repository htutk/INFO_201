# load library
library("dplyr")
library("httr")
library("jsonlite")
library("plotly")
library("eeptools") # to calculate age

# load api-keys
source("api-keys.R")

key <- api_pro

# set the url
base_url <- "https://api.propublica.org/congress/v1"
endpoint <- "/members"
resource_url <- paste0(base_url, endpoint)

state <- "/WA"
chamber <- "/house"
extension <- "/current.json"
final_url <- paste0(resource_url, chamber, state, extension)

# get the response from the propublica api,
# and transform it into a df
response <- GET(final_url, add_headers("X-API-Key" = key))
response_text <- content(response, type = "text")
pro_df <- fromJSON(response_text)

# retrieve the gender information
gender_df <- pro_df$results$gender
female_count <- length(gender_df[gender_df == "F"])
male_count <- length(gender_df[gender_df == "M"])

gender <- c("Males", "Females")
gender_count <- c(male_count, female_count)

# create a horizontal barchart to display
# the gender distribution among the house members
gender_plot <- plot_ly(
  x = gender_count,
  y = gender,
  type = "bar",
  orientation = "h",
  marker = list(
    color = "rgba(50, 171, 96, 0.6)",
    line = list(
      color = "rgba(50, 171, 96, 0.6)",
      width = 1
    )
  )
) %>%
  layout(
    xaxis = list(
      title = "# of Representatives",
      showline = TRUE
    ),
    title = "Representatives by Gender"
  )

# retrieve party information
party_df <- pro_df$results$party
d_count <- length(party_df[party_df == "D"])
r_count <- length(party_df[party_df == "R"])

party <- c("Democrats", "Republicans")
party_count <- c(d_count, r_count)

# create a horizontal bar chart to display
# the party distribution among house members
party_plot <- plot_ly(
  x = party_count,
  y = party,
  type = "bar",
  orientation = "h",
  marker = list(
    color = "rgba(50, 171, 96, 0.6)",
    line = list(
      color = "rgba(50, 171, 96, 0.6)",
      width = 1
    )
  )
) %>%
  layout(
    xaxis = list(
      title = "# of Representatives",
      showline = TRUE
    ),
    title = "Representatives by Party"
  )

# the first member of the house representatives
# and their info

# rep's personal info
mem <- paste0("/", pro_df$results$id[1])
mem_url <- paste0(resource_url, mem, ".json")
mem_response <- GET(mem_url, add_headers("X-API-Key" = key))
mem_df <- fromJSON(content(mem_response, type = "text"))

# rep's voting info
vote_url <- paste0(resource_url, mem, "/votes.json")
vote_response <- GET(vote_url, add_headers("X-API-Key" = key))
vote_df <- fromJSON(content(vote_response, type = "text"))

mem_df <- mem_df$results

# rep's name
name <- paste(
  mem_df$first_name,
  mem_df$middle_name,
  mem_df$last_name
)

# rep's age
dob <- as.Date(mem_df$date_of_birth)
# note that 20.888 will be rounded down to 20 years
# for legal, accurate reasons
age <- floor(age_calc(dob, units = "years"))

# rep's twitter
twitter <- mem_df$twitter_account
twitter_url <- paste0("https://twitter.com/", twitter)

# rep's voting behavior
vote_result <- vote_df[["results"]][["votes"]][[1]][["result"]]
vote_position <- vote_df[["results"]][["votes"]][[1]][["position"]]

# total number of votes retrieved from the api
# always 20
num_votes <- length(vote_result)

vote_agree <- 0

# vote is counted agreed
# if the rep votes "Yes" on "Passed" or "Agreed to" bills
# or "No" on "Failed" ones.
for (i in 1:num_votes) {
  if (
    (vote_result[i] == "Failed" & vote_position[i] == "No") |
      (vote_result[i] == "Passed" & vote_position[i] == "Yes") |
      (vote_result[i] == "Agreed to" & vote_position[i] == "Yes")) {
    vote_agree <- vote_agree + 1
  }
}

# calculate the agreement percentage
vote_agree_percent <- vote_agree / num_votes * 100
