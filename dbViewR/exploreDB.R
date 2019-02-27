# script to explore database

library(dplyr)
library(magrittr)
library(ggplot2)
library(dbViewR)  # see makePackage.R to install with devtools (or just use read.csv and pull in your own shapefiles)
library(viridis)



#######################################################
## load shapes, data, and initialize some plot stuff ##
#######################################################

shp <- dbViewR::masterSpatialDB()  # census-tract shapefiles
db<-dbViewR::selectFromDB(list(SELECT='*'))  #database.  db$observedData is the csv 

db$observedData <- db$observedData %>% dplyr::mutate( timeBin = floor((timeInfected)*52)/52)
db$observedData$timeRow <- as.integer(as.factor(db$observedData$timeBin))

db$observedData$GEOID<-as.character(db$observedData$GEOID)
shp$GEOID<-as.character(shp$GEOID)

names(db$observedData)

mapSettings <- ggplot() + scale_fill_viridis(na.value="transparent",trans = "log",breaks=c(1,3,5,10,30)) +
  xlim(c(122.5,121.7)) + ylim(c(47.17,47.76)) +  theme_bw() +
  theme(axis.text=element_blank(),axis.ticks=element_blank(),panel.grid.major=element_line(colour="transparent"), panel.border = element_blank())
p<-mapSettings + geom_sf(data=shp,size=0.1,aes(fill=NaN))
p

plotSettings <- ggplot() + theme_bw() +  theme(panel.border = element_blank()) + xlab('')

################################
### describe sample counts #####
################################

# sample count maps
  plotDat <- db$observedData %>%
              select(timeBin,timeRow,pathogen,GEOID,PUMA5CE,samplingLocation) %>%
              group_by(timeBin,timeRow,PUMA5CE,GEOID,samplingLocation) %>%
              summarize( n = as.numeric(n()),
                         count_h1n1pdm = as.numeric(sum(pathogen %in% 'h1n1pdm')),
                         count_h3n2 = as.numeric(sum(pathogen %in% 'h3n2')),
                         count_vic = as.numeric(sum(pathogen %in% 'vic')),
                         count_yam = as.numeric(sum(pathogen %in% 'yam')),
                         count_rsva = as.numeric(sum(pathogen %in% 'rsva')),
                         count_otherili = as.numeric(sum(pathogen %in% 'otherili'))
                       )
  plotDat <- right_join(plotDat,shp, by=c('GEOID','PUMA5CE'))
  head(plotDat<-plotDat[!is.na(plotDat$samplingLocation),])

  # png('map_counts_samplingLocation.png',units='in',width = 8,height = 4, res=300)
  p + geom_sf(data=plotDat,size=0, aes(fill=n)) + facet_wrap(~samplingLocation) +
    guides(fill=guide_legend(title="ILI count"))  + ggtitle('Total ARI')
  # dev.off()

  # png('map_counts_samplingLocation_h1n1pdm.png',units='in',width = 8,height = 4, res=300)
  p + geom_sf(data=plotDat,size=0, aes(fill=count_h1n1pdm)) + facet_wrap(~samplingLocation) +
    guides(fill=guide_legend(title="h1n1pdm count")) + ggtitle('H1N1pdm')
  # dev.off()


# h1n1pdm ILI fraction
  plotDat <- db$observedData %>%
    select(timeBin,timeRow,pathogen,GEOID,PUMA5CE) %>%
    mutate(timeRow = 5+5*floor(timeRow/5)) %>%
    group_by(timeRow,PUMA5CE,GEOID) %>%
    summarize( n = as.numeric(n()),
               count_h1n1pdm = as.numeric(sum(pathogen %in% 'h1n1pdm')),
               count_h3n2 = as.numeric(sum(pathogen %in% 'h3n2')),
               count_vic = as.numeric(sum(pathogen %in% 'vic')),
               count_yam = as.numeric(sum(pathogen %in% 'yam')),
               count_rsva = as.numeric(sum(pathogen %in% 'rsva')),
               count_otherili = as.numeric(sum(pathogen %in% 'otherili'))
    )
  plotDat$timeBin<-unique(db$observedData$timeBin)[plotDat$timeRow]
  plotDat <- right_join(plotDat,shp, by=c('GEOID','PUMA5CE'))
  plotDat <- plotDat[!is.na(plotDat$count_h1n1pdm/plotDat$n),]
  plotDat <- plotDat[plotDat$timeRow>5 | plotDat$timeBin<40,]
  plotDat <- plotDat[!is.na(plotDat$timeBin),]

  # png('map_freq_time_h1n1pdm.png',units='in',width = 8,height = 4, res=300)
  p + geom_sf(data=plotDat,size=0, aes(fill=count_h1n1pdm/n)) +
    guides(fill=guide_legend(title="fraction")) + ggtitle('H1N1pdm') + facet_wrap(~timeBin)+
    scale_fill_viridis(na.value="transparent",breaks=c(0.1,0.5,0.9))
  # dev.off()

  # png('map_count_time_h1n1pdm.png',units='in',width = 8,height = 4, res=300)
  p + geom_sf(data=plotDat,size=0, aes(fill=count_h1n1pdm)) +
    guides(fill=guide_legend(title="count")) + ggtitle('H1N1pdm') + facet_wrap(~timeBin)+
    scale_fill_viridis(na.value="transparent",breaks=c(1,3,5,9))
  # dev.off()

# sample count timeseries
  plotDat <- db$observedData %>%
    select(timeBin,timeRow,pathogen,samplingLocation) %>%
    group_by(timeBin,timeRow,samplingLocation) %>%
    summarize( n = as.numeric(n()),
               count_h1n1pdm = as.numeric(sum(pathogen %in% 'h1n1pdm')),
               count_h3n2 = as.numeric(sum(pathogen %in% 'h3n2')),
               count_vic = as.numeric(sum(pathogen %in% 'vic')),
               count_yam = as.numeric(sum(pathogen %in% 'yam')),
               count_rsva = as.numeric(sum(pathogen %in% 'rsva')),
               count_otherili = as.numeric(sum(pathogen %in% 'otherili'))
    )
  head(plotDat<-plotDat[!is.na(plotDat$samplingLocation),])


  # png('time_counts_samplingLocation.png',units='in',width = 5,height = 3, res=300)
  plotSettings + geom_line(data=plotDat, aes(x=timeBin,y=n, color=samplingLocation,group=samplingLocation)) +
    ggtitle('Total ILI') + ylab('count per week')
  # dev.off()

  # png('time_counts_samplingLocation_h1n1pdm.png',units='in',width = 5,height = 3, res=300)
  plotSettings + geom_line(data=plotDat, aes(x=timeBin,y=count_h1n1pdm, color=samplingLocation,group=samplingLocation)) +
    ggtitle('H1N1pdm') + ylab('count per week')
  # dev.off()

# sample count vs age
  plotDat <- db$observedData %>%
    select(age,pathogen) %>%
    mutate(ageBin = 2.5+floor(age/5)*5) %>%
    group_by(ageBin,pathogen) %>%
    summarize( n = as.numeric(n()))
  plotDat$frac<-plotDat$n
  for(k in unique(plotDat$pathogen)){
    idx<-plotDat$pathogen %in% k
    plotDat$frac[idx]<-plotDat$frac[idx]/sum(plotDat$n[idx])
  }

  # png('age_fraction_pathogen.png',units='in',width = 5,height = 3, res=300)
  plotSettings + geom_line(data=plotDat, aes(x=ageBin,y=frac, color=pathogen,group=pathogen)) +
    ggtitle('Fraction of ILI') + xlab('age')
  # dev.off()

# fever vs sampling location
  plotDat <- db$observedData %>%
    select(hasFever,samplingLocation) %>%
    group_by(hasFever,samplingLocation) %>%
    summarize( n = as.numeric(n()))
  plotDat$frac<-plotDat$n
  for(k in unique(plotDat$samplingLocation)){
    idx<-plotDat$samplingLocation %in% k
    plotDat$frac[idx]<-plotDat$frac[idx]/sum(plotDat$n[idx])
  }
  plotDat<-plotDat[plotDat$hasFever==1,]

  # png('fever_fraction_samplingLocation.png',units='in',width = 5,height = 3, res=300)
  plotSettings + geom_bar(data=plotDat, aes(x=samplingLocation,y=frac, fill=samplingLocation), position ="dodge", stat='identity') +
    ggtitle('Fraction of ILI with fever') + ylab('')
  # dev.off()


#######################################
#### Basic spatial smoothing ##########
#######################################
  library(INLA)

  #PUMAS spatial scale

  plotDat <- db$observedData %>%
    select(timeBin,timeRow,pathogen,GEOID,PUMA5CE,samplingLocation) %>%
    group_by(timeBin,timeRow,GEOID,PUMA5CE) %>%
    summarize( n = as.numeric(n()),
               count_h1n1pdm = as.numeric(sum(pathogen %in% 'h1n1pdm'))
    )

  ## add NaN to missing tracts and times to impute unobserved data
  completeData<-expand.grid(
    timeRow=unique(plotDat$timeRow),
    GEOID=shp$GEOID
  )
  completeData$timeBin <-unique(plotDat$timeBin)[completeData$timeRow ]
  completeData$PUMA5CE <- shp$PUMA5CE[match(completeData$GEOID,shp$GEOID)]
  plotDat<-right_join(plotDat, completeData )

  plotDat <- right_join(plotDat,shp, by=c('GEOID','PUMA5CE'))
  plotDat$timeRow_rowID <- plotDat$timeRow

  plotDat$PUMA5CE<-as.character(plotDat$PUMA5CE)


  # set up model
  time_bin_global.informative.hyper = list(prec = list( prior = "pc.prec", param = 0.5, alpha = 0.01))
  time_bin_local.informative.hyper = list(prec = list( prior = "pc.prec", param = 1, alpha = 0.01))
  PUMA.informative.hyper = list(prec = list( prior = "pc.prec", param = 1, alpha = 0.01))

  W <- plotDat$n
  F <- count_h1n1pdm ~  f(timeRow, model='rw2', hyper = time_bin_global.informative.hyper) +
    f(PUMA5CE,model="iid", hyper = PUMA.informative.hyper,
      group = timeRow_rowID, control.group=list(model="rw2",hyper=time_bin_local.informative.hyper))

  model <- inla(formula = F,family="poisson",data=plotDat,
                control.predictor=list(compute=TRUE,link=1),
                control.compute=list(config=TRUE,dic=TRUE),verbose = TRUE,
                control.inla=list(int.strategy="eb", strategy = "gaussian"))
  summary(model)
  saveRDS(model,'pumatimeSmooth.RDS')
  model<-readRDS('pumatimeSmooth.RDS')

  ## append inferences
  plotDat$incidence_mode <- model$summary.fitted.values$mode
  plotDat$incidence_sd <- model$summary.fitted.values$sd

  plotDat2<-plotDat[plotDat$timeRow %in% seq(1,30, by = 5),]

  # png('model_map_count_puma_h1n1pdm.png',units='in',width = 8,height = 4, res=300)
  p + geom_sf(data=plotDat2,size=0, aes(fill=incidence_mode)) + facet_wrap(~timeBin)+
    guides(fill=guide_legend(title="expected cases")) + ggtitle('H1N1pdm') +
    scale_fill_viridis(na.value="transparent",trans='sqrt',breaks=c(0.001,0.01,0.1,0.25,0.49,1))
  # dev.off()

