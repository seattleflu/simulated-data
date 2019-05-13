# csvToJSON

library(jsonlite)
library(R.utils)

file_dir <- '../models/'

# forAuspice  
for(dirPath in list.dirs(file_dir)){
  for (filePath in list.files(path = dirPath, pattern="+\\.csv", full.names=TRUE)){
    dat<-read.table(filePath,quote='',sep=',',header = TRUE)
    
    if (file.size(filePath) <= 2^21){
      write_json(dat, path= sub('csv','json',filePath), pretty=TRUE)
    } else {
      fn<-sub('csv','json',filePath)
      write_json(dat, path=fn, pretty=FALSE)
      # gzip(fn)
      # unlink(fn)
    }
  }
}
