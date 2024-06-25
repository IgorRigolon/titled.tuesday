#' Download Titled Tuesday players and standings
#'
#' @return A data frame with each username, the number of points scored, an indicator for the tournament winner, and the tournament URL
#' @export
#'
#' @examples
#' \dontrun{
#' standings <- tt_results()
#' }
tt_results <- function() {

  download_urls <- get_download_url()

  dat <- purrr::map(
    download_urls,
    function(url){

      message(paste("Downloading", url))

      file <- jsonlite::read_json(url)

      # the players database has a simple single level

      players <- file$players %>%
        data.table::rbindlist()

      players$tournament <- url

      players
    }
  ) %>%
    data.table::rbindlist()

  # return the data frame

  dat

}
