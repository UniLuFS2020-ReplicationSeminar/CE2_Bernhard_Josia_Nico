# Count occurrences of the word "Gaza" in each article
article_word_count <- lapply(results_list, function(article) {
  word_count <- sum(grepl("\\bGaza\\b", article$fields$bodyText, ignore.case = TRUE))
  list(title = article$webTitle, word_count = word_count)
})

# Convert to data frame
word_count_df <- do.call(rbind, article_word_count)

# Create scatterplot
plot(1:nrow(word_count_df), word_count_df$word_count, 
     xlab = "Article", ylab = "Word Count of 'Gaza'", 
     main = "Word Count of 'Gaza' in Articles", pch = 16)
