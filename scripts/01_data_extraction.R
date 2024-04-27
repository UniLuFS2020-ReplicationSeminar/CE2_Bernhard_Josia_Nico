# clear workspace, load libraries

rm(list = ls())

# You can register using the GitHub account. 
# Once registered, copy the API key

api_key <- rstudioapi::askForPassword()    # Paste the API key in the popup window
base_url <- "https://content.guardianapis.com/search"