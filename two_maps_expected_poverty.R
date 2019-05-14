setwd("~/Maps for Fun/ACS_17_5YR_B17024")
x <- "ACS_17_5YR_B17024_with_ann.csv"
x <- read.csv(x,stringsAsFactors = FALSE)

segment_18_24_names <- names(grep(pattern = "18 to 24",as.vector(x[1,]),value = TRUE))
segment_18_24_names <- grep("HD01", segment_18_24_names, value = TRUE) # remove Margin of Error Columns 
segment_18_24 <- x[,c("GEO.id","GEO.id2","GEO.display.label","HD01_VD01",segment_18_24_names)]

colnames(segment_18_24) <- segment_18_24[1,]
segment_18_24 <- segment_18_24[-1,]

percent_18_24 <- segment_18_24
for(i in 4:17){ 
  segment_18_24[,i] <- as.numeric(segment_18_24[,i])
  percent_18_24[,i] <- segment_18_24[,i] / as.numeric(segment_18_24[,5])
  }

segment_25_34_names <- names(grep(pattern = "25 to 34",as.vector(x[1,]),value = TRUE))
segment_25_34_names <- grep("HD01", segment_25_34_names, value = TRUE) # remove Margin of Error Columns 
segment_25_34 <- x[,c("GEO.id","GEO.id2","GEO.display.label","HD01_VD01",segment_25_34_names)]

colnames(segment_25_34) <- segment_25_34[1,]
segment_25_34 <- segment_25_34[-1,]


percent_25_34 <- segment_25_34
for(i in 4:17){ 
  segment_25_34[,i] <- as.numeric(segment_25_34[,i])
  percent_25_34[,i] <- segment_25_34[,i] / as.numeric(segment_25_34[,5])
}

#' calculated expected poverty ratio as population weighted 
#' essentially, we get the percentage of each class in the county population
#' and assign a true/false flag for whether the cumulative population across classes 
#' is below .5 
#' once .5 is hit, the first true flag indicates what "class" the median is  in (e.g. 1.5 - 1.74 
#' means that the median 18-24 year old in that county earns 1.5 - 1.74x the poverty level)
#' The census definition for poverty levels is a bit convoluted,
#' they use household definition, (which is a function of location and number of adults and children)
#' and then apply that household definition to everyone in the household
#' 
      
classes_18_24 <- gsub(pattern = "Estimate; 18 to 24 years: - ",replacement =  "",x =  colnames(percent_18_24)[-c(1:5)])   
classes_25_34 <- gsub(pattern = "Estimate; 25 to 34 years: - ",replacement =  "",x =  colnames(percent_25_34)[-c(1:5)])

income_xPL <- NULL 
for(i in 1:nrow(percent_18_24)){ 
  #' for each row, identify which class the median person is in 
  #' and then assign a new column value the relevant poverty class 
  
temp. <- as.numeric(percent_18_24[i,6:17])  # get the % of each person in a poverty level class 
temp. <- cumsum(temp.) < .5
temp. <- sum(temp.) + 1 
#' consider the cumsum series:   .25, .43, .68, .88, .1
#' the true/false series for < .5 would be:  TRUE, TRUE, FALSE, FALSE, FALSE 
#' adding them up, would give us 2. The 2nd position, .43, is the class before the median (.5) person, 
#' so add 1 to get the median class.  

temp. <- classes_18_24[temp.] 
  
income_xPL <- c(income_xPL, temp.)  
}
percent_18_24$income_x_PL <- income_xPL

#' copy/paste for 25-34 
income_xPL <- NULL 
for(i in 1:nrow(percent_25_34)){ 
  #' for each row, identify which class the median person is in 
  #' and then assign a new column value the relevant poverty class 
  
  temp. <- as.numeric(percent_25_34[i,6:17])  # get the % of each person in a poverty level class 
  temp. <- cumsum(temp.) < .5
  temp. <- sum(temp.) + 1 
  #' consider the cumsum series:   .25, .43, .68, .88, .1
  #' the true/false series for < .5 would be:  TRUE, TRUE, FALSE, FALSE, FALSE 
  #' adding them up, would give us 2. The 2nd position, .43, is the class before the median (.5) person, 
  #' so add 1 to get the median class.  
  
  temp. <- classes_25_34[temp.] 
  
  income_xPL <- c(income_xPL, temp.)  
}
percent_25_34$income_x_PL <- income_xPL


#' merging both datasets to an albers equal area projection with AK and HI moved. 
#' 
devtools::install_github("https://github.com/hrbrmstr/albersusa")
# install.packages("albersusa") # something is wrong with CRAN version
library(albersusa)

county_ <- albersusa::counties_sf()



percent_18_24$fips <- percent_18_24$Id2
percent_25_34$fips <- percent_25_34$Id2


#' write to shapefile for QGIS & Adobe Illustrator 
shapes_18_24 <- merge(x = county_[,"fips"],y = percent_18_24,by = "fips", all.x = TRUE)  
shapes_25_34 <- merge(x = county_[,"fips"], y = percent_25_34, by = "fips", all.x = TRUE)


library(sf)
write_sf(shapes_18_24,"shapes_18_24.shp")
write_sf(shapes_25_34,"shapes_25_34.shp")
