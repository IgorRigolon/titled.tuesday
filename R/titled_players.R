#' Download the list of all titled usernames registered on chess.com, separated by chess title
#'
#' @return A list of character vectors with usernames, one for each chess title
#' @export
#'
#' @examples
#' \dontrun{
#' usernames <- titled_players()
#' }
titled_players <- function() {

  base_url <- "https://api.chess.com/pub/titled/"

  purrr::map(
    c("GM", "WGM", "IM", "WIM", "FM", "WFM", "NM", "WNM", "CM", "WCM"),
    function(title) {
      url <- paste0(base_url, title)

      jsonlite::fromJSON(url)$players
    }
  )
}
