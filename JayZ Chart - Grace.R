library(tidyverse)
library(rvest)
library(robotstxt)
library(stringr)
library(dplyr)

paths_allowed('https://www.officialcharts.com/artist/1028/jay-z/')

jayz_charts_html <- read_html('https://www.officialcharts.com/artist/1028/jay-z/')

albums <- jayz_charts_html %>%
  html_nodes('.title') %>%
  html_text()

albums <- albums[59:74]

dates <- jayz_charts_html %>%
  html_nodes('.date') %>%
  html_text()

dates <- dates[59:74]

peak_position <- jayz_charts_html %>%
  html_nodes('.position') %>%
  html_text()

peak_position <- peak_position[59:74]
weeks_on_chart <- beyonce_charts_html %>%
  html_nodes('td') %>%
  html_text()

weeks_number_one <- beyonce_charts_html %>%
  html_nodes('td') %>%
  html_text()

jayz_dat <- data.frame(albums = albums, dates = dates, peak_position = peak_position
                          , stringsAsFactors = FALSE)

out_path <- "/home/class21/gcho21/git/Blog-Power-PUG-Girls"
write_csv(x = jayz_dat, path = paste0(out_path,"/JayZ.csv"))

