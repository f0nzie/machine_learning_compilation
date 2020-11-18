set.seed(1014)
options(digits = 3)

knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  cache = FALSE,
  out.width = "70%",
  fig.align = 'center',
  fig.width = 6,
  fig.asp = 0.618,  # 1 / phi
  fig.show = "hold"
  # message = FALSE,
  # error = TRUE,
  # warning = FALSE,
)

options(dplyr.print_min = 6, dplyr.print_max = 6)

# folders for input and output
data_raw_dir  <- "../data"
assets_dir    <- "../assets"
model_out_dir <- "../output/models"
data_out_dir  <- "../output/data"
