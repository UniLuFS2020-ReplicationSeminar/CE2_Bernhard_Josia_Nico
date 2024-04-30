# clear workspace, load libraries

rm(list = ls())
library(httr)
library(jsonlite)
library(lubridate)

# You can register using the GitHub account. 
# Once registered, copy the API key

api_key <- rstudioapi::askForPassword()    # Paste the API key in the popup window
base_url <- "http://content.guardianapis.com/search"


# Define the date range
start_date <- as.Date("2021-09-01")
end_date <- as.Date("2022-09-01")

# Initialize a dataframe to store the results
covid_df <- data.frame(WeekStart = as.Date(character()), TotalArticles = integer())

# Loop over each week
for (week_start in seq(start_date, end_date, by = "week")) {
  
  week_end <- min(week_start + 6, end_date)  # Ensure the end date does not exceed the defined end_date
  
  # Set up API parameters for the current week
  params <- list(
    'api-key' = api_key,
    'q' = "COVID-19 OR coronavirus",
    'from-date' = as.character(week_start),
    'to-date' = as.character(week_end),
    'page-size' = 1  # We only need the total count
  )
  
  # Perform the API call
  response <- GET(base_url, query = params)
  content <- content(response, "text")
  json <- fromJSON(content)
  
  # Extract the total count of articles
  total_articles <- json$response$total
  
  # Append the results to the dataframe
  covid_df <- rbind(covid_df, data.frame(WeekStart = week_start, TotalArticles = total_articles))
  
  Sys.sleep(abs(rnorm(n = 1, mean = 1.1, sd = 0.4)))
}



