# load library
library("dplyr")
library("httr")
library("jsonlite")

# load api-keys
source("api-keys.R")

# set the address and api key
address <- "6837 S 124th St, Seattle, WA 98178"
key <- api_civic

# set the url
base_url <- "https://www.googleapis.com/civicinfo/v2"
endpoint <- "/representatives"
query_params <- list(
  address = address,
  key = key
)
resource_url <- paste0(base_url, endpoint)

# get the response from the civic api
# and transform it into a df
response <- GET(resource_url, query = query_params)
response_text <- content(response, type = "text")
civic_df <- fromJSON(response_text)

# officials is the df we need
officials <- civic_df$officials

# add the columns with appropraite formats
# Name: a hyperlink to their websites if available
# Email: a hyperlink to their emails if available
# Phone: a phone number if available
# Photo: a portrait photo if available
officials <- officials %>%
  mutate(
    Name = ifelse(urls == "NULL",
      name,
      paste0("[", name, "](", urls, ")")
    ),
    Email = ifelse(emails == "NULL",
      "Not Available",
      emails
    ),
    Phone = ifelse(phones == "NULL",
      "Not Available",
      phones
    ),
    Photo = ifelse(!is.na(photoUrl),
      paste0("![", name, "](", photoUrl, ")"),
      "Not Available"
    )
  )

# retrieve the representatives' offices
offices <- civic_df$offices

num_to_rep <- unlist(lapply(civic_df$offices$officialIndices, length))
expanded <- offices[rep(row.names(offices), num_to_rep), ]

officials <- officials %>% mutate(index = row_number() - 1)

expanded <- expanded %>%
  mutate(index = row_number() - 1) %>%
  rename(position = name)

# left join by index
officials <- left_join(officials, expanded, by = "index")

# the final talbe to be displayed
officials_kable <- officials %>%
  select(Name, position, party, Email, Phone, Photo) %>%
  rename(Position = position, Party = party)
