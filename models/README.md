# simulated-data/models

This directory contains some examples of data modeled with tools in [seattleflu/incidence-mapper](https://github.com/seattleflu/incidence-mapper/tree/simulated-data-test-workflow).

## Catchment maps

Catchment maps provide a visual representation of where our subjects live.  The input data is the total number of subjects residing at each geolocation. The model is a spatial smoothing of that data to represent the enrollment rates from each geolocation at each samplingLocation.  At larger aggregations, the model adds essentially nothing over the raw data, but at small scales the model should be a more accurate representation of the true catctment rates.   

For each geolocation, the raw and modeled values are counts spanning the total time of the study to date.  Within a samplingLocation map, the meaning is relative--high vs low is more informative than the absolute level.  But across sampling locations, the absolute levels may be more informative as they show how much comes through each site.   Also, the total catchment of the study is the sum over all sampling locations. 

## Age distributions for each pathogen

These give the fraction of all samples that were a specific pathogen across ages.  For example, the age distribution of rsva is the fraction of samples at each age positive for rsva divided by the total number of samples at that age.  The current files describe the total study population and are not stratified by geography or samplingLocation.

