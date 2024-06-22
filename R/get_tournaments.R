#' Get list of Titled Tuesday codes from the Tournaments page <https://www.chess.com/tournament/live/titled-tuesdays>
#'
#' @param max_page Maximum number of pages to crawl through
#'
#' @return A character vector of tournament URLs
#'
get_tournaments <- function(max_page = 20) {

  base_url <- "https://www.chess.com/tournament/live/titled-tuesdays?&page="

  message("Fetching Titled Tuesday tournament URLs")

  purrr::map(
    seq_len(max_page),
    function(page) {

      url <- paste0(base_url, page)

      page <- rvest::read_html(url)

      rvest::html_nodes(page, "a.tournaments-live-name") %>%
        rvest::html_attr("href") %>%
        stringr::str_extract("([^/]+$)")
    }
  ) %>%
    unlist()
}
