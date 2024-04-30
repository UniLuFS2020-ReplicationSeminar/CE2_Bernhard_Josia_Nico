# This script gets the weekly covid-19 cases in the UK from https://ukhsa-dashboard.data.gov.uk/

# load libraries, rm workspace
rm(list = ls())

library(httr)
library(jsonlite)


# get an overview of all covid-19 related variables -----------------------

url <- "https://api.ukhsa-dashboard.data.gov.uk/themes/infectious_disease/sub_themes/respiratory/topics/COVID-19/geography_types/Nation/geographies/England/metrics"

response <- GET(url)
content <- content(response, "text")
json_overview <- fromJSON(content)




# try: COVID-19_cases_rateRollingMean -------------------------------------

url <- "https://api.ukhsa-dashboard.data.gov.uk/themes/infectious_disease/sub_themes/respiratory/topics/COVID-19/geography_types/Nation/geographies/England/metrics/COVID-19_cases_rateRollingMean"

response <- GET(url)
content <- content(response, "text")
json <- fromJSON(content)

# this gives us just one datapoint, lets add filters at the end to get more


# try to get the weekly deaths for 365 pages ------------------------------

url <- "https://api.ukhsa-dashboard.data.gov.uk/themes/infectious_disease/sub_themes/respiratory/topics/COVID-19/geography_types/Nation/geographies/England/metrics/COVID-19_deaths_ONSRegByWeek?page_size=365"

response <- GET(url)
content <- content(response, "text")
json <- fromJSON(content)

# this gives us the covid-19 deaths, but for some reason the data starts in 2021

# lets try the positivity rate, it is weekly aswell -----------------------

url <- "https://api.ukhsa-dashboard.data.gov.uk/themes/infectious_disease/sub_themes/respiratory/topics/COVID-19/geography_types/Nation/geographies/England/metrics/COVID-19_cases_lineagePercentByWeek?page_size=365"
response <- GET(url)
content <- content(response, "text")
json <- fromJSON(content)

# this variables is actually the percentage of the prevalent variants of covid-19, not the positivity rate of tests


# lets go back to the deaths and try to get the ones from 2020 ------------


url <- "https://api.ukhsa-dashboard.data.gov.uk/themes/infectious_disease/sub_themes/respiratory/topics/COVID-19/geography_types/Nation/geographies/England/metrics/COVID-19_deaths_ONSRegByWeek?year=2020"

response <- GET(url)
content <- content(response, "text")
json <- fromJSON(content)



# to add more filters, we use the params list -----------------------------

base_url_deaths <- "https://api.ukhsa-dashboard.data.gov.uk/themes/infectious_disease/sub_themes/respiratory/topics/COVID-19/geography_types/Nation/geographies/England/metrics/COVID-19_deaths_ONSRegByWeek"

q_params <- list(
  page_size = 365,
  year = 2020
)

response <- GET(base_url_deaths, query = q_params)
content <- content(response, "text")
json <- fromJSON(content)

# if i include the year it returns an empty list, maybe they dont have it, or im doing some mistake


# get the weekly death starting in 2021 -----------------------------------

base_url_deaths <- "https://api.ukhsa-dashboard.data.gov.uk/themes/infectious_disease/sub_themes/respiratory/topics/COVID-19/geography_types/Nation/geographies/England/metrics/COVID-19_deaths_ONSRegByWeek"

q_params <- list(
  page_size = 365
)

response <- GET(base_url_deaths, query = q_params)
content <- content(response, "text")
json <- fromJSON(content)

# clean the data, extract the counts and dates ----------------------------

class(json$results)

UK_weekly_death <- json$results

names(UK_weekly_death)
View(UK_weekly_death)

UK_weekly_death <- UK_weekly_death %>% 
  select(date, metric_value) %>% 
  rename(COVID_deaths_UK = metric_value) %>% 
  mutate(date = as.Date(date)) %>% 
  rename(WeekStart = date)

sapply(UK_weekly_death, class)


save(UK_weekly_death, file = "data/UK_weekly_covid_death.RData")
