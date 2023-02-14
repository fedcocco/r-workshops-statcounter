# Example code for downloading data from statcounter

# Imports ---------------------------------------------------------------------

library(here)
library(rvest)
library(tidyverse)

source(here("R/functions.R"))

# Getting the data on regions -------------------------------------------------

region_select <- read_html("https://gs.statcounter.com") |> 
  html_element("select#region")

region_names <- region_select |>
  html_elements("option") |> 
  html_text()

region_codes <- region_select |>
  html_elements("option") |> 
  html_attr("value")

# Building a URL and fetching a single file -----------------------------------

dates <- get_dates("2022-01-01", "2022-07-01")
url <- get_url("af", "Africa", dates)
df <- read_csv(url)

filepath <- get_filepath("af", "Africa")
download.file(url, filepath)

# Why you need to encode data that goes into URLs -----------------------------

url <- get_url("na", "North America", dates)
filepath <- get_filepath("na", "North America")
download.file(url, filepath)

# Doing the same thing with our fetch_datafile function -----------------------

fetch_datafile("af", "Africa", dates)