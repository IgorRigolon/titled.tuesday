#' Download and parse Titled Tuesday data
#'
#' @return A list with two data frames. One ($games) contains all games, the other ($players) contains the players and standings of each tournament.
#' @export
#'
#' @examples
#' \dontrun{
#' dat <- titled_tuesday()
#' }
titled_tuesday <- function() {

  download_urls <- get_download_url()

  dat <- purrr::map(
    download_urls,
    function(url){

      message(paste("Downloading", url))

      file <- jsonlite::read_json(url, simplifyVector = TRUE)

      file$players$tournament <- url

      file
    }
  )

  # binding all tournaments

  games <- lapply(dat, function(x) x$games) %>%
    dplyr::bind_rows()

  players <- lapply(dat, function(x) x$players) %>%
    dplyr::bind_rows()

  # return a list

  list(
    "games" = games,
    "players" = players
  )

}
