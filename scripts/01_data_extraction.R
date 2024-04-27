# clear workspace, load libraries

rm(list = ls())
library(httr)
library(jsonlite)

# You can register using the GitHub account. 
# Once registered, copy the API key

api_key <- rstudioapi::askForPassword()    # Paste the API key in the popup window
base_url <- "https://content.guardianapis.com/search"

params <- list(
  'api-key' = api_key,
  'q' = "gaza",
  'from-date' = "2023-01-01",
  'to-date' = "2023-12-31",
  'show-fields' = "all",  # Retrieve all available fields
  'page' = 50  # Pagination parameter
  )


response <- GET(base_url, query = params)


# Check if the request was successful
if (status_code(response) == 200) {
  content <- content(response, "text", encoding = "UTF-8")
  data <- fromJSON(content)
  
  # Extract relevant data from the response
  articles <- data$response$results
  print(articles)
} else {
  print(paste("Failed to fetch data: HTTP status code", status_code(response)))
}

# Convert data frame to a list of lists
results_list <- split(data$response$results, seq(nrow(data$response$results)))

# Now use lapply on the list of lists
article_details <- lapply(results_list, function(article) {
  list(
    title = article$webTitle,
    url = article$webUrl,
    body = article$fields$bodyText  # Check the correct field name
  )
})

# Print article details
print(article_details)

