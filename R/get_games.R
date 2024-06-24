get_games <- function(username, years) {

  # get the archives for the player

  url <- paste0("https://api.chess.com/pub/player/", username, "/games/archives")

  archives <- jsonlite::fromJSON(url)$archives

  # filtering years

  if (all(years != "all")) {
    years <- paste0("/", years, "/")

    years <- paste0(years, collapse = "|")

    archives <- archives[stringr::str_detect(archives, years)]
  }

  # looping over all the archives and downloading games

  games <- purrr::map(
    archives,
    function(archive) {
      games <- jsonlite::read_json(archive)$games

      # parsing the weird nested structure

      games <- games %>%
        purrr::map(~ unlist(.) %>% t() %>% as.data.frame()) %>%
        data.table::rbindlist(fill = TRUE)

      # return player's games from that archive

      games
    }
  ) %>%
    data.table::rbindlist(fill = TRUE)

  games
}
