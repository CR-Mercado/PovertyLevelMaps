# PovertyLevelMaps
Creating Maps of Millennial Poverty by County

## Intro 
I saw a map online from Business Insider showing the median income of Millenials at the state level. A common issue in cartography, especially the kind of pop-cartography frequently seen in magazines, news articles, etc. is the mappable area unit problem (MAUP). The idea is, that the unit of aggregation itself (because nearly all data visualizations are aggregations up from the individual level) can distort the meaning of the map. The most common distortion in pop-cartography is ignoring the differences between urban and rural areas, their resulting population densities, and the inter-regional differences at the state level. At its most basic level, a map of incomes in the 50 US states distorts both the cost of living differences (in economics: purchase price parity) across states and the differences within a state (MAUP). 

## Data 
Using the Census Fact Finder I found the poverty level estimates by age group ( < 6, 7 - 17, 18 - 24, 25 - 34, 35 - 44, ...) at the county level and transposed it into a long form. I then used the included R script two_maps_expected_poverty.R to both select only the relevant 18-24 and 25-34 estimates for poverty level and attach geometries (Albers Equal Area Conic, with Alaska and Hawaii insets) for export into QGIS. 

The US census validates income at the household level within each county and applies the "poverty level multiple" to every member of that household. That is how the individual level data is assigned. Poverty Levels vary by numerous factors (number of workers in the home, number of children, etc.) which acts as a fair proxy to cost of living and exogenous factors - as opposed to simply using ~12,000 for the individual poverty wage. The Poverty Level ranges are:   < .5 (less than 1/2 the poverty line), "Under .50", ".50 to .74", ".75 to .99", "1.00 to 1.24", "1.25 to 1.49", "1.50 to 1.74", "1.75 to 1.84", "1.85 to 1.99", "2.00 to 2.99", "3.00 to 3.99", "4.00 to 4.99", "5.00 and over". The lack of consistency within the spread of each class is a small issue. 

## Script Explanation 

For each class of poverty level in each dataset (18-24 and 25-34) I found the % of people in each county that are in each poverty level class. I then identified which class the median person is in using cumulative sum. This median person's class becomes the column that is mapped. I felt that doing this at the county level would be appropriately more granular, allowing for intra-state differences, and also illuminate discrepancies at the state level while at least partially respecting the cost of living argument concern. 

## QGIS Use 

I use QGIS to create the map from the shapefile outputs from R. The QGIS output is an SVG file that Adobe Illustrator can manipulate.

## Adobe Illustrator Use 

I use Adobe Illustrator to highlight specific regions and optimize the map layout. 
