# kingCountySpatialData

The is a cache of the spatial data used in the simulatedSFS models.

## Master files used to generate simulated data

### kingCountCensusTractGEOIDandAggregation.csv

Master list of King County, WA census tracts from 2016 TIGER dataset. Fields: 
- STATEFP
- COUNTYFP
- TRACTCE
- GEOID
- rowID (used in analysis code)
- CRA_NAME (colloquial Seattle Neighborhoods, NA if outside Seattle)
- NEIGHBORHOOD_DISTRICT_NAME (Seattle neighborhood aggregations, NA if outside Seattle)
- PUMA5CE (Federal Public Use Microdata Areas from 2010 TIGER data)

### kc.adj

Census Tract adjacency matrix.  List of lists of neighbors of each census tract, labeled by rowID in kingCountCensusTractGEOIDandAggregation.csv.

## Source files

Sources of non-obvious linking data. 

### 2010_Census_Tract_to_2010_PUMA.txt

Mapping of tracts to pumas from [census.gov](http://www2.census.gov/geo/docs/maps-data/data/rel/2010_Census_Tract_to_2010_PUMA.txt).

### SeattleCensusBlocksandNeighborhoodCorrelationFile.csv

Source of Seattle neighborhood data from [seattle.gov](https://www.seattle.gov/Documents/Departments/OPCD/Demographics/GeographicFilesandMaps/SeattleCensusBlocksandNeighborhoodCorrelationFile.xlsx)


 




 