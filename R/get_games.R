get_games <- function(username, tt_only, years, include_pgn) {

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

      # filtering for titled tuesday games

      if (tt_only) {
        games <- games[stringr::str_detect(games$tournament, "titled-tuesday"),]
      }

      # removing PGNs if not needed

      if (!include_pgn) {
        games$pgn <- NA
      }

      # return player's games from that archive

      games
    }
  ) %>%
    data.table::rbindlist(fill = TRUE)

  games
}
