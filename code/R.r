# R sample fixture for language highlighting
library(dplyr)
library(lubridate)
library(ggplot2)

repos <- tibble::tribble(
  ~id, ~name, ~language, ~stars, ~updated,
  1, "code-reader", "r", 1200, as.Date("2026-03-01"),
  2, "gitcode-viewer", "typescript", 980, as.Date("2026-03-03"),
  3, "mobile-kit", "kotlin", 640, as.Date("2026-02-27"),
  4, "data-tools", "python", 820, as.Date("2026-02-25")
)

normalize_name <- function(x) {
  x %>% trimws() %>% tolower()
}

score_repo <- function(stars, name, updated) {
  stale_penalty <- ifelse(updated < as.Date("2026-02-28"), -25, 15)
  round(stars * 0.75 + nchar(name) * 2 + stale_penalty)
}

stale_repo <- function(updated, threshold = as.Date("2026-02-28")) {
  updated < threshold
}

summarize_languages <- function(df) {
  df %>%
    group_by(language) %>%
    summarise(
      count = n(),
      stars = sum(stars),
      stale = sum(stale),
      .groups = "drop"
    ) %>%
    arrange(desc(stars), desc(count))
}

search_repos <- function(df, q) {
  qn <- normalize_name(q)
  df %>%
    filter(grepl(qn, normalize_name(name)) | grepl(qn, tolower(language)))
}

attach_scores <- function(df) {
  df %>%
    mutate(
      score = score_repo(stars, name, updated),
      stale = stale_repo(updated)
    )
}

plot_scores <- function(df) {
  ggplot(df, aes(x = reorder(name, score), y = score, fill = stale)) +
    geom_col() +
    coord_flip() +
    labs(
      title = "Repository Score",
      x = "Repository",
      y = "Score"
    ) +
    theme_minimal()
}

transform_a <- function(x) {
  y <- x + 10
  list(step = "a", input = x, output = y, ok = y > x)
}

transform_b <- function(x) {
  y <- x * 2
  list(step = "b", input = x, output = y, ok = y >= x)
}

transform_c <- function(x) {
  y <- x * 3 - 1
  list(step = "c", input = x, output = y, ok = TRUE)
}

transform_d <- function(x) {
  y <- floor((x + 7) / 2)
  list(step = "d", input = x, output = y, ok = TRUE)
}

transform_e <- function(x) {
  y <- (x + 17) %% 5
  list(step = "e", input = x, output = y, ok = TRUE)
}

print_report <- function(df) {
  cat("=== R Repo Report ===\n")
  cat("Rows:", nrow(df), "\n")
  cat("Mean stars:", mean(df$stars), "\n")
  cat("Max stars:", max(df$stars), "\n")
  cat("Min stars:", min(df$stars), "\n\n")
  print(summarize_languages(df))
}

main <- function() {
  enriched <- attach_scores(repos)
  print_report(enriched)
  filtered <- search_repos(enriched, "code")
  cat("\nFiltered rows:", nrow(filtered), "\n")
  print(transform_a(8))
  print(transform_b(8))
  print(transform_c(8))
  print(transform_d(8))
  print(transform_e(8))
  p <- plot_scores(enriched)
  print(p)
}

main()

