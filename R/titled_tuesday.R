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

      file <- jsonlite::read_json(url)

      # the players database has a simple single levels

      players <- file$players %>%
        data.table::rbindlist()

      # the games database has some nested weirdness

      games <- file$games %>%
        purrr::map(~ unlist(.) %>% t() %>% as.data.frame()) %>%
        data.table::rbindlist(fill = TRUE)

      # returning list with two data frames

      list(
        "games" = games,
        "players" = players
      )
    }
  )

  # binding all tournaments

  games <- lapply(dat, function(x) x$games) %>%
    data.table::rbindlist(use.names = TRUE)

  players <- lapply(dat, function(x) x$players) %>%
    data.table::rbindlist()

  # return a list

  list(
    "games" = games,
    "players" = players
  )

}
