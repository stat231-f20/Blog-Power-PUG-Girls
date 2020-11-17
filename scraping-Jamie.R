library(tidyverse) 
library(rvest)
library(robotstxt)
library(methods)

# check allowed to be scraped
paths_allowed("https://www.wikipedia.org/")

# identify webpage URLs you want to scrape
hov_url <- "https://en.wikipedia.org/wiki/Jay-Z_albums_discography"
bey_url <- "https://en.wikipedia.org/wiki/Beyoncé_discography"

# scrape tables
hov_tables <- hov_url %>%
  read_html() %>%
  html_nodes("table")

hov_studio <- html_table(hov_tables[[2]], fill = TRUE) 
hov_studio <- hov_studio %>%
  filter(`Title` != "Title") %>%
  select(`Title`, `Album details`, `Sales`)

bey_tables <- bey_url %>%
  read_html() %>%
  html_nodes("table")

bey_studio <- html_table(bey_tables[[2]], fill = TRUE)
bey_studio <- bey_studio %>%
  filter(`Title` != "Title") %>%
  select(`Title`, `Album details`, `Sales`)
