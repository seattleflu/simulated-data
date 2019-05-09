# add age_range_fine

# simulated_subject_database.csv
dat<-read.csv('../simulated_subject_database.csv',quote='')

# add age_range_fine_lower
dat$age_range_fine = cut(dat$age, breaks=c(0, 2, seq(5,100,by=5)), right=FALSE, include.lowest = TRUE)

fine_lower <- sub(',.*','',sub('\\[','',levels(dat$age_range_fine))) 
fine_upper <- sub('\\]','',sub('.*,','',sub('\\)','',levels(dat$age_range_fine))))

dat$age_range_fine_lower = as.numeric(fine_lower)[match(sub(',.*','',sub('\\[','',dat$age_range_fine)),fine_lower)]
dat$age_range_fine_upper = as.numeric(fine_upper)[match(sub('\\]','',sub('.*,','',sub('\\)','',dat$age_range_fine))),fine_upper)]


dat$age_range_coarse = cut(dat$age, breaks=c(0, 2, 5, 18, 65, 90,100), right=FALSE)

coarse_lower <- sub(',.*','',sub('\\[','',levels(dat$age_range_coarse))) 
coarse_upper <- sub('\\]','',sub('.*,','',sub('\\)','',levels(dat$age_range_coarse)))) 

dat$age_range_coarse_lower = as.numeric(coarse_lower)[match(sub(',.*','',sub('\\[','',dat$age_range_coarse)),coarse_lower)]
dat$age_range_coarse_upper = as.numeric(coarse_upper)[match(sub('\\]','',sub('.*,','',sub('\\)','',dat$age_range_coarse))),coarse_upper)]


write.csv(dat,'../simulated_subject_database.csv',quote = FALSE, row.names = FALSE)


# forAuspice  
for(dirPath in list.dirs(paste(getwd(),'..','forAuspice',sep='/'))){
  for (filePath in list.files(path = dirPath, pattern="+\\.tsv", full.names=TRUE)){
    dat<-read.table(filePath,quote='',sep='\t',header = TRUE)

    dat$age_range_fine = cut(dat$age, breaks=c(0, 2, seq(5,100,by=5)), right=FALSE)
    dat$age_range_fine_lower = as.numeric(fine_lower)[match(sub(',.*','',sub('\\[','',dat$age_range_fine)),fine_lower)]
    dat$age_range_fine_upper = as.numeric(fine_upper)[match(sub('\\]','',sub('.*,','',sub('\\)','',dat$age_range_fine))),fine_upper)]
    
    dat$age_range_coarse = cut(dat$age, breaks=c(0, 2, 5, 18, 65, 90,100), right=FALSE)
    dat$age_range_coarse_lower = as.numeric(coarse_lower)[match(sub(',.*','',sub('\\[','',dat$age_range_coarse)),coarse_lower)]
    dat$age_range_coarse_upper = as.numeric(coarse_upper)[match(sub('\\]','',sub('.*,','',sub('\\)','',dat$age_range_coarse))),coarse_upper)]
    
    write.table(dat,filePath,quote = FALSE, row.names = FALSE,sep='\t')
  }
}
