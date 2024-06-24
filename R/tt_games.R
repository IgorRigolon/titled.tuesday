#' Download and parse all Titled Tuesday games, or all games played by titled players
#'
#' @param tt_only \code{TRUE} if you want only Titled Tuesday games, \code{FALSE} if you want all games played by titled players (very heavy)
#'
#' @param years Vector of years from which to download games
#'
#' @param include_pgn If \code{TRUE}, a column with the full PGN for each game will be included. This makes the data significantly heavier.
#'
#' @return A data frame with one row per game from each player's perpective, including the result, players, ratings, and PGN
#' @export
#'
#' @examples
#' \dontrun{
#' # to download all Titled Tuesday games since 2023, run
#' dat <- tt_games(years = c(2023, 2024))
#'
#' # to download all games ever played by titled players on Chess.com
#' dat <- tt_games(tt_only = FALSE, years = "all")
#'
#' # if you need the (very heavy) PGNs
#' dat <- tt_games(years = 2024, include_pgn = TRUE)
#' }
tt_games <- function(tt_only = TRUE, years = "all", include_pgn = FALSE) {

  titled_players <- get_titled_players()

  games <- purrr::imap(
    titled_players,
    function(username, iter) {
      message(paste0("Downloading games from player ", username, " (", iter, "/", length(titled_players), ")"))

      get_games(username, tt_only, years, include_pgn)
    }
  ) %>%
    data.table::rbindlist()

 # return the big data frame

  games

}
