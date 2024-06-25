#' Download and parse all Titled Tuesday games
#'
#' @param years Vector of years from which to download games
#'
#' @return A data frame with one row per game
#' @export
#'
#' @examples
#' \dontrun{
#' # download all TT games since 2023
#' tt <- tt_games(years = c(2023, 2024))
#' }
tt_games <- function(years = "all") {

  # bind global variables

  . <- V1 <- game_id <- NULL

  # list of all files to potentially download

  files <- c(
    paste0(
      "https://raw.github.com/IgorRigolon/titled.tuesday/master/data-raw/",
      2014:2022,
      ".zip"
    ),
    "https://raw.github.com/IgorRigolon/titled.tuesday/master/data-raw/2023.1.zip",
    "https://raw.github.com/IgorRigolon/titled.tuesday/master/data-raw/2023.2.zip",
    "https://raw.github.com/IgorRigolon/titled.tuesday/master/data-raw/2024.1.zip"
  )

  # converting years into regex condition

  years <- paste0(years, collapse = "|")

  # filtering only the years chosen

  if (any(years != "all")) {
    files <- files[stringr::str_detect(files, years)]
  }

  # downloading them

  dir <- tempdir()

  purrr::map(
    files,
    function(url) {
      temp <- tempfile(tmpdir = dir, fileext = ".zip")

      download.file(url, temp)

      unzip(temp, exdir = dir)
    }
  )

  # read all PGNs

  files <- list.files(dir, pattern = "*.pgn", full.names = TRUE, recursive = TRUE)

  dat <- purrr::map(
    files,
    function(file) {
      tournament <- stringr::str_extract(file, "[^/]+$")

      message(paste("Reading tournament", tournament))

      pgn <- read.table(file, quote= "", sep= "\n", stringsAsFactors = FALSE)

      pgn$file <- tournament

      # create a game id

      pgn <- pgn %>%
        dplyr::mutate(game_id = ifelse(stringr::str_detect(V1, "\\[Event"), 1, 0)) %>%
        dplyr::mutate(game_id = cumsum(game_id))

      # first extract the moves

      moves <- pgn %>%
        dplyr::filter(!stringr::str_detect(V1, "^\\["))

      # collapse all PGNs of each game

      moves <- moves %>%
        split(moves$game_id) %>%
        purrr::map_chr(~ paste(unlist(.$V1), collapse = ""))

      # now deal with non-moves

      info <- pgn %>%
        dplyr::filter(stringr::str_detect(V1, "^\\["))

      # get the variable names

      cnames <- info$V1 %>%
        sub("\\[(\\w+).+", "\\1", .) %>%
        unique()

      # get the values

      pgn <- data.frame(matrix(sub("\\[\\w+ \\\"(.+)\\\"\\]", "\\1", info$V1),
                                byrow=TRUE, ncol=length(cnames)))

      # add column names

      names(pgn) <- cnames

      # adding other columns

      pgn$moves <- moves

      pgn$file <- tournament

      # return

      pgn
    }
  ) %>%
    data.table::rbindlist()

  # clear temp files

  unlink(file.path(dir, "*"), recursive = TRUE)

  # return

  dat

}
