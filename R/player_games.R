#' Download and parse all games played by one or many chess.com accounts
#'
#' @param usernames Vector of usernames from whom to download games
#'
#' @param years Vector of years from which to download games
#'
#' @return A data frame with one row per game, including the result, players, ratings, and PGN
#' @export
#'
#' @examples
#' \dontrun{
#' # to download all of Hikaru's games since 2023
#' dat <- player_games(years = 2023:2024, usernames = "hikaru")
#'
#' # to download all games by other players
#' dat <- player_games(usernames = c("jospem", "vladimirkramnik"))
#' }
player_games <- function(usernames, years = "all") {

  games <- purrr::imap(
    usernames,
    purrr::possibly(
    function(username, iter) {
      message(paste0("Downloading games from player ", username, " (", iter, "/", length(titled_players), ")"))

      get_games(username, years)
    })
  ) %>%
    data.table::rbindlist(fill = TRUE)

  # remove duplicates (when two of the players face each other)

  games <- games %>%
    unique()

  # return the big data frame

  games

}
