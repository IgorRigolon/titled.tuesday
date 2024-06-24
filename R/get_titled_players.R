get_titled_players <- function() {

  base_url <- "https://api.chess.com/pub/titled/"

  usernames <- purrr::map(
    c("GM", "WGM", "IM", "WIM", "FM", "WFM", "NM", "WNM", "CM", "WCM"),
    function(title) {
      url <- paste0(base_url, title)

      jsonlite::fromJSON(url)$players
    }
  ) %>%
    unlist()

  usernames
}
