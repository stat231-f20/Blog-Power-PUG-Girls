library(tidyverse)
library(rvest)
library(robotstxt)
library(stringr)
library(dplyr)

paths_allowed('https://www.officialcharts.com/artist/12465/beyonce/')

beyonce_charts_html <- read_html('https://www.officialcharts.com/artist/12465/beyonce/')

albums <- beyonce_charts_html %>%
  html_nodes('.title') %>%
  html_text()

albums <- albums[63:71]

dates <- beyonce_charts_html %>%
  html_nodes('.date') %>%
  html_text()

dates <- dates[63:71]

peak_position <- beyonce_charts_html %>%
  html_nodes('.position') %>%
  html_text()

peak_position <- peak_position[63:71]
weeks_on_chart <- beyonce_charts_html %>%
  html_nodes('td') %>%
  html_text()

weeks_number_one <- beyonce_charts_html %>%
  html_nodes('td') %>%
  html_text()

beyonce_dat <- data.frame(albums = albums, dates = dates, peak_position = peak_position
                           , stringsAsFactors = FALSE)

out_path <- "/home/class21/gcho21/git/Blog-Power-PUG-Girls"
write_csv(x = beyonce_dat, path = paste0(out_path,"/Beyonce.csv"))