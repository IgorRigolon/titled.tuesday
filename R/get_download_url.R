#' Build the API URLs for each Tournament, to get games and players
#'
#' @return A character vector of API calls for each tournament
#'
get_download_url <- function() {
  tournaments <- get_tournaments()

  api_calls <- paste0("https://api.chess.com/pub/tournament/", tournaments)

  # get round numbers

  message("Building API calls")

  api_calls <- purrr::map_chr(
    api_calls,
    function(url) {
      jsonlite::read_json(url)$rounds[[1]]
    }
  )

  # group is always 1

  api_calls <- paste0(api_calls, "/1")

  # return links

  api_calls
}
