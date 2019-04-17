# simulated-data/models

This directory contains some examples of data modeled with tools in [seattleflu/incidence-mapper](https://github.com/seattleflu/incidence-mapper/tree/simulated-data-test-workflow).

## Catchment maps

Catchment maps provide a visual representation of where our subjects live.  The input data is the total number of subjects residing at each geolocation. The model is a spatial smoothing of that data to represent the enrollment rates from each geolocation at each samplingLocation.  At larger aggregations, the model adds essentially nothing over the raw data, but at small scales the model should be a more accurate representation of the true catctment rates.   

For each geolocation, the raw and modeled values are counts spanning the total time of the study to date.  Within a samplingLocation map, the meaning is relative--high vs low is more informative than the absolute level.  But across sampling locations, the absolute levels may be more informative as they show how much comes through each site.   Also, the total catchment of the study is the sum over all sampling locations. 

## Age distributions for each pathogen

These give the fraction of all samples that were a specific pathogen across ages.  For example, the age distribution of rsva is the fraction of samples at each age positive for rsva divided by the total number of samples at that age.  The current files describe the total study population and are not stratified by geography or samplingLocation.

## Latent field models

(Better methods description will come.) Latent field models use mixed effects regression to infer unobserved (latent) spatialtemporal (field) correlations in measured disease incidence from observations and known covariates (encountered_date, age, sampling_location, home census location, flu_shot, etc).  Given our observations and our assumptions about spatialtemporal structure, the inferred latent field serves as an (unnormalized) model of the unobserved drivers of our observations, which we assume are dominated by disease incidence.  Thus, the inferred latent field can be interpreted as incidence, but without a well-defined scale.  In other words, relative changes in indidence are meaningful, both in direction and magnitude, but the absolute incidence (cases per 1000 people) is unknown.  For this reason, in addition to providing the estimated latent field values, we can look at the quintiles, which summarize the distribution over space and time but don't describe the magnitude.

The latent field models differ from a generic smoother of the data in that they adjust for the estimated catchments of our sampling sites. The idea is that true incidence is revealed not by the raw case counts, which combine disease incidence by space and time with spatial variations in the participation rate, but rather by the variation by space and time relative to the local participation rate. To define the catchment, we assume (for now) that the geography of study participation depends only on space and sampling location, and not time, pathogen, specific symptoms, etc. All other covariates inform disease-specific patterns, given the catchment.

Note: the files currently checked in have not been carefully tested for scientific validity, but I've put them up for visualization prototyping.  Validation relative to the complete simulated histories (that are not in this repo currently) is in the works.

## Post-stratified models

(Long-term to-do.)  In contrast to the latent field models, post-stratefied models incorporate denominator data and systematic survey weights to estimate true incidence in the population.  These models build on the latent field models with normalizing data to obtain estimates on the natural scale. 