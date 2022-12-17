#set working directory
setwd("/home/omotolaolasope/Desktop/Data_Analysis/DataCamp_Tree_Specie_Challenge/")

## Installing and loading common packages and libraries
library(tidyverse)
library(dplyr)
#library(gridExtra)
#library(grid)
#library(naniar) #visualize missings per variable

treesdf <- read.csv('trees.csv')

## Exploring the data
head(treesdf)
colnames(treesdf)

## visualize missings per variable using the 'naniar' library
gg_miss_var(treesdf) +
  # add labels
  labs(
    title = "Numbers of missing values per variable",
    y = "Count of Missing Values") +
  # make axis text bold
  theme(axis.text.y = element_text(face = "bold"))

#It was observed that all dead trees species have no common name so I separated the dead trees from the alive ones

#seperate dead trees from alive ones
dead_trees <- treesdf %>% 
  filter(status == "Dead")

alive_trees <- treesdf %>% 
  filter(status == "Alive")

# Get number of alive trees per specie
tree_count <- alive_trees %>% 
  count(spc_common)

# change column name for n column
colnames(tree_count)[2]  <- "number_of_trees"

# Sort by number_of_trees 
tree_count <- tree_count[order(tree_count$number_of_trees, decreasing=TRUE, na.last=FALSE),]

# View first 15 most populous trees
tree_count <- tree_count %>% 
  arrange(-number_of_trees)

head(tree_count, 10)

# Get number of alive trees per location
nta_location_count <- alive_trees %>% 
  count(nta_name)

# change column name for n column
colnames(nta_location_count)[2]  <- "number_of_trees"

# Sort by number_of_trees 
nta_location_count <- nta_location_count[order(nta_location_count$number_of_trees, decreasing=TRUE, na.last=FALSE),]

# View location with most populous trees
nta_location_count <- nta_location_count %>% 
  arrange(-number_of_trees)

head(nta_location_count)
tail(nta_location_count)

# Get number of dead trees per location
deadTrees.location_count <- dead_trees %>% 
  count(nta_name)

# change column name for n column
colnames(deadTrees.location_count)[2]  <- "number_of_trees"

# Sort by number_of_trees 
deadTrees.location_count <- deadTrees.location_count[order(deadTrees.location_count$number_of_trees, decreasing=TRUE, na.last=FALSE),]

# View location with most populous dead trees
deadTrees.location_count <- deadTrees.location_count %>% 
  arrange(-number_of_trees)

head(deadTrees.location_count)

# sort trees by health status
trees_by_health <- alive_trees %>% 
  group_by(spc_common, health) %>% 
  summarise(number = n())

trees_by_healthWIDE <- trees_by_health %>% 
  spread(health, number)

## add row sums to get percentages
trees_by_healthWIDE$row_sum <- rowSums(trees_by_healthWIDE[ , c(2,3,4)], na.rm=TRUE)

trees_by_healthWIDE$percentage_good <- round(100*(trees_by_healthWIDE$Good/trees_by_healthWIDE$row_sum), 2)

trees_by_healthWIDE$percentage_fair <- round(100*(trees_by_healthWIDE$Fair/trees_by_healthWIDE$row_sum), 2)

trees_by_healthWIDE$percentage_poor <- round(100*(trees_by_healthWIDE$Poor/trees_by_healthWIDE$row_sum), 2)

# sort trees by diameter
tree_diameter <- alive_trees %>% 
  group_by(spc_common) %>% 
  summarise(
    mean_diameter = mean(tree_dbh),
    median_diameter = median(tree_dbh),
    number = n()) %>%
  arrange(-mean_diameter)

# merge the two sorted data frames by specie
tree_status.diameter_health <- merge(tree_diameter, trees_by_healthWIDE, by="spc_common")

# clean merged dataframe
## remove column
tree_status.diameter_health <- tree_status.diameter_health[,-4]
tree_status.diameter_health <- tree_status.diameter_health[,-3]

## change column name
colnames(tree_status.diameter_health)[3]  <- "fair_health"
colnames(tree_status.diameter_health)[4]  <- "good_health"
colnames(tree_status.diameter_health)[5]  <- "poor_health"
colnames(tree_status.diameter_health)[6]  <- "total_number_of_trees"


#filter by diameter and percentage good to determine the best trees to recommend
recommended_trees <- tree_status.diameter_health %>% 
  filter(mean_diameter >= 9 & percentage_good >= 70) %>% 
  arrange(-percentage_good)

# View first 10 recommended trees to plant
head(recommended_trees, 10)




