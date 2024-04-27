# clear workspace, load libraries

rm(list = ls())
library(httr)
library(jsonlite)

# Function to fetch and save articles with a specific search term and title suffix
fetch_and_save_articles <- function(search_term, title_suffix) {
  api_key <- rstudioapi::askForPassword()    # Paste the API key in the popup window
  base_url <- "https://content.guardianapis.com/search"
  
  params <- list(
    'api-key' = api_key,
    'q' = search_term,
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
    
    # Convert data frame to a list of lists
    results_list <- split(data$response$results, seq(nrow(data$response$results)))
    
    # Now use lapply on the list of lists
    article_details <- lapply(results_list, function(article) {
      list(
        title = paste(article$webTitle, title_suffix),  # Append the title suffix
        url = article$webUrl,
        body = article$fields$bodyText,  # Check the correct field name
        date = article$webPublicationDate  # Add the publication date
      )
    })
    
    # Save article details to a file with the specified title suffix
    saveRDS(article_details, paste0("articles_", title_suffix, ".rds"))
    
  } else {
    print(paste("Failed to fetch data: HTTP status code", status_code(response)))
  }
}

# Fetch and save articles related to "gaza" with title suffix ".ga"
fetch_and_save_articles("gaza", ".ga")

# Fetch and save articles related to "israel" with title suffix ".is"
fetch_and_save_articles("israel", ".is")

# Load the saved articles into global environment
articles_ga <- readRDS("articles_.ga.rds")
articles_is <- readRDS("articles_.is.rds")

# Print loaded articles
print(articles_ga)
print(articles_is)
