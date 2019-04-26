# add_num_date

# random character string: https://stackoverflow.com/questions/42734547/generating-random-strings
randID <- function(n = 5000) {
  a <- do.call(paste0, replicate(5, sample(LETTERS, n, TRUE), FALSE))
  paste0(a, sprintf("%04d", sample(9999, n, TRUE)), sample(LETTERS, n, TRUE))
}

# simulated_subject_database.csv
dat<-read.csv('../simulated_subject_database.csv',quote='')

# add encounter id
dat$encounter = randID(n= nrow(dat))

# change sampling_location to site_type
names(dat)[names(dat) == 'sampling_location'] <- 'site_type'

# change id to individual
names(dat)[names(dat) == 'id'] <- 'individual'

# change GEOID to residence_census_tract
names(dat)[names(dat) == 'GEOID'] <- 'residence_census_tract'

# change PUMA5CE, CRA_NAME, and NEIGHBORHOOD_DISTRICT_NAME
names(dat)[names(dat) %in% c('PUMA5CE','CRA_NAME','NEIGHBORHOOD_DISTRICT_NAME')] <- 
  paste('residence_', tolower(names(dat)[names(dat) %in% c('PUMA5CE','CRA_NAME','NEIGHBORHOOD_DISTRICT_NAME')]),sep='')

write.csv(dat,'../simulated_subject_database.csv',quote = FALSE, row.names = FALSE)


# forAuspice  
for(dirPath in list.dirs(paste(getwd(),'..','forAuspice',sep='/'))){
  for (filePath in list.files(path = dirPath, pattern="+\\.tsv", full.names=TRUE)){
    dat<-read.table(filePath,quote='',sep='\t',header = TRUE)

    dat$encounter = randID(n= nrow(dat))
    names(dat)[names(dat) == 'sampling_location'] <- 'site_type'
    names(dat)[names(dat) == 'id'] <- 'individual'
    names(dat)[names(dat) == 'GEOID'] <- 'residence_census_tract'
    names(dat)[names(dat) %in% c('PUMA5CE','CRA_NAME','NEIGHBORHOOD_DISTRICT_NAME')] <- 
      paste('residence_', tolower(names(dat)[names(dat) %in% c('PUMA5CE','CRA_NAME','NEIGHBORHOOD_DISTRICT_NAME')]),sep='')
    
    # fix a few others while I'm here
    names(dat)[names(dat) == 'samplingLocation'] <- 'site_type'
    names(dat)[names(dat) == 'fluShot'] <- 'flu_shot'
    names(dat)[names(dat) == 'clusterId'] <- 'cluster_id'
    names(dat)[names(dat) == 'timeInfected'] <- 'time_infected'
    names(dat)[names(dat) == 'infectiousDuration'] <- 'infectious_duration'
    names(dat)[names(dat) == 'hasFever'] <- 'has_fever'
    names(dat)[names(dat) == 'hasCough'] <- 'has_cough'
    names(dat)[names(dat) == 'hasMyalgia'] <- 'has_myalgia'
    
    write.table(dat,filePath,quote = FALSE, row.names = FALSE,sep='\t')
  }
}
