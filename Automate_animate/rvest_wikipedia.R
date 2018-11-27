#  rvest_wikipedia

library(rvest)
library(methods)
library(dplyr)

url <- "https://en.wikipedia.org/wiki/Mile_run_world_record_progression"
tables <- url %>%
     read_html() %>%
     html_nodes("table")
length(tables)

Table3 <- html_table(tables[[3]])
Table4 <- html_table(tables[[4]])
Table4 <- select(Table4, -Auto) # remove the unwanted column
