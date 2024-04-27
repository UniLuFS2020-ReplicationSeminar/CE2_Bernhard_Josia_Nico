# Libraries laden
library(ggplot2)
library(dplyr)

# Funktion zur Extraktion der Wortanzahl aus einem Dokument
get_word_count <- function(text) {
  word_count <- sum(grepl("\\bGaza\\b", text, ignore.case = TRUE))
  return(word_count)
}

# Wortanzahl für jeden Artikel extrahieren
word_counts <- sapply(results_list, function(article) {
  get_word_count(article$fields$bodyText)
})

# Datenframe erstellen mit Artikelnummern und Wortanzahl
word_count_df <- data.frame(Article = 1:length(word_counts), word_count = word_counts)

# Plot erstellen
p1 <- ggplot(data = word_count_df, aes(x = Article, y = word_count)) +
  geom_point(color = "blue", size = 3, alpha = 0.7) +
  geom_smooth(method = "loess", se = FALSE, color = "red", linetype = "dashed") +
  labs(x = "Artikel", y = "Wortanzahl von 'Gaza'", 
       title = "Wortanzahl von 'Gaza' in Artikeln",
       subtitle = "Mit glatter Trendlinie") +
  theme_minimal()

# Histogramm für die Verteilung der Wortanzahl
p2 <- ggplot(data = word_count_df, aes(x = word_count)) +
  geom_histogram(binwidth = 1, fill = "green", alpha = 0.6) +
  labs(x = "Wortanzahl von 'Gaza'", y = "Häufigkeit",
       title = "Verteilung der Wortanzahl von 'Gaza' über die Artikel",
       subtitle = "Histogramm der Wortanzahl") +
  theme_minimal()

# Plots nebeneinander anzeigen
par(mfrow=c(2,1))
print(p1)
print(p2)
