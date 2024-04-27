#This is a script for a gglot2 plot of the data.
ggplot2::ggplot(data = data, aes(x = x, y = y)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Scatterplot of x and y",
       x = "x",
       y = "y") +
  theme_minimal()
```

```r