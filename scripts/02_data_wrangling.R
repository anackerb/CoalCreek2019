# This script handles data wrangling of the raw data imported from the OSMPGIS
# SQL server. If executing code directly from this script, you must first import
# the data from the OSMPGIS server. Uncomment the code below to run the import
# script directly from here. Make sure to comment it out again before saving the
# script as controller scripts will call the import script directly.

#source('scripts/01_import.R')

# load libraries ----------------------------------------------------------
require(dplyr)
require(lubridate)

# join data tables --------------------------------------------------------

veg_obs <- tblSample %>%
  filter(Project_ID == 13) %>%
  left_join(., tblEvent, by = 'Sample_ID') %>%
  inner_join(., tblVeg, by = 'Event_ID') %>%
  select(Date, Sample_name, Species, PctCover, DBH1, DBH2, DBH3, DBH4, DBH5) %>%
  mutate(sp = trimws(Species)) # remove leading/trailing whitespace

# d <- merge(tblProject, tblSample, by = 'Project_ID')
# d2 <- merge(d, tblEvent, by = 'Sample_ID')
# 
# veg1 <- merge(d2, tblVeg, by = 'Event_ID')

# veg2 <- veg[, c('Date', 'Sample_name', 'Species', 'PctCover', "DBH1"         ,    "DBH2"    ,         "DBH3"   ,         "DBH4"      ,       "DBH5" )]

veg_list <- tblOSMPVeg %>%
  select(sp = 'OSMP Code', Genus, Species, Nativity, Lifeform, LifeHistory, CValue)

# x <- x[, c('OSMP Code', 'Genus', 'Species', 'Nativity', 'Lifeform', 'LifeHistory', 'CValue')]
# names(x)[names(x) == 'OSMP Code'] <- 'sp'

# veg$Species <- gsub("[[:space:]]*$","",veg2$Species) # drop trailing spaces
# missing.sp <- veg_list$Species[!veg_list$Species %in% x$sp]

# sum(subset(veg2, Species %in% missing.sp)$PctCover, na.rm = T)
# sum(veg2$PctCover, na.rm = T)
# 225/75067 * 100
# ignorning missing species for now; make up < 0.5% of all cover

veg <- inner_join(veg_obs, veg_list, by = 'sp') %>%
  mutate(year = year(Date)) %>%
  rename_all(tolower) %>%
  mutate(transect = as.numeric(gsub('CCV-T|P[0-9]', '',sample_name)),
         plot     = as.numeric(gsub('CCV-T[0-9]P|CCV-T[0-9][0-9]P', '', sample_name)))

# the gsub() code above works by matching and removing (replacing with no
# character) all components of the sample_name except for the deisred transect
# or plot number

# names(veg2)[names(veg2) == 'Species'] <- 'sp'
# veg3 <- merge(veg2, x) # combine with species attribute data
# veg3$yr <- year(veg3$Date)

# head(veg)
# table(veg$year)

# names(veg) <- tolower(names(veg3))

# veg$transect <- gsub('CCV-T|P[0-9]', '', veg$sample_name)
# veg3$plot <- gsub('CCV-T[0-9]P|CCV-T[0-9][0-9]P', '', veg3$sample_name)
# head(veg3)
# veg3 <- veg3[order(veg3$date), ]
# subset(veg3, transect == 1 & plot == 3 & yr ==2004)
# table(veg3$sp, veg3$lifeform)
