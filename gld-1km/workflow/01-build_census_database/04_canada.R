# ----
# title       : build census database - statcan
# description : this script integrates data of 'Statistics Canada' (https://www.statcan.gc.ca/eng/start)
# license     : https://creativecommons.org/licenses/by-sa/4.0/
# authors     : Steffen Ehrmann
# date        : 2025-01-31
# version     : 1.0.0
# status      : finished
# notes       :
# ----
# geography   : Canada
# spatial     : ADM0, ADM1, Census Division, Census Consolidated Subdivisions
# period      : 1921 - 2021
# sampling    : survey, census
# comment     : census for 2011, 2016, 2021 at level 4; other material: overview of land use, tenure and management https://www150.statcan.gc.ca/n1/pub/95-634-x/2017001/article/54903-eng.htm, land tenure https://www150.statcan.gc.ca/t1/tbl1/en/cv.action?pid=3210023401, greenhouse database https://www.statcan.gc.ca/en/lode/databases/odg, 2001 agricultural census at fine spatial level (but available only in html) https://www150.statcan.gc.ca/n1/pub/95f0301x/4151237-eng.htm
# ----

thisNation <- "Canada"
# source(paste0(db_path, "preprocess_statcan.R"))

ds <- c("statcan")
gs <- c("statcan")


# 1. dataseries ----
#
regDataseries(name = ds[1],
              description = "Statistics Canada",
              homepage = "https://www.statcan.gc.ca/eng/start",
              version = "2023.12",
              licence_link = "https://www.statcan.gc.ca/eng/reference/licence")


# 2. geometries ----
#
regGeometry(ADM0 = !!thisNation, # provinces/territories
            gSeries = gs[1],
            label = list(ADM1 = "PRENAME"),
            archive = "lpr_000b21a_e.zip|lpr_000b21a_e.shp",
            archiveLink = "https://www12.statcan.gc.ca/census-recensement/2021/geo/sip-pis/boundary-limites/files-fichiers/lpr_000b21a_e.zip",
            downloadDate = ymd("2019-10-10"),
            updateFrequency = "unknown")

# regGeometry(ADM0 = !!thisNation, # census agricultural regions
#             gSeries = gs[1],
#             label = list(ADM1 = "CARENAME"),
#             archive = "lcar000b21a_e.zip|lcar000b21a_e.shp",
#             archiveLink = "https://www12.statcan.gc.ca/census-recensement/2021/geo/sip-pis/boundary-limites/files-fichiers/lcar000b21a_e.zip",
#             updateFrequency = "unknown")

regGeometry(ADM0 = !!thisNation,  # census divisions
            gSeries = gs[1],
            label = list(ADM2 = "CDNAME"),
            archive = "lcd_000b21a_e.zip|lcd_000b21a_e.shp",
            archiveLink = "https://www12.statcan.gc.ca/census-recensement/2021/geo/sip-pis/boundary-limites/files-fichiers/lcd_000b21a_e.zip",
            downloadDate = ymd("2019-10-10"),
            updateFrequency = "unknown")

regGeometry(ADM0 = !!thisNation,  # census consolidated subdivisions
            gSeries = gs[1],
            label = list(ADM3 = "CCSNAME"),
            archive = "lccs000b21a_e.zip|lccs000b21a_e.shp",
            archiveLink = "https://www12.statcan.gc.ca/census-recensement/2021/geo/sip-pis/boundary-limites/files-fichiers/lccs000b21a_e.zip",
            downloadDate = ymd("2019-10-10"),
            updateFrequency = "unknown")

normGeometry(pattern = gs[1],
             beep = 10)


# 3. tables ----
#
schema_statcan <-
  setIDVar(name = "ADM0", value = "Canada") |>
  setIDVar(name = "ADM1", columns = .find(pattern = "al2", row = 1)) |>
  setIDVar(name = "year", columns = .find(pattern = "REF_DATE", row = 1))

schema_statcan_census <- schema_statcan |>
  setIDVar(name = "method", value = "census") |>
  setIDVar(name = "ADM2", columns = .find(pattern = "al3", row = 1), split = "^(.*),[^,]*$") |>
  setIDVar(name = "ADM3", columns = .find(pattern = "al4", row = 1), split = "^(.*),[^,]*$")

schema_statcan_survey <- schema_statcan |>
  setIDVar(name = "method", value = "survey")

## other livestock ----
schema_statcan_survey_otherLivestock <- schema_statcan_survey |>
  setIDVar(name = "animal", columns = .find(pattern = "Selected livestock", row = 1)) |>
  setObsVar(name = "number_heads", columns = .find(pattern = "VALUE", row = 1),
            key = .find(pattern = "Unit of measure", row = 1), value = "Number of animals")

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "otherLivestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_statcan_survey_otherLivestock,
         begin = 1921,
         end = 2021,
         archive = "32100155-eng.zip|32100155.csv",
         archiveLink = "https://www150.statcan.gc.ca/n1/tbl/csv/32100155-eng.zip",
         updateFrequency = "annual",
         downloadDate = ymd("2019-10-10"),
         metadataLink = "32100155_MetaData.csv",
         metadataPath = "https://www150.statcan.gc.ca/t1/tbl1/en/cv.action?pid=3210015501",
         overwrite = TRUE)

schema_statcan_census_otherLivestock <- schema_statcan_census |>
  setIDVar(name = "animal", columns = .find(pattern = "Other livestock", row = 1)) |>
  setObsVar(name = "number_heads", columns = .find(pattern = "VALUE", row = 1),
            key = .find(pattern = "Unit of measure", row = 1), value = "Number of animals")

regTable(ADM0 = !!thisNation,
         label = "ADM3",
         subset = "otherLivestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_statcan_census_otherLivestock,
         begin = 2011,
         end = 2016,
         archive = "32100427-eng.zip|32100427.csv",
         archiveLink = "https://www150.statcan.gc.ca/n1/tbl/csv/32100427-eng.zip",
         updateFrequency = "quinquennial",
         downloadDate = ymd("2019-10-10"),
         metadataPath = "32100427_MetaData.csv",
         metadataLink = "https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=3210042701",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM3",
         subset = "otherLivestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_statcan_census_otherLivestock,
         begin = 2021,
         end = 2021,
         archive = "32100373-eng.zip|32100373.csv",
         archiveLink = "https://www150.statcan.gc.ca/n1/tbl/csv/32100373-eng.zip",
         updateFrequency = "quinquennial",
         downloadDate = ymd("2023-10-10"),
         metadataPath = "32100373_MetaData.csv",
         metadataLink = "https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=3210037301",
         overwrite = TRUE)

## cattle ----
schema_statcan_survey_cattle <- schema_statcan_survey |>
  setFilter(rows = .find(pattern = "At July 1", col = 5)) |>
  setIDVar(name = "animal", columns = .find(pattern = "Livestock", row = 1)) |>
  setObsVar(name = "number_heads", factor = 1000, columns = .find(pattern = "VALUE", row = 1),
            key = .find(pattern = "Farm type", row = 1), value = "On all cattle operations")

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "cattle",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_statcan_survey_cattle,
         begin = 1931,
         end = 2023,
         archive = "32100130-eng.zip|32100130.csv",
         archiveLink = "https://www150.statcan.gc.ca/n1/tbl/csv/32100130-eng.zip",
         updateFrequency = "annual",
         downloadDate = ymd("2019-10-10"),
         metadataLink = "32100130_MetaData.csv",
         metadataPath = "https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=3210013001",
         overwrite = TRUE)

schema_statcan_census_cattle <- schema_statcan_census |>
  setIDVar(name = "animal", columns = .find(pattern = "Cattle and calves", row = 1)) |>
  setObsVar(name = "number_heads", columns = .find(pattern = "VALUE", row = 1),
            key = .find(pattern = "Unit of measure", row = 1), value = "Number of animals")

regTable(ADM0 = !!thisNation,
         label = "ADM3",
         subset = "cattle",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_statcan_census_cattle,
         begin = 2011,
         end = 2016,
         archive = "32100424-eng.zip|32100424.csv",
         archiveLink = "https://www150.statcan.gc.ca/n1/tbl/csv/32100424-eng.zip",
         updateFrequency = "quinquennial",
         downloadDate = ymd("2019-10-10"),
         metadataPath = "32100424_MetaData.csv",
         metadataLink = "https://www150.statcan.gc.ca/t1/tbl1/en/cv.action?pid=3210042401",
         overwrite = TRUE)

schema_statcan_census_cattle2 <- schema_statcan_census |>
  setIDVar(name = "animal", columns = .find(pattern = "Cattle", row = 1)) |>
  setObsVar(name = "number_heads", columns = .find(pattern = "VALUE", row = 1),
            key = .find(pattern = "Unit of measure", row = 1), value = "Number of animals")

regTable(ADM0 = !!thisNation,
         label = "ADM3",
         subset = "cattle",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_statcan_census_cattle2,
         begin = 2021,
         end = 2021,
         archive = "32100370-eng.zip|32100370.csv",
         archiveLink = "https://www150.statcan.gc.ca/n1/tbl/csv/32100370-eng.zip",
         updateFrequency = "quinquennial",
         downloadDate = ymd("2019-10-10"),
         metadataPath = "32100370_MetaData.csv",
         metadataLink = "https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=3210037001",
         overwrite = TRUE)

## pigs ----
schema_statcan_survey_pig <- schema_statcan_survey |>
  setFilter(rows = .find(pattern = "At July 1", col = 5)) |>
  setIDVar(name = "animal", columns = .find(pattern = "Livestock", row = 1)) |>
  setObsVar(name = "number_heads", columns = .find(pattern = "VALUE", row = 1))

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "pigs",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_statcan_survey_pig,
         begin = 2008,
         end = 2023,
         archive = "32100160-eng.zip|32100160.csv",
         archiveLink = "https://www150.statcan.gc.ca/n1/tbl/csv/32100160-eng.zip",
         updateFrequency = "annual",
         downloadDate = ymd("2019-10-10"),
         metadataLink = "32100160_MetaData.csv",
         metadataPath = "https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=3210016001",
         overwrite = TRUE)

schema_statcan_census_pigs <- schema_statcan_census |>
  setIDVar(name = "animal", columns = .find(pattern = "Pigs", row = 1)) |>
  setObsVar(name = "number_heads", columns = .find(pattern = "VALUE", row = 1),
            key = .find(pattern = "Unit of measure", row = 1), value = "Number of animals")

regTable(ADM0 = !!thisNation,
         label = "ADM3",
         subset = "pigs",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_statcan_census_pigs,
         begin = 2011,
         end = 2016,
         archive = "32100426-eng.zip|32100426.csv",
         archiveLink = "https://www150.statcan.gc.ca/n1/tbl/csv/32100426-eng.zip",
         updateFrequency = "quinquennial",
         downloadDate = ymd("2019-10-10"),
         metadataPath = "32100426_MetaData.csv",
         metadataLink = "https://www150.statcan.gc.ca/t1/tbl1/en/cv.action?pid=3210042601",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM3",
         subset = "pigs",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_statcan_census_pigs,
         begin = 2021,
         end = 2021,
         archive = "32100372-eng.zip|32100372.csv",
         archiveLink = "https://www150.statcan.gc.ca/n1/tbl/csv/32100372-eng.zip",
         updateFrequency = "quinquennial",
         downloadDate = ymd("2019-10-10"),
         metadataPath = "32100372_MetaData.csv",
         metadataLink = "https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=3210037201",
         overwrite = TRUE)

## sheep  ----
schema_statcan_survey_sheep <- schema_statcan_survey |>
  setFilter(rows = .find(pattern = "At July 1", col = 5)) |>
  setIDVar(name = "animal", columns = .find(pattern = "Livestock", row = 1)) |>
  setObsVar(name = "number_heads", columns = .find(pattern = "VALUE", row = 1))

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "sheep",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_statcan_survey_sheep,
         begin = 1906,
         end = 2023,
         archive = "32100129-eng.zip|32100129.csv",
         archiveLink = "https://www150.statcan.gc.ca/n1/tbl/csv/32100129-eng.zip",
         updateFrequency = "annual",
         downloadDate = ymd("2019-10-10"),
         metadataLink = "32100129_MetaData.csv",
         metadataPath = "https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=3210012901",
         overwrite = TRUE)

schema_statcan_census_sheep <- schema_statcan_census |>
  setIDVar(name = "animal", columns = .find(pattern = "Sheep and lambs", row = 1)) |>
  setObsVar(name = "number_heads", columns = .find(pattern = "VALUE", row = 1),
            key = .find(pattern = "Unit of measure", row = 1), value = "Number of animals")

regTable(ADM0 = !!thisNation,
         label = "ADM3",
         subset = "sheep",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_statcan_census_sheep,
         begin = 2011,
         end = 2016,
         archive = "32100425-eng.zip|32100425.csv",
         archiveLink = "https://www150.statcan.gc.ca/n1/tbl/csv/32100425-eng.zip",
         updateFrequency = "quinquennial",
         downloadDate = ymd("2019-10-10"),
         metadataPath = "32100425_MetaData.csv",
         metadataLink = "https://www150.statcan.gc.ca/t1/tbl1/en/cv.action?pid=3210042501",
         overwrite = TRUE)

schema_statcan_census_sheep2 <- schema_statcan_census |>
  setIDVar(name = "animal", columns = .find(pattern = "Sheep", row = 1)) |>
  setObsVar(name = "number_heads", columns = .find(pattern = "VALUE", row = 1),
            key = .find(pattern = "Unit of measure", row = 1), value = "Number of animals")

regTable(ADM0 = !!thisNation,
         label = "ADM3",
         subset = "sheep",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_statcan_census_sheep2,
         begin = 2021,
         end = 2021,
         archive = "32100371-eng.zip|32100371.csv",
         archiveLink = "https://www150.statcan.gc.ca/n1/tbl/csv/32100371-eng.zip",
         updateFrequency = "quinquennial",
         downloadDate = ymd("2019-10-10"),
         metadataPath = "32100371_MetaData.csv",
         metadataLink = "https://www150.statcan.gc.ca/t1/tbl1/en/cv.action?pid=3210037101",
         overwrite = TRUE)

## poultry ----
schema_statcan_survey_poultry <- schema_statcan_survey |>
  setIDVar(name = "animal", columns = .find(pattern = "Commodity", row = 1)) |>
  setObsVar(name = "number_heads", columns = .find(pattern = "VALUE", row = 1))

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "poultry",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_statcan_survey_poultry,
         begin = 1970,
         end = 2023,
         archive = "32100120-eng.zip|32100120.csv",
         archiveLink = "https://www150.statcan.gc.ca/n1/tbl/csv/32100120-eng.zip",
         updateFrequency = "annual",
         downloadDate = ymd("2019-10-10"),
         metadataLink = "32100120_MetaData.csv",
         metadataPath = "https://www150.statcan.gc.ca/t1/tbl1/en/cv.action?pid=3210012001",
         overwrite = TRUE)

schema_statcan_census_poultry <- schema_statcan_census |>
  setIDVar(name = "animal", columns = .find(pattern = "Poultry inventory", row = 1)) |>
  setObsVar(name = "number_heads", columns = .find(pattern = "VALUE", row = 1),
            key = .find(pattern = "Unit of measure", row = 1), value = "Number of birds")

regTable(ADM0 = !!thisNation,
         label = "ADM3",
         subset = "poultry",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_statcan_census_poultry,
         begin = 2011,
         end = 2016,
         archive = "32100428-eng.zip|32100428.csv",
         archiveLink = "https://www150.statcan.gc.ca/n1/tbl/csv/32100428-eng.zip",
         updateFrequency = "quinquennial",
         downloadDate = ymd("2019-10-10"),
         metadataPath = "32100428_MetaData.csv",
         metadataLink = "https://www150.statcan.gc.ca/t1/tbl1/en/cv.action?pid=3210042801",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM3",
         subset = "poultry",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_statcan_census_poultry,
         begin = 2021,
         end = 2021,
         archive = "32100374-eng.zip|32100374.csv",
         archiveLink = "https://www150.statcan.gc.ca/n1/tbl/csv/32100374-eng.zip",
         updateFrequency = "quinquennial",
         downloadDate = ymd("2019-10-10"),
         metadataPath = "32100374_MetaData.csv",
         metadataLink = "https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=3210037401",
         overwrite = TRUE)

## bees ----
schema_statcan_survey_bees <- schema_statcan_survey |>
  setIDVar(name = "animal", value = "bees") |>
  setObsVar(name = "colonies", columns = .find(pattern = "VALUE", row = 1),
            key = .find(pattern = "Estimates", row = 1), value = "Colonies")

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "bees",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_statcan_survey_bees,
         begin = 1924,
         end = 2022,
         archive = "32100353-eng.zip|32100353.csv",
         archiveLink = "https://www150.statcan.gc.ca/n1/tbl/csv/32100353-eng.zip",
         updateFrequency = "annual",
         downloadDate = ymd("2019-10-10"),
         metadataLink = "32100353_MetaData.csv",
         metadataPath = "https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=3210035301",
         overwrite = TRUE)

schema_statcan_census_bees <- schema_statcan_census |>
  setIDVar(name = "animal", columns = .find(pattern = "Bees", row = 1)) |>
  setObsVar(name = "colonies", columns = .find(pattern = "VALUE", row = 1),
            key = .find(pattern = "Unit of measure", row = 1), value = "Number")

regTable(ADM0 = !!thisNation,
         label = "ADM3",
         subset = "bees",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_statcan_census_bees,
         begin = 2011,
         end = 2016,
         archive = "32100432-eng.zip|32100432.csv",
         archiveLink = "https://www150.statcan.gc.ca/n1/tbl/csv/32100432-eng.zip",
         updateFrequency = "quinquennial",
         downloadDate = ymd("2019-10-10"),
         metadataPath = "32100432_MetaData.csv",
         metadataLink = "https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=3210043201",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM3",
         subset = "bees",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_statcan_census_bees,
         begin = 2021,
         end = 2021,
         archive = "32100378-eng.zip|32100378.csv",
         archiveLink = "https://www150.statcan.gc.ca/n1/tbl/csv/32100378-eng.zip",
         updateFrequency = "quinquennial",
         downloadDate = ymd("2019-10-10"),
         metadataPath = "32100378_MetaData.csv",
         metadataLink = "https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=3210037801",
         overwrite = TRUE)

## mink, fox ----
schema_statcan_survey_mink <- schema_statcan_survey |>
  setIDVar(name = "animal", columns = .find(pattern = "Type of animal", row = 1)) |>
  setObsVar(name = "number_heads", columns = .find(pattern = "VALUE", row = 1),
            key = .find(pattern = "Supply and disposition", row = 1), value = "On farms at December 31")

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "minkFox",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_statcan_survey_mink,
         begin = 1970,
         end = 2020,
         archive = "32100116-eng.zip|32100116.csv",
         archiveLink = "https://www150.statcan.gc.ca/n1/tbl/csv/32100116-eng.zip",
         updateFrequency = "annual",
         downloadDate = ymd("2019-10-10"),
         metadataPath = "32100116_MetaData.csv",
         metadataLink = "https://www150.statcan.gc.ca/t1/tbl1/en/cv.action?pid=3210011601",
         overwrite = TRUE)

normTable(pattern = ds[1],
          ontoMatch = "animal",
          beep = 10)
