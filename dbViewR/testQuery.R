# testQuery
# script to test queries

library(dbViewR)

########################################################
####         test selectFromDB       ###################
########################################################

## return all
  queryJSON <- jsonlite::toJSON(list(SELECT  =c("*")))
  db <- selectFromDB( queryJSON )

## return subset
  queryJSON <- jsonlite::toJSON(
    list(
      SELECT  =list(COLUMN=c('id','pathogen','timeInfected','samplingLocation','sex','fluShot','age','hasFever','hasCough','hasMyalgia')),
      WHERE   =list(COLUMN='pathogen', IN = c('h1n1pdm', 'h3n2')),
      WHERE   =list(COLUMN='timeInfected', BETWEEN = c(2019,2019.2)),
      WHERE   =list(COLUMN='samplingLocation', IN='hospital')
    )
  )
  db <- selectFromDB( queryJSON )

########################################################
####         test summarizeDB       ###################
########################################################


## return h1n1pdm summary by time and location
  queryJSON <- jsonlite::toJSON(
    list(
      SELECT   =list(COLUMN=c('pathogen','timeInfected','PUMA5CE','GEOID')),
      MUTATE   =list(COLUMN=c('timeInfected'), AS=c('timeBin','timeRow')),
      GROUP_BY =list(COLUMN=c('timeRow','PUMA5CE','GEOID')),
      SUMMARIZE=list(COLUMN='pathogen', IN= c('h1n1pdm'))
    )
  )
  db <- selectFromDB( queryJSON )


## return hasFever summary by age and location
  queryJSON <- jsonlite::toJSON(
    list(
      SELECT   =list(COLUMN=c('hasFever','age','PUMA5CE','GEOID')),
      GROUP_BY =list(COLUMN=c('age','PUMA5CE','GEOID')),
      SUMMARIZE=list(COLUMN='hasFever', IN= c(TRUE))
    )
  )
  db <- selectFromDB( queryJSON )


  ## predictions will need to marginalize over factors.
  ## one way is to weight predictions by factors, but that requires knowing who goes to what collection sites
  ## other option is model factors as random effects and predict marginal.  That requires no additional info,
  ## but assumes that factor intercepts are somehow normally distributed, which is weird
  ## I need a stats consult here...
