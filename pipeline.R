# Example code for downloading data from statcounter

# Imports ---------------------------------------------------------------------

library(here)
library(tidyverse)

source(here("R/functions.R"))

# Fetching files for a set of regions -----------------------------------------

regions <- fetch_regions()
regions <- regions |> slice_head(n = 8)
fetch_datafiles(regions, "2022-01-01", "2022-12-01")
df <- read_datafiles()