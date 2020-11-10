## Web Scraping for Lyrics
library(tidyverse) 
library(rvest)
library(robotstxt)

paths_allowed("https://www.azlyrics.com/")

beyonce_url = "https://www.azlyrics.com/k/knowles.html"
jayZ_url = "https://www.azlyrics.com/j/jayz.html"

beyonce_names <- (beyonce_url %>%               
                    read_html() %>%
                    html_nodes("a") %>% 
                    html_text
)

## Lemonade: 157-169

prefix <- "https://www.azlyrics.com/lyrics/beyonceknowles/"
suffix <- ".html"

beyonce_names_fix <- beyonce_names %>%
  str_replace_all(" ", "") %>% 
  str_replace_all("'", "") %>% 
  str_replace_all("\\)", "") %>% 
  str_replace_all("\\(", "") %>% 
  tolower() 

beyonce_lemonade_url0 <- paste0(prefix, beyonce_lemonade_fix)
beyonce_lemonade_url <- paste0(beyonce_lemonade_url0, suffix)

beyonce_songs <- data.frame(name = beyonce_names_lemonade,
                            text = NA)
  
test <- (beyonce_lemonade_url[5] %>%               
                    read_html() %>%
                    html_nodes("div") %>% 
                    html_text)[21]




for (i in 1:13){
  url <- beyonce_lemonade_url[i]
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
