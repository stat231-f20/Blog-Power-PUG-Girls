## Web Scraping for Lyrics
library(tidyverse) 
library(rvest)
library(robotstxt)

paths_allowed("https://www.azlyrics.com/")

## Beyonce 

beyonce_url = "https://www.azlyrics.com/k/knowles.html"

beyonce_names <- (beyonce_url %>%               
                    read_html() %>%
                    html_nodes("a") %>% 
                    html_text
)[35:309]

## Lemonade: 157-169

prefix <- "https://www.azlyrics.com/lyrics/beyonceknowles/"
suffix <- ".html"

beyonce_names_fix <- beyonce_names %>%
  str_replace_all(" ", "") %>% 
  str_replace_all("'", "") %>% 
  str_replace_all("\\)", "") %>% 
  str_replace_all("\\(", "") %>% 
  str_replace_all("&", "") %>% 
  str_replace_all("/", "") %>% 
  str_replace_all("\\.", "") %>% 
  str_replace_all("é", "") %>% 
  str_replace_all("à", "") %>% 
  str_replace_all("-", "") %>%
  str_replace_all(",", "") %>%
  str_replace_all("!", "") %>%
  str_replace_all("\\?", "") %>%
  tolower() 


beyonce_url0 <- paste0(prefix, beyonce_names_fix)
beyonce_url <- paste0(beyonce_url0, suffix)

beyonce_songs <- data.frame(name = beyonce_names,
                            text = NA,
                            album = NA)

loop_length <- length(beyonce_names)

test <- (beyonce_url[5] %>%               
                    read_html() %>%
                    html_nodes("div") %>% 
                    html_text)[21]




for (i in 1:loop_length){
  url <- beyonce_url[i]
  beyonce_songs[i,2] <- tryCatch(
    { 
      (url %>%               
         read_html() %>%
         html_nodes("div") %>%   
         html_text)[21]
    }
    , error = function(error_message) {
      return("Missing")
    }
  ) 
}

## Jay-Z

jayZ_url = "https://www.azlyrics.com/j/jayz.html"

jayZ_names <- (jayZ_url %>%               
                    read_html() %>%
                    html_nodes("a") %>% 
                    html_text
)## Insert proper range specification

prefix_jayZ <- "https://www.azlyrics.com/jayz/"

jayZ_names_fix <- jayZ_names %>%
  str_replace_all(" ", "") %>% 
  str_replace_all("'", "") %>% 
  str_replace_all("\\)", "") %>% 
  str_replace_all("\\(", "") %>% 
  str_replace_all("&", "") %>% 
  str_replace_all("/", "") %>% 
  str_replace_all("\\.", "") %>% 
  str_replace_all("é", "") %>% 
  str_replace_all("à", "") %>% 
  str_replace_all("-", "") %>%
  str_replace_all(",", "") %>%
  str_replace_all("!", "") %>%
  str_replace_all("\\?", "") %>%
  tolower() 


jayZ_url0 <- paste0(prefix, jayZ_names_fix)
jayZ_url <- paste0(jayZ_url0, suffix)

jayZ_songs <- data.frame(name = jayZ_names,
                         text = NA,
                         album = NA)

loop_length <- length(jayZ_names)

test <- (jayZ_url[5] %>%               
           read_html() %>%
           html_nodes("div") %>% 
           html_text)[21]




for (i in 1:loop_length){
  url <- jayZ_url[i]
  jayZ_songs[i,2] <- tryCatch(
    { 
      (url %>%               
         read_html() %>%
         html_nodes("div") %>%   
         html_text)[21]
    }
    , error = function(error_message) {
      return("Missing")
    }
  ) 
}









