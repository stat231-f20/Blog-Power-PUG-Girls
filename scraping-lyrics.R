library(tidyverse) 
library(rvest)
library(robotstxt)
library(genius)

beyonce_albums <- tribble(
  ~ artist, ~ title,
  "Beyonce", "Dangerously in Love",
  "Beyonce", "B'Day",
  "Beyonce", "I am... Sasha Fierce",
  "Beyonce", "4",
  "Beyonce", "Beyonce",
  "Beyonce", "Lemonade",
)

beyonce_lyrics <- beyonce_albums %>% 
  add_genius(artist, title, type = "album")

jayZ_albums <- tribble(
  ~ artist, ~ title,
  "Jay-Z", "Reasonable Doubt",
  "Jay-Z", "In My Lifetime, Vol. 1",
  "Jay-Z", "Vol. 2... Hard Knock Life",
  "Jay-Z", "Vol. 3... Life and Times of S. Carter",
  "Jay-Z", "The Dynasty: Roc La Familia",
  "Jay-Z", "The Blueprint",
  "Jay-Z", "The Blueprint 2: The Gift & The Curse",
  "Jay-Z", "The Black Album",
  "Jay-Z", "Kingdom Come",
  "Jay-Z", "American Gangster",
  "Jay-Z", "The Blueprint 3",
  "Jay-Z", "Magna Carta... Holy Grail",
  "Jay-Z", "4:44",
  "Jay-Z", "Everything Is Love",
  
)

jayZ_lyrics <- jayZ_albums %>% 
  add_genius(artist, title, type = "album")

out_path <- "C:/Users/abran/OneDrive/Documents/STAT 231 - Data Science/git/Blog-PowerPUG-Girls"

write_csv(x = beyonce_lyrics, path = paste0(out_path,"/beyonce_lyrics.csv"))
write_csv(x = jayZ_lyrics, path = paste0(out_path,"/jayZ_lyrics.csv"))