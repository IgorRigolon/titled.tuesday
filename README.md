
<!-- README.md is generated from README.Rmd. Please edit that file -->

# titled.tuesday

<!-- badges: start -->
<!-- badges: end -->

The `titled.tuesday` R package pulls all Titled Tuesday PGNs and results
from the [Chess.com
API](https://www.chess.com/news/view/published-data-api). If you just
want the data, it is stored in the [`/data-raw/`
folder](https://github.com/IgorRigolon/titled.tuesday/tree/main/data-raw).

## Installation

You can install the development version of `titled.tuesday` from GitHub
with:

``` r
install.packages("devtools")
devtools::install_github("IgorRigolon/titled.tuesday")
```

## Example

To download all available Titled Tuesday data, simply run (this will
take some minutes due to API constraints)

``` r
library(titled.tuesday)

dat <- titled_tuesday()
```

## How it works

I use two auxiliary functions. First, the `get_tournaments` function
crawls through all pages (the number of pages will have to be updated
manually, there are currently 18) of the [Chess.com TT Tournaments
page](https://www.chess.com/tournament/live/titled-tuesdays) and get the
tournament code for each TT, which makes up their URL.

Then, the `get_download_url` function calls the API to obtain the number
of rounds in each TT, and returns a final URL, which is used as an API
call by `titled_tuesday`.
