# A brief refresher on functions

# Imports ---------------------------------------------------------------------

library(here)
library(janitor)
library(lubridate)
library(tidyverse)

# Refresher -------------------------------------------------------------------

# Functions are standalone units of code. You can think of them as recipes or 
# factories that produce a particular type of output from a particular input.
# Putting you code in functions means you do not need to repeat yourself. This
# is known as the DRY principle: (D)on't (R)epeat (Y)ourself. 

# Consider the difference between these two pieces of code, where we get the 
# most recebnt figure on the crown court backlog from two different csvs.

# 1. Repeating yourself in a script

# URLs to csvs
csv_jan_2019_2020 <- "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/871904/HMCTS_raw_data_for_Jan19_to_Jan20.csv"
csv_jan_2020_2021 <- "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1001082/20210302_HMCTS_raw_data_for_Jan20_to_Jan21.csv"

# Let's have a look at the data
read_csv(csv_jan_2019_2020)

# Fetch each csv and process it in turn
crown_court_backlog_jan_2020 <- read_csv(csv_jan_2019_2020) |> 
  clean_names() |> 
  mutate(month = dmy(month)) |> 
  filter(month == max(month)) |> 
  pluck("crown_outstanding")

crown_court_backlog_jan_2020

crown_court_backlog_jan_2021 <- read_csv(csv_jan_2020_2021) |> 
  clean_names() |> 
  mutate(month = dmy(month)) |> 
  filter(month == max(month)) |> 
  pluck("crown_outstanding")

crown_court_backlog_jan_2021
  
# 2. Using a function

fetch_crown_court_backlog <- function(csv_url) {
  read_csv(csv_url) |> 
    clean_names() |> 
    mutate(month = dmy(month)) |> 
    filter(month == max(month)) |> 
    pluck("crown_outstanding")
}

crown_court_backlog_jan_2020 <- fetch_crown_court_backlog(csv_jan_2019_2020)
crown_court_backlog_jan_2021 <- fetch_crown_court_backlog(csv_jan_2020_2021)

crown_court_backlog_jan_2020
crown_court_backlog_jan_2021

# Functions take inputs and produce outputs. The inputs to a function are 
# specified as a list of variable names within brackets at the start of the 
# function definition. Any values you pass into the function when you call it
# will be available inside the function body using those variable names.
# The return value is whatever is produced by the last line of code in the 
# function. You can also return from a function using return(). The following 
# three function definitions are equivalent.

add <- function(a, b) {
  a + b
}

add(2, 5)

add <- function(a, b) {
  c <- a + b
  c
}

add(2, 5)

add <- function(a, b) {
  return(a + b)
}

add(2, 5)

# Functions have a scope which defines an environment for local code execution
# inside the function body. In plain english this means that variables defined 
# within the body of the function are local to that function, and do not exist
# for code that runs outside the function.

add_then_double <- function(a, b) {
  c <- a + b
  d <- c * 2
  d
}

x <- 2
y <- 5

z <- add_then_double(x, y)

# These variables exist outside the function
x
y
z

# These don't exist outside the function
a
b
c
d

# Functions can access variables that have not been created inside the function 
# body, if they have been created before the function is called. These can be 
# global variables or variables created in the same scope where the function 
# is defined.

ten <- 10

add_then_multiply_by_ten <- function(a, b) {
 (a + b) * ten
}

add_then_multiply_by_ten(2, 5)

# If you need to assign a value to a variable that was created in a higher 
# scope you need to use the double arrow operator.

# Define an outer variable
outer <- 0

# outer is 0
outer

add_and_assign_outside <- function(a, b) {
  outer <<- a + b
  "The outer variable has been reassigned"
}

add_and_assign_outside(2, 5)

# outer's value has been reassigned by the function
outer

# This behaviour can be quite powerful but it can cause issues. Generally 
# speaking you should only do this in certain circumstances. If you don't
# know what they are, try to avoid this if possible.