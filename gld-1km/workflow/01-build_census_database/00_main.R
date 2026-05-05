# ----
# title       : build census database
# description : This is the main script for building a database of (national and sub-national) census data for all livestock dimensions of GPW.
# license     : https://creativecommons.org/licenses/by-sa/4.0/
# authors     : Steffen Ehrmann
# date        : 2026-05-03
# version     : 0.1.0
# status      : work in progress
# notes       :
# ----

library(arealDB)
library(tabshiftr)
library(tidyverse)
library(lubridate)

# paths ----
#
db_path <- "./gld-1km/workflow/01-build_census_database/"


# setup and start database ----
#
source(paste0(db_path, "01_boot.R")) # you need to run this every time you work on the database


# build vocabulary basis ----
#
source(paste0(db_path, "02_vocab.R"))


# build database ----
#
## global/regional dataseries ----
#
# source(paste0(db_path, "03_fao.R"))
# source(paste0(db_path, "03_agriwanet.R"))
# source(paste0(db_path, "03_eurostat.R"))


## national dataseries ----
#
# source(paste0(db_path, "04_argentina.R"))
# source(paste0(db_path, "04_australia.R"))
# source(paste0(db_path, "04_bolivia.R"))
# source(paste0(db_path, "04_brazil.R"))
# source(paste0(db_path, "04_canada.R"))
# source(paste0(db_path, "04_colombia.R"))
# source(paste0(db_path, "04_china.R"))
# source(paste0(db_path, "04_denmark.R"))
# source(paste0(db_path, "04_germany.R"))
# source(paste0(db_path, "04_india.R"))
# source(paste0(db_path, "04_indonesia.R"))
# source(paste0(db_path, "04_mexico.R"))
source(paste0(db_path, "04_mongolia.R"))
# source(paste0(db_path, "04_newZealand.R"))
# source(paste0(db_path, "04_norway.R"))
# source(paste0(db_path, "04_paraguay.R"))
# source(paste0(db_path, "04_peru.R"))
# source(paste0(db_path, "04_russia.R"))
# source(paste0(db_path, "04_ukraine.R"))
# source(paste0(db_path, "04_unitedStatesOfAmerica.R"))


# tie everything together ----
#
adb_backup()
adb_archive(outPath = db_path, compress = FALSE)
