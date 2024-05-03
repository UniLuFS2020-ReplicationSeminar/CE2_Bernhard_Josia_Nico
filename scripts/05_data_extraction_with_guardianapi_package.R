
# clear workspace, load libraries

rm(list = ls())

library(httr)
library(jsonlite)
library(lubridate)

# added this library
library(guardianapi)

# load api key and base_url, set to search to find content
api_key <- gu_api_key() # this will prompt you to enter your API key
base_url <- "https://content.guardianapis.com/search"

# define the start and end date, both are chosen as a monday
start_date <- as.Date("2021-01-01")
end_date <- as.Date("2024-04-05")


# test whether we can get every start and end date of each week for the for loop later
week_dates <- seq(from = start_date, to = end_date, by = "week")

for(week_start in week_dates) {
  print(as.Date(week_start))
  
  end_date = week_start +7
  print(as.Date(end_date))
  cat("\n")
}


# init df to store covid results
results_covid <- data.frame(WeekStart = as.Date(character()), TotalArticles = integer())

# Loop over each week
for (week_start in week_dates) {


  week_end = week_start + 7
  
  # Set up API parameters for the current week
  params <- list(
    'api-key' = api_key,
    'q' = "COVID-19 OR coronavirus",
    'from-date' = as.character(as.Date(week_start)),
    'to-date' = as.character(as.Date(week_end))
  )
  
  # Perform the API call
  response <- GET(base_url, query = params)
  if (status_code(response) == 200) {
    content <- content(response, "text")
    json <- fromJSON(content)
    total_articles <- json$response$total
    
    # Append the results to the dataframe
    results_covid <- rbind(results_covid, data.frame(WeekStart = as.Date(week_end), TotalArticles = total_articles))
    
    # Debug output
    print(paste("Week starting:", as.Date(week_start), "- Total Articles:", total_articles))
  } else {
    print(paste("Failed to retrieve data for week starting:", as.Date(week_start)))
    
    
  }
  
  Sys.sleep(abs(rnorm(n = 1, mean = 1.5, sd = 0.4)))
}  


save(results_covid, file = "data/article_counts_covid.RData")

# init df to store russian/ukraine results
results_russia <- data.frame(WeekStart = as.Date(character()), TotalArticles = integer())

# Loop over each week
for (week_start in week_dates) {
  
  
  week_end = week_start + 7
  
  # Set up API parameters for the current week
  params <- list(
    'api-key' = api_key,
    'q' = "Russia OR Ukraine",
    'from-date' = as.character(as.Date(week_start)),
    'to-date' = as.character(as.Date(week_end))
  )
  
  # Perform the API call
  response <- GET(base_url, query = params)
  if (status_code(response) == 200) {
    content <- content(response, "text")
    json <- fromJSON(content)
    total_articles <- json$response$total
    
    # Append the results to the dataframe
    results_russia <- rbind(results_russia, data.frame(WeekStart = as.Date(week_end), TotalArticles = total_articles))
    
    # Debug output
    print(paste("Week starting:", as.Date(week_end), "- Total Articles:", total_articles))
  } else {
    print(paste("Failed to retrieve data for week starting:", as.Date(week_end)))
    
    
  }
  
  Sys.sleep(abs(rnorm(n = 1, mean = 1.5, sd = 0.4)))
}  

save(results_russia, file = "data/article_counts_russia.RData")




