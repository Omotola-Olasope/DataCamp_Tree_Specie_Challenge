# DataCamp #12DaysofData Street Trees in NYC Challenge

## About 
This is a report to find the best tree species to plant in NYC. It is part of the DataCamp series of competitions tagged #12DayofData aimed at challenging Data Enthusiasts to keep learning and demonstrating their data skills. 
See the report here <https://github.com/Omotola-Olasope/DataCamp_Tree_Specie_Challenge/blob/main/DataCamp_Tree_Specie_Challenge.md>

## Objectives of the Analysis
The aim of the analysis is to create a report that covers the following:

- What are the most common tree species in Manhattan?
- Which are the neighborhoods with the most trees?
- What ten tree species would you recommend the city plant in the future?
- A visualization of Manhattan's neighborhoods and tree locations.
(See the visualization here <https://public.tableau.com/app/profile/omotola.olasope/viz/AvisualizationofManhattansneighborhoodsandtreelocations_/Map?publish=yes>)

## Variable Description

#### Tree Census
- "tree_id" - Unique id of each tree.
- "tree_dbh" - The diameter of the tree in inches measured at 54 inches above the ground.
- "curb_loc" - Location of the tree bed in relation to the curb. Either along the curb (OnCurb) or offset from the curb (OffsetFromCurb).
- "spc_common" - Common name for the species.
- "status" - Indicates whether the tree is alive or standing dead.
- "health" - Indication of the tree's health (Good, Fair, and Poor).
- "root_stone" - Indicates the presence of a root problem caused by paving stones in the tree bed.
- "root_grate" - Indicates the presence of a root problem caused by metal grates in the tree bed.
- "root_other" - Indicates the presence of other root problems.
- "trunk_wire" - Indicates the presence of a trunk problem caused by wires or rope wrapped around the trunk.
- "trnk_light" - Indicates the presence of a trunk problem caused by lighting installed on the tree.
- "trnk_other" - Indicates the presence of other trunk problems.
- "brch_light" - Indicates the presence of a branch problem caused by lights or wires in the branches.
- "brch_shoe" - Indicates the presence of a branch problem caused by shoes in the branches.
- "brch_other" - Indicates the presence of other branch problems.
- "postcode" - Five-digit zip code where the tree is located.
- "nta" - Neighborhood Tabulation Area (NTA) code from the 2010 US Census for the tree.
- "nta_name" - Neighborhood name.
- "latitude" - Latitude of the tree, in decimal degrees.
- "longitude" - Longitude of the tree, in decimal degrees.

#### Neighborhoods' geographical information
- "ntacode" - NTA code (matches Tree Census information).
- "ntaname" - Neighborhood name (matches Tree Census information).
- "geometry" - Polygon that defines the neighborhood.