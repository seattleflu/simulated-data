# add encountered_date

library(lubridate)

# simulatedSubjectDatabase.csv
  dat<-read.csv('../simulatedSubjectDatabase.csv',quote='')
  dat$encountered_date<-as.character(floor_date(date_decimal(dat$timeInfected), unit='days'))
  write.csv(dat,'simulatedSubjectDatabase.csv',quote = FALSE, row.names = FALSE)

# forAuspice  
  for(dirPath in list.dirs(paste(getwd(),'..','forAuspice',sep='/'))){
    for (filePath in list.files(path = dirPath, pattern="+\\.tsv", full.names=TRUE)){
      dat<-read.table(filePath,quote='',sep='\t',header = TRUE)
      dat$encountered_date<-as.character(floor_date(date_decimal(dat$timeInfected), unit='days'))
      write.table(dat,filePath,quote = FALSE, row.names = FALSE,sep='\t')
    }
  }
  
  