# Download data from statcounter

# Imports ---------------------------------------------------------------------

library(here)
library(janitor)
library(lubridate)
library(rvest)
library(tidyverse)

# The statcounter URL ---------------------------------------------------------

# https://gs.statcounter.com/chart.php?
# device=Desktop%20%26%20Mobile%20%26%20Tablet%20%26%20Console&
# device_hidden=desktop%2Bmobile%2Btablet%2Bconsole&
# multi-device=true&statType_hidden=browser&
# region_hidden=ww&granularity=monthly&
# statType=Browser&region=Worldwide&
# fromInt=202201&toInt=202301&
# fromMonthYear=2022-01&
# toMonthYear=2023-01&csv=1

# Building URLs and filepaths -------------------------------------------------

fetch_regions <- function() {
  region_select <- read_html("https://gs.statcounter.com") |> 
    html_element("select#region")
  region_names <- region_select |>
    html_elements("option") |> 
    html_text()
  region_codes <- region_select |>
    html_elements("option") |> 
    html_attr("value")
  tibble(
    code = region_codes,
    name = region_names)
}

get_dates <- function(start_date, end_date) {
  start_date <- as_date(start_date)
  end_date <- as_date(end_date)
  list(
    from_int = format(start_date, "%Y%m"),
    to_int = format(end_date, "%Y%m"),
    from_month_year = format(start_date, "%Y-%m"),
    to_month_year = format(end_date, "%Y-%m"))
}

get_url <- function(region_code, region_name, dates) {
  str_c(
    "https://gs.statcounter.com/chart.php?",
    "device=Desktop%20%26%20Mobile%20%26%20Tablet%20%26%20Console&",
    "device_hidden=desktop%2Bmobile%2Btablet%2Bconsole&",
    "multi-device=true&statType_hidden=browser&",
    str_glue("region_hidden={region_code}&granularity=monthly&"),
    str_glue("statType=Browser&region={URLencode(region_name)}&"),
    str_glue("fromInt={dates$from_int}&toInt={dates$to_int}&"),
    str_glue("fromMonthYear={dates$from_month_year}&toMonthYear={dates$to_month_year}&csv=1"))
}

get_filepath <- function(region_code, region_name) {
  here(str_glue("data/{region_code}-{region_name}.csv"))  
}

# Fetching an individual file -------------------------------------------------

fetch_datafile <- function(region_code, region_name, dates) {
  url <- get_url(region_code, region_name, dates)
  filepath <- get_filepath(region_code, region_name)
  download.file(url, filepath)
}

# Fetching all the files ------------------------------------------------------

fetch_datafiles <- function(regions, start_date, end_date) {
  dates <- get_dates(start_date, end_date)
  walk2(regions$code, regions$name, function(region_code, region_name) {
    message(str_glue("Fetching datafile for {region_name}"))
    fetch_datafile(region_code, region_name, dates)
    Sys.sleep(1)
  })
}

# Read all downloaded data files ----------------------------------------------

read_datafiles <- function() {
  filepaths <- list.files(here("data"), full.names = TRUE)
  map_dfr(filepaths, function(filepath) {
    read_csv(filepath) |> 
      clean_names()
  }) |> mutate(date = ym(date))
}