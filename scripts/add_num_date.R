# add_num_date

# simulatedSubjectDatabase.csv
dat<-read.csv('../simulatedSubjectDatabase.csv',quote='')
dat$num_date<-dat$timeInfected
write.csv(dat,'../simulatedSubjectDatabase.csv',quote = FALSE, row.names = FALSE)

# forAuspice  
for(dirPath in list.dirs(paste(getwd(),'..','forAuspice',sep='/'))){
  for (filePath in list.files(path = dirPath, pattern="+\\.tsv", full.names=TRUE)){
    dat<-read.table(filePath,quote='',sep='\t',header = TRUE)
    dat$num_date<-dat$timeInfected
    write.table(dat,filePath,quote = FALSE, row.names = FALSE,sep='\t')
  }
}

