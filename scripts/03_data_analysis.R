# clear workspace, load libraries, load data

rm(list = ls())

library(tidyverse)

load(file = "data/article_counts_covid.RData")
load(file = "data/article_counts_russia.RData")
load(file = "data/UK_weekly_covid_death.RData")

results_covid <- results_covid %>% 
  rename(Articles_covid19 = TotalArticles)

results_russia <- results_russia %>% 
  rename(Articles_ukraine_russia = TotalArticles)

df_combined <- left_join(results_covid, results_russia, by = "WeekStart")
df_comb_covid <- left_join(results_covid, UK_weekly_death, by = "WeekStart")


df_long <- df_combined %>%
  pivot_longer(cols = c(Articles_ukraine_russia, Articles_covid19),
               names_to = "Variable",
               values_to = "Count")


df_long_covid <- df_comb_covid %>%
  pivot_longer(cols = c(Articles_covid19, COVID_deaths_UK),
               names_to = "Variable",
               values_to = "Count")


ggplot(data = df_long, aes(x = WeekStart, y = Count, color = Variable)) +
  geom_line() +
  geom_smooth(se = FALSE) +
  labs(title = "The Guardian Weekly Articles Published \non Ukraine/Russia and COVID-19", x = "Monthly Data", y = "Count", color = "Variable") +
  scale_color_manual(values = c("Articles_ukraine_russia" = "blue", "Articles_covid19" = "red")) +
  theme_minimal()


ggplot(data = df_long_covid, aes(x = WeekStart, y = Count, color = Variable)) +
  geom_line() +
  geom_smooth(se = FALSE) +
  labs(title = "The Guardian Weekly Articles Published \non COVID-19 and weekly UK COVID-19 deaths", x = "Monthly Data", y = "Count", color = "Variable") +
  scale_color_manual(values = c("Articles_ukraine_russia" = "blue", "COVID_deaths_UK" = "red")) +
  theme_minimal()



