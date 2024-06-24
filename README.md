
<!-- README.md is generated from README.Rmd. Please edit that file -->

# titled.tuesday

<!-- badges: start -->
<!-- badges: end -->

The `titled.tuesday` R package is an interface with the [Chess.com
API](https://www.chess.com/news/view/published-data-api). It’s capable
of downloading and parsing data such as:

- Titled Tuesday standings;

- Titled Tuesday games, including the players, their ratings, and even
  accuracy scores;

- All games ever played by titled players on chess.com;

- All games ever played by any particular player, such as yourself.

If you just want the data, it is stored in the [data-raw
folder](https://github.com/IgorRigolon/titled.tuesday/tree/main/data-raw).

## Installation

You can install the development version of `titled.tuesday` from GitHub
with:

``` r
install.packages("devtools")
devtools::install_github("IgorRigolon/titled.tuesday")
```

## Usage

To download all Titled Tuesday standings, run

``` r
library(titled.tuesday)

dat <- tt_results()
```

To download all Titled Tuesday games since 2023, run

``` r
dat <- tt_games(years = c(2023, 2024))
```

To download all games ever played by titled players on Chess.com, simply
use the `tt_only` option (very heavy)

``` r
dat <- tt_games(tt_only = FALSE, years = "all")
```

If you need the full PGNs with all moves from each game, use the
`include_pgn` option. Note that this makes the final product
significantly heavier.

``` r
dat <- tt_games(years = 2024, include_pgn = TRUE)
```

If you only want games from a few players, use the `usernames` option,
which also speeds up the download by a lot.

``` r
dat <- tt_games(usernames = c("hikaru", "jospem"))

# not limited to titled players

dat <- tt_games(usernames = "your_username", tt_only = FALSE)
```

## How it works

### Results

First, the `get_tournaments` function crawls through all pages (the
number of pages will have to be updated manually, there are currently
18) of the [Chess.com TT Tournaments
page](https://www.chess.com/tournament/live/titled-tuesdays) and get the
tournament code for each TT, which makes up their URL.

Then, the `get_download_url` function calls the API to obtain the number
of rounds in each TT, and returns a final URL, which is used as an API
call by `tt_results`.

### Games

The Chess.com Tournaments API only sends results for the final round of
each Titled Tuesday. To get all games, I obtain the list of all titled
usernames with `get_titled_players`, and then ask the API for all their
games using `get_games`. The `tt_games` function simply loops over all
titled players and stacks up their games.
