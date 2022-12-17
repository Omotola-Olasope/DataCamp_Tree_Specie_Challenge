## Contents

-   [Introduction and Background](#introduction-and-background)
-   [Objectives](#objectives)
-   [Data Preparation](#data-preparation)
-   [Data Processing/Cleaning](#data-processingcleaning)
-   [Analysis with R](#analysis-with-r)
-   [Key findings and Summary](#key-findings-and-summary)
-   [Recommendations](#recommendations)

## Introduction and background

I work for a nonprofit organization advising the planning department on
ways to improve the quantity and quality of trees in New York City. The
urban design team believes tree size (using trunk diameter as a proxy
for size) and health are the most desirable characteristics of city
trees.

The city would like to learn more about which tree species are the best
choice to plant on the streets of Manhattan.

### Objectives

The aim of the analysis is to create a report that covers the following:

-   What are the most common tree species in Manhattan?
-   Which are the neighborhoods with the most trees?
-   A visualization of Manhattan’s neighborhoods and tree locations.
-   What ten tree species would you recommend the city plant in the
    future?

## Data Preparation

The Tree census and neighborhood information is publicly available from
the City of New York NYC Open Data
<https://opendata.cityofnewyork.us/data/>

## Data Processing/Cleaning

The data was relatively clean. However, it was observed that all the
dead trees had no common name for its species, so I separated the dead
trees from the alive ones to get more detailed results based on the
projects objectives.

## Analysis With R

``` r
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
```

    ##                                     nta_name number_of_trees
    ## 1                            Upper West Side            5723
    ## 2              Upper East Side-Carnegie Hill            4540
    ## 3                               West Village            3715
    ## 4          Central Harlem North-Polo Grounds            3355
    ## 5 Hudson Yards-Chelsea-Flatiron-Union Square            2797
    ## 6                   Washington Heights South            2788

``` r
tail(nta_location_count)
```

    ##                             nta_name number_of_trees
    ## 23                         Chinatown            1408
    ## 24 Battery Park City-Lower Manhattan            1264
    ## 25                          Gramercy            1125
    ## 26             Midtown-Midtown South            1120
    ## 27                    Manhattanville             865
    ## 28    Stuyvesant Town-Cooper Village             438

``` r
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
```

    ##                                     nta_name number_of_trees
    ## 1                   Washington Heights South             136
    ## 2 Hudson Yards-Chelsea-Flatiron-Union Square             134
    ## 3          Central Harlem North-Polo Grounds             114
    ## 4                          East Harlem North             107
    ## 5                   Washington Heights North              93
    ## 6                               West Village              86

Since the urban design team believes trunk diameter and health are the
most desirable characteristics of city trees, lets find out the trees
with good health status and diameter greater than 9 to determine the
best set of trees to recommend.

``` r
# sort trees by health status
trees_by_health <- alive_trees %>% 
  group_by(spc_common, health) %>% 
  summarise(number = n())
```

    ## `summarise()` has grouped output by 'spc_common'. You can override using the
    ## `.groups` argument.

``` r
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
```

    ##        spc_common mean_diameter fair_health good_health poor_health
    ## 1       smoketree     11.000000          NA           1          NA
    ## 2     black maple     12.600000           1           9          NA
    ## 3  Amur cork tree      9.625000           1           7          NA
    ## 4      willow oak     10.811024         115         747          27
    ## 5    Siberian elm     12.064103          18         131           7
    ## 6     honeylocust      9.057837        2012       10958         205
    ## 7         pin oak     10.068499         719        3731         134
    ## 8    American elm     13.899293         259        1361          78
    ## 9       white ash      9.800000           8          40           2
    ## 10        Sophora      9.225915         713        3554         186
    ##    total_number_of_trees percentage_good percentage_fair percentage_poor
    ## 1                      1          100.00              NA              NA
    ## 2                     10           90.00           10.00              NA
    ## 3                      8           87.50           12.50              NA
    ## 4                    889           84.03           12.94            3.04
    ## 5                    156           83.97           11.54            4.49
    ## 6                  13175           83.17           15.27            1.56
    ## 7                   4584           81.39           15.68            2.92
    ## 8                   1698           80.15           15.25            4.59
    ## 9                     50           80.00           16.00            4.00
    ## 10                  4453           79.81           16.01            4.18

# Key Findings and Summary

A visualization of Manhattan’s neighborhoods and tree locations can be
found here.
<https://public.tableau.com/app/profile/omotola.olasope/viz/AvisualizationofManhattansneighborhoodsandtreelocations_/Map?publish=yes>

### Table One

    ##         spc_common number_of_trees
    ## 1      honeylocust           13175
    ## 2     Callery pear            7297
    ## 3           ginkgo            5859
    ## 4          pin oak            4584
    ## 5          Sophora            4453
    ## 6 London planetree            4122

### Description

The most common tree specie in Manhattan is honeylocust. Others include
Callery pear, ginkgo, pin oak and Sophora.

### Table Two

    ##                                     nta_name number_of_trees
    ## 1                            Upper West Side            5723
    ## 2              Upper East Side-Carnegie Hill            4540
    ## 3                               West Village            3715
    ## 4          Central Harlem North-Polo Grounds            3355
    ## 5 Hudson Yards-Chelsea-Flatiron-Union Square            2797
    ## 6                   Washington Heights South            2788

### Description

The neighborhood with the most trees is Upper West Side. Other
neighborhoods include Upper East Side-Carnegie Hill, West Village,
Central Harlem North-Polo Grounds and Hudson
Yards-Chelsea-Flatiron-Union Square.

### Table Three

    ##        spc_common mean_diameter fair_health good_health poor_health
    ## 1       smoketree     11.000000          NA           1          NA
    ## 2     black maple     12.600000           1           9          NA
    ## 3  Amur cork tree      9.625000           1           7          NA
    ## 4      willow oak     10.811024         115         747          27
    ## 5    Siberian elm     12.064103          18         131           7
    ## 6     honeylocust      9.057837        2012       10958         205
    ## 7         pin oak     10.068499         719        3731         134
    ## 8    American elm     13.899293         259        1361          78
    ## 9       white ash      9.800000           8          40           2
    ## 10        Sophora      9.225915         713        3554         186
    ##    total_number_of_trees percentage_good percentage_fair percentage_poor
    ## 1                      1          100.00              NA              NA
    ## 2                     10           90.00           10.00              NA
    ## 3                      8           87.50           12.50              NA
    ## 4                    889           84.03           12.94            3.04
    ## 5                    156           83.97           11.54            4.49
    ## 6                  13175           83.17           15.27            1.56
    ## 7                   4584           81.39           15.68            2.92
    ## 8                   1698           80.15           15.25            4.59
    ## 9                     50           80.00           16.00            4.00
    ## 10                  4453           79.81           16.01            4.18

### Description

Ten tree species I would recommend the city should plant in the future
based on their trunk diameter and health are Smoketree, Black Maple,
Amur Tork Tree, Willow Oak, Siberian Elm, Honeylocust, Pin Oak, American
Elm, White Ash and Sophora.

## Recommendations

-   The city should plant more of the following tree species: Smoketree,
    Black Maple, Amur Tork Tree, Willow Oak, Siberian Elm, Honeylocust,
    Pin Oak, American Elm, White Ash and Sophora.

-   More trees need to be planted in the following locations Stuyvesant
    Town-Cooper Village, Manhattanville, Midtown-Midtown South,
    Gramercy, Battery Park City-Lower Manhattan and Chinatown.

-   Further analysis should be carried out to ascertain the reason for
    the number of dead trees in the following regions Washington Heights
    South, Hudson Yards-Chelsea-Flatiron-Union Square, Central Harlem
    North-Polo Grounds, East Harlem North, Washington Heights North, and
    West Village.

------------------------------------------------------------------------
