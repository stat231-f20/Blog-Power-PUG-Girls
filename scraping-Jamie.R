library(tidyverse) 
library(rvest)
library(robotstxt)
library(methods)
library(spotifyr)
library(genius)
library(ggjoy)
library(fivethirtyeight)

# check allowed to be scraped
paths_allowed("https://www.wikipedia.org/")

# identify webpage URLs you want to scrape
hov_url <- "https://en.wikipedia.org/wiki/Jay-Z_albums_discography"
bey_url <- "https://en.wikipedia.org/wiki/Beyoncé_discography"

# scrape tables
hov_tables <- hov_url %>%
  read_html() %>%
  html_nodes("table")

# choosing table
hov_studio <- html_table(hov_tables[[2]], fill = TRUE) 

# extracting wanted information from columns
hov_studio <- hov_studio %>%
  janitor::clean_names() %>%
  filter(title != "Title") %>%
  select(title, album_details, sales) %>%
  mutate(album_details = gsub(pattern = ".*d: ", "", album_details),
         day = readr::parse_number(album_details),
         year = sub('.*(\\d{4}).*', '\\1', album_details),
         month = gsub(' .*', '', album_details)) %>%
  mutate(sales = gsub(pattern = ".*S: ", "", sales),
         sales = gsub(pattern = "\\[.*", "", sales),
         sales = readr::parse_number(sales)) %>%
  mutate(sales_mil = sales / 1000000) %>%
  mutate(title = gsub(pattern = "\\[.*", "", title))

# combining and reformatting date columns
hov_studio <- hov_studio %>%
  mutate(month = as.numeric(match(hov_studio$month, month.name)), # make month numeric 
         year = as.numeric(year)) # make year numeric
hov_studio <- hov_studio %>%
  mutate(release_date = with(hov_studio, paste(month, day, year, sep = "-")),
         release_date = as.Date(release_date, format = "%m-%d-%Y"),
         key = "Jay-Z")

# scrape tables
bey_tables <- bey_url %>%
  read_html() %>%
  html_nodes("table")

# choosing table
bey_studio <- html_table(bey_tables[[2]], fill = TRUE)

# extracting wanted information from columns
bey_studio <- bey_studio %>%
  janitor::clean_names() %>%
  filter(title != "Title") %>%
  select(title, album_details, sales) %>%
  mutate(album_details = gsub(pattern = ".*d: ", "", album_details),
         day = readr::parse_number(album_details),
         year = sub('.*(\\d{4}).*', '\\1', album_details),
         month = gsub(' .*', '', album_details)) %>%
  mutate(sales = gsub(pattern = ".*S: ", "", sales),
         sales = gsub(pattern = "\\(.*", "", sales),
         sales = gsub(pattern = "\\[.*", "", sales),
         sales = readr::parse_number(sales)) %>%
  mutate(sales_mil = sales / 1000000)

# combining and reformatting date columns
bey_studio <- bey_studio %>%
  mutate(month = as.numeric(match(bey_studio$month, month.name)), # make month numeric 
         year = as.numeric(year)) # make year numeric
bey_studio <- bey_studio %>%
  mutate(release_date = with(bey_studio, paste(month, day, year, sep = "-")),
         release_date = as.Date(release_date, format = "%m-%d-%Y"),
         key = "Beyonce")

# combine tables
full_studio <- rbind(bey_studio, hov_studio)

# create plot
ggplot(data = full_studio, aes(x = year, y = sales_mil, color = key)) +
  geom_line() +
  geom_label(aes(y = 5.6, x = 2000, label = "Vol. 2... Hard Knock Life"), 
             fill = "#00BFC4", size = 3, color = "white") +
  geom_label(aes(y = 0.75, x = 2017, label = "4:44"), 
             fill = "#00BFC4", size = 3, color = "white") +
  geom_label(aes(y = 5.25, x = 2003, label = "Dangerously in Love"), 
             fill = "#F8766D", size = 3, color = "white") +
  geom_label(aes(y = 1.35, x = 2016, label = "Lemonade"), 
             fill = "#F8766D", size = 3, color = "white") +
  labs(
    x = "Release Date", y = "Total Sales (Millions)",
    title = "Album Sales over Time for Jay-Z and Beyonce",
    color = "Artist"
  ) +
  theme(
    plot.title = element_text(hjust = 0.5),
    panel.grid.minor = element_blank()
  )

# logging into spotify developer id
Sys.setenv(SPOTIFY_CLIENT_ID = '8dfd392a0b1a498b9ebae5977afc274a')
Sys.setenv(SPOTIFY_CLIENT_SECRET = 'e4fbba48bed34287b6029b1a5c1d8537')
access_token <- get_spotify_access_token()


# getting artist audio features
hov <- get_artist_audio_features('jay-z') %>%
  filter(album_name %in% hov_studio$title | 
           album_name == "Vol.2 ... Hard Knock Life" | 
           album_name == "Volume. 3... Life and Times of S. Carter" |
           album_name == "The Dynasty: Roc La Famila 2000")
bey <- get_artist_audio_features('beyonce') %>%
  filter(album_name == "Lemonade" | album_name == "I AM...SASHA FIERCE" | 
         album_name == "B'Day" | album_name == "Dangerously In Love" |
         album_name == "4" | album_name == "Beyoncé")

# order beyonce albums
ordered_albums <- factor(bey$album_name)
ordered_albums <- factor(ordered_albums, levels(ordered_albums)[c(5, 1, 4, 2, 3)])
bey$ordered_albums <- ordered_albums

# order jay-z albums
ordered_albums_hov <- factor(hov$album_name)
ordered_albums_hov <- factor(ordered_albums_hov, levels(ordered_albums_hov)[c(1, 5, 10, 2, 4, 7, 9, 8, 11, 13, 12, 3, 6)])
hov$ordered_albums_hov <- ordered_albums_hov

# jay-z album valence plots
ggplot(hov, aes(x = valence, y = ordered_albums_hov, fill = ..x..)) + 
  xlim(0,1) +
  geom_density_ridges_gradient(scale = 0.9) + 
  scale_fill_gradient(low = "white", high = "black") + 
  geom_joy_gradient() + 
  theme_joy() +
  ggtitle("Jayplot of Jay-Z's joy distributions", 
          subtitle = "Based on valence pulled from Spotify's Web API with spotifyr") +
  labs(x = "Valence", y = "Ordered Albums by Date (Newest - Oldest)") +
  theme(legend.position = "none")

# beyonce album valence plots
ggplot(bey, aes(x = valence, y = ordered_albums, fill = ..x..)) + 
  xlim(0,1) +
  geom_density_ridges_gradient(scale = 0.9) + 
  scale_fill_gradient(low = "white", high = "purple4") + 
  geom_joy_gradient() + 
  theme_joy() +
  ggtitle("Beyplot of Beyonce's joy distributions", 
          subtitle = "Based on valence pulled from Spotify's Web API with spotifyr") +
  labs(x = "Valence", y = "Ordered Albums by Date (Newest - Oldest)") +
  theme(legend.position = "none")

