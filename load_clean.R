library(tidyverse)

# Get all points files
files <- system("ls *-points.csv", intern=TRUE)  # ausopen and usopen
# Read every file into a dataframe
x <- read.csv(files[1]) %>% tibble
for (i in 1:length(files)) {
  x <- rbind(x, read.csv(files[i])[,names(x)])
}
points <- x %>% tibble

# Get all match files
matches_files <- system("ls *-matches.csv", intern=TRUE)
matches <- read.csv(matches_files[1])
for (match in matches_files) {
  matches <- rbind(matches, read.csv(match))
}

# Grab only the columns we want from matches
matches <- matches %>% 
  select(match_id, player1, player2, player1id, player2id, nation1, nation2, event_name) %>% 
  tibble %>% 
  distinct

# Exclude points from matches not present in our matches
points_singles <- points %>% filter(match_id %in% matches$match_id)

# Join points and matches
df <- left_join(points_singles, matches, on='match_id')

# Convert time to minutes
get_time <- function(stamp) {
  s <- str_split(stamp, ":")[[1]] %>% as.numeric
  return(s[1]*60 + s[2] + s[3]/60)
}
df$time <- sapply(df$ElapsedTime, get_time)

# Create a column "tourney" which is one of {ausopen, frenchopen, usopen, wimbledon}
# and create a column "year" which is useful for downstream aggregations
df <- df %>% mutate(tourney=str_split(match_id, "-")) %>% 
  mutate(tourney=sapply(tourney, function(x){paste0(x[[1]], "/", x[[2]])})) %>% 
  mutate(year=as.numeric(substr(tourney, 1, 4))) %>% 
  mutate(tourney=substr(tourney, 6, nchar(tourney)))

# Work out whether it's men's or women's (event_name)
# 4 or 5 sets must be men's and 2 sets must be women's
# This gets about 60% of the way there
set_based_event_name <- df %>% group_by(match_id) %>% 
  summarize(max_sets=max(SetNo)) %>% 
  mutate(event_name=ifelse(max_sets>=4, "Men's Singles", NA)) %>% 
  mutate(event_name=ifelse(max_sets<=2, "Women's Singles", event_name))

# Join the data to these event_names
df <- df %>% select(-event_name) %>% 
  left_join(
    ., 
    set_based_event_name, 
    by="match_id")

# Get all players who MUST be male because they played
# in a 4 or 5-setter
# EXAMPLE
#   Player A plays a bunch of 3-setters so we can't tell male or female
#   But he plays in one four-setter
#   So now we know he's male, and can fill in all the 3-setters as male too
male_players <- df %>% 
  filter(event_name=="Men's Singles") %>% 
  select(player1, player2) %>% 
  as.matrix %>% 
  as.vector %>% 
  unique

# Get all players who MUST be male because they played
# in 2-setter
female_players <- df %>% 
  filter(event_name=="Women's Singles") %>% 
  select(player1, player2) %>% 
  as.matrix %>% 
  as.vector %>% 
  unique

# Hard code all those players as male
df <- df %>% mutate(
  event_name=ifelse(
    player1 %in% male_players | player2 %in% male_players,
    "Men's Singles",
    ifelse(
      player1 %in% female_players | player2 %in% female_players,
      "Women's Singles",
      event_name
    )))

# The last names are also a problem. For example Alex de Minaur shows up as
# "Alex de Minaur", "Alex De Minaur", "A Minaur", "A. Minaur", "A de Minaur", etc.
# So we
#   1. Lowercase all the names 
#   2. Take the first letter from them, this is the first initial (initial)
#   3. Split the names with space-delimiter
#   4. Take the last token (surname)
#   5. Make a new name column with initial + " " + surname
# Voila, we now have unique player names. This might not be 100% perfect
# so please check for yourself
df <- df %>% 
  mutate(
    player1=tolower(player1), 
    player2=tolower(player2)) %>% 
  mutate(
    initial1=substr(player1, 1, 1),
    split1=str_split(player1, " "),
    surname1=sapply(split1, function(x){x[[length(x)]]})) %>% 
  mutate(
    initial2=substr(player2, 1, 1),
    split2=str_split(player2, " "),
    surname2=sapply(split2, function(x){x[[length(x)]]})) %>% 
  mutate(
    player1_new=paste0(initial1, " ", surname1),
    player2_new=paste0(initial2, " ", surname2))


# Make a column for surface, a great starting point for analyses
df <- df %>% 
  mutate(surface="hard") %>% 
  mutate(
    surface=ifelse(
      grepl("french", tourney),
      "clay",
      surface)) %>% 
  mutate(
    surface=ifelse(
      grepl("wimbledon", tourney),
      "grass",
      surface))

# For each column, compute the percentage of rows that are NA
missing_columns_report <- sort(sapply(names(df), function(x){
  return(
    round(100*sum(is.na(df[[x]])/nrow(df)))
  )
}))

# Prune all the intermediate columns that we no longer need
df_final <- df %>% select(
  -player1,
  -player2,
  -split1,
  -split2,
  -surname1,
  -surname1,
  -max_sets,
  -initial1,
  -initial2
)

saveRDS(df_final, "data_clean.rds")
