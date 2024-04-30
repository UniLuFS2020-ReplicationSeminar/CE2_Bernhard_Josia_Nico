# clear workspace, load libraries, load data

rm(list = ls())

library(tidyverse)

# this is a new branch

load(file = "data/article_counts_covid.RData")
load(file = "data/article_counts_russia.RData")

results_covid <- results_covid %>% 
  rename(Articles_covid19 = TotalArticles)

results_russia <- results_russia %>% 
  rename(Articles_ukraine_russia = TotalArticles)

df_combined <- left_join(results_covid, results_russia, by = "WeekStart")


df_long <- df_combined %>%
  pivot_longer(cols = c(count_russia, count_covid),
               names_to = "Variable",
               values_to = "Count")


ggplot(data = df_long, aes(x = WeekStart, y = Count, color = Variable)) +
  geom_line() +
  geom_smooth(se = FALSE) +
  labs(title = "The Guardian Monthly Articles Published \non Ukraine/Russia and COVID-19", x = "Monthly Data", y = "Count", color = "Variable") +
  scale_color_manual(values = c("count_russia" = "blue", "count_covid" = "red")) +
  theme_minimal()
