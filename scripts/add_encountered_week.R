# add_num_date

# simulated_subject_database.csv
dat<-read.csv('../simulated_subject_database.csv',quote='')
dat$encountered_week <-format(as.Date(dat$encountered_date), "%G-W%V")
write.csv(dat,'../simulated_subject_database.csv',quote = FALSE, row.names = FALSE)

# forAuspice  
for(dirPath in list.dirs(paste(getwd(),'..','forAuspice',sep='/'))){
  for (filePath in list.files(path = dirPath, pattern="+\\.tsv", full.names=TRUE)){
    dat<-read.table(filePath,quote='',sep='\t',header = TRUE)
    dat$encountered_week <-format(as.Date(dat$encountered_date), "%G-W%V")
    write.table(dat,filePath,quote = FALSE, row.names = FALSE,sep='\t')
  }
}

