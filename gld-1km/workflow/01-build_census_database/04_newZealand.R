# ----
# title       : build census database - nzstat, nzgeo
# description : this script integrates data of 'Stats NZ' (stats.govt.nz), 'NZ Geographic Data Service' (https://datafinder.stats.govt.nz/)
# license     : https://creativecommons.org/licenses/by-sa/4.0/
# authors     : Steffen Ehrmann
# date        : 2025-01-31
# version     : 1.0.0
# status      : finished
# notes       :
# ----
# geography   : New Zealand
# spatial     : ADM0, Regional Council, Territorial Authority
# period      : 1990 - 2022
# sampling    : survey
# comment     : archived data (pdfs etc): https://cdm20045.contentdm.oclc.org/digital?page=1, how to find old data not (yet) on the new website: https://www.stats.govt.nz/about-us/stats-nz-archive-website/
# ----

thisNation <- "New Zealand"

ds <- c("nzstat")
gs <- c("nzGeo")

# 1. dataseries ----
#
regDataseries(name = ds[1],
              description = "Stats NZ",
              homepage = "stats.govt.nz",
              version = "2023.12",
              licence_link = "unknown")

regDataseries(name = gs[1],
              description = "NZ Geographic Data Service",
              homepage = "https://datafinder.stats.govt.nz/",
              version = "2023.12",
              licence_link = "unknown")


# 2. geometries ----
#
regGeometry(ADM0 = !!thisNation,
            gSeries = gs[1],
            label = list(ADM1 = "REGC2023_V1_00_NAME"), # REGional Council
            archive = "statsnz-regional-council-2023-clipped-generalised-GPKG.zip|regional-council-2023-clipped-generalised.gpkg",
            archiveLink = "https://datafinder.stats.govt.nz/layer/111181-regional-council-2023-clipped-generalised/",
            updateFrequency = "annual",
            downloadDate = ymd("2019-10-10"),
            overwrite = TRUE)

regGeometry(ADM0 = !!thisNation,
            gSeries = gs[1],
            label = list(ADM2 = "TA2023_V1_00_NAME"), # Territorial Authority
            archive = "statsnz-territorial-authority-2023-clipped-generalised-GPKG.zip|territorial-authority-2023-clipped-generalised.gpkg",
            archiveLink = "https://datafinder.stats.govt.nz/layer/111204-statistical-area-3-2023-clipped-generalised/",
            updateFrequency = "annual",
            downloadDate = ymd("2019-10-10"),
            overwrite = TRUE)

normGeometry(pattern = gs[1],
             beep = 10)


# 3. tables ----
#
schema_nzstat_livestock <-
  setFormat(na_values = c("..", "..C", "..S", "-")) |>
  setIDVar(name = "ADM0", value = "New Zealand")

schema_nzstat_livestock_detailed <- schema_nzstat_livestock |>
  setFilter(rows = .find(is.na, col = 3, invert = TRUE)) |>
  setIDVar(name = "ADM2", columns = 1) |>
  setIDVar(name = "animal", columns = 2) |>
  setIDVar(name = "year", columns = .find(fun = is.numeric, row = 2), rows = 2) |>
  setObsVar(name = "number_heads", columns = .find(fun = is.numeric, row = 2), top = 3)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "detailedLivestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_nzstat_livestock_detailed,
         begin = 1990,
         end = 1996,
         archive = "AGR075601_20231109_055606_21.csv",
         archiveLink = "https://infoshare.stats.govt.nz/Default.aspx",
         updateFrequency = "unknown",
         downloadDate = ymd("2019-10-10"),
         metadataPath = "",
         metadataLink = "https://infoshare.stats.govt.nz/Default.aspx")

schema_nzstat_livestock_totals <- schema_nzstat_livestock |>
  setFilter(rows = .find(is.na, col = 3, invert = TRUE)) |>
  setIDVar(name = "ADM1", columns = 1) |>
  setIDVar(name = "animal", columns = 2) |>
  setIDVar(name = "year", columns = .find(fun = is.numeric, row = 2), rows = 2) |>
  setObsVar(name = "number_heads", columns = .find(fun = is.numeric, row = 2), top = 3)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "totalsLivestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_nzstat_livestock_totals,
         begin = 1990,
         end = 2022,
         archive = "AGR075701_20231109_055917_49.csv",
         archiveLink = "https://infoshare.stats.govt.nz/Default.aspx",
         updateFrequency = "unknown",
         downloadDate = ymd("2019-10-10"),
         metadataPath = "",
         metadataLink = "https://infoshare.stats.govt.nz/Default.aspx")

# # ignored because detailed classes are not needed for now and totals are with more time steps in the previous table
# regTable(ADM0 = !!thisNation,
#          label = "ADM1",
#          subset = "detailedLivestock",
#          dSeries = ds[1],
#          gSeries = gs[1],
#          schema = schema_default,
#          begin = 2002,
#          end = 2022,
#          archive = "Livestock Numbers by Regional Council.gz|TABLECODE7423_Data_997a98ba-6950-4239-8b95-a83665f3a589.csv",
#          archiveLink = "", # where this table can be found online
#          updateFrequency = "",
#          nextUpdate = "",
#          metadataPath = "",
#          metadataLink = "")

schema_nzstat_livestock_poultry <- schema_nzstat_livestock |>
  setFilter(rows = .find(is.na, col = 3, invert = TRUE)) |>
  setIDVar(name = "ADM2", columns = 1) |>
  setIDVar(name = "year", value = "2002") |>
  setIDVar(name = "animal", columns = c(3, 5, 7, 9), rows = 5) |>
  setObsVar(name = "number_heads", columns = c(3, 5, 7, 9), top = 8)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "poultry",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_nzstat_livestock_poultry,
         begin = 2001,
         end = 2002,
         archive = "Agricultural-Production-Statistics-key-tables-from-APS-2002-2017.zip|2-poultry-territorial.xls",
         archiveLink = "https://www.stats.govt.nz/assets/Uploads/Agricultural-production-statistics/Agricultural-Production-Statistics-key-tables-from-APS-2002-2017.zip",
         updateFrequency = "unknown",
         downloadDate = ymd("2019-10-10"),
         metadataPath = "",
         metadataLink = "https://www.stats.govt.nz/large-datasets/csv-files-for-download")

schema_nzstat_livestock_deer <- schema_nzstat_livestock |>
  setFilter(rows = .find(is.na, col = 3, invert = TRUE)) |>
  setIDVar(name = "ADM2", columns = 1) |>
  setIDVar(name = "year", value = "2002") |>
  setIDVar(name = "animal", columns = c(3, 5, 7, 9, 11), rows = 6) |>
  setObsVar(name = "number_heads", columns = c(3, 5, 7, 9, 11), top = 9)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "deer",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_nzstat_livestock_deer,
         begin = 2001,
         end = 2002,
         archive = "Agricultural-Production-Statistics-key-tables-from-APS-2002-2017.zip|4-deer-territorial.xls",
         archiveLink = "https://www.stats.govt.nz/assets/Uploads/Agricultural-production-statistics/Agricultural-Production-Statistics-key-tables-from-APS-2002-2017.zip",
         updateFrequency = "unknown",
         downloadDate = ymd("2019-10-10"),
         metadataPath = "",
         metadataLink = "https://www.stats.govt.nz/large-datasets/csv-files-for-download")

schema_nzstat_livestock_pigs <- schema_nzstat_livestock |>
  setFilter(rows = .find(is.na, col = 3, invert = TRUE)) |>
  setIDVar(name = "ADM2", columns = 1) |>
  setIDVar(name = "year", value = "2002") |>
  setIDVar(name = "animal", columns = c(3, 5, 7, 9), rows = 6) |>
  setObsVar(name = "number_heads", columns = c(3, 5, 7, 9), top = 8)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "pigs",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_nzstat_livestock_pigs,
         begin = 2001,
         end = 2002,
         archive = "Agricultural-Production-Statistics-key-tables-from-APS-2002-2017.zip|4-pigs-territorial.xls",
         archiveLink = "https://www.stats.govt.nz/assets/Uploads/Agricultural-production-statistics/Agricultural-Production-Statistics-key-tables-from-APS-2002-2017.zip",
         updateFrequency = "unknown",
         downloadDate = ymd("2019-10-10"),
         metadataPath = "",
         metadataLink = "https://www.stats.govt.nz/large-datasets/csv-files-for-download")

schema_nzstat_livestock_sheep <- schema_nzstat_livestock |>
  setFilter(rows = .find(is.na, col = 2, invert = TRUE)) |>
  setIDVar(name = "ADM2", columns = 1) |>
  setIDVar(name = "year", value = "2002") |>
  setIDVar(name = "animal", columns = c(2, 4, 6, 8, 10, 12, 14, 16, 18, 19), rows = 6) |>
  setObsVar(name = "number_heads", columns = c(2, 4, 6, 8, 10, 12, 14, 16, 18, 19), top = 8)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "sheep",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_nzstat_livestock_sheep,
         begin = 2001,
         end = 2002,
         archive = "Agricultural-Production-Statistics-key-tables-from-APS-2002-2017.zip|4-sheep-territorial.xls",
         archiveLink = "https://www.stats.govt.nz/assets/Uploads/Agricultural-production-statistics/Agricultural-Production-Statistics-key-tables-from-APS-2002-2017.zip",
         updateFrequency = "unknown",
         downloadDate = ymd("2019-10-10"),
         metadataPath = "",
         metadataLink = "https://www.stats.govt.nz/large-datasets/csv-files-for-download")

schema_nzstat_livestock_cattleBeef <- schema_nzstat_livestock |>
  setFilter(rows = .find(is.na, col = 2, invert = TRUE)) |>
  setIDVar(name = "ADM2", columns = 1) |>
  setIDVar(name = "year", value = "2002") |>
  setIDVar(name = "animal", columns = c(2, 4, 6, 8, 9, 10, 11, 13, 14, 16, 18, 19, 21), rows = 6) |>
  setObsVar(name = "number_heads", columns = c(2, 4, 6, 8, 9, 10, 11, 13, 14, 16, 18, 19, 21), top = 8)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "cattleBeef",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_nzstat_livestock_cattleBeef,
         begin = 2001,
         end = 2002,
         archive = "Agricultural-Production-Statistics-key-tables-from-APS-2002-2017.zip|5-beef-territorial.xls",
         archiveLink = "https://www.stats.govt.nz/assets/Uploads/Agricultural-production-statistics/Agricultural-Production-Statistics-key-tables-from-APS-2002-2017.zip",
         updateFrequency = "unknown",
         downloadDate = ymd("2019-10-10"),
         metadataPath = "",
         metadataLink = "https://www.stats.govt.nz/large-datasets/csv-files-for-download")

schema_nzstat_livestock_cattleDairy <- schema_nzstat_livestock |>
  setFilter(rows = .find(is.na, col = 3, invert = TRUE)) |>
  setIDVar(name = "ADM2", columns = 1) |>
  setIDVar(name = "year", value = "2002") |>
  setIDVar(name = "animal", columns = c(3, 5, 7, 9, 11, 13), rows = 7) |>
  setObsVar(name = "number_heads", columns = c(3, 5, 7, 9, 11, 13), top = 9)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "cattleDairy",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_nzstat_livestock_cattleDairy,
         begin = 2001,
         end = 2002,
         archive = "Agricultural-Production-Statistics-key-tables-from-APS-2002-2017.zip|5-dairy-territorial.xls",
         archiveLink = "https://www.stats.govt.nz/assets/Uploads/Agricultural-production-statistics/Agricultural-Production-Statistics-key-tables-from-APS-2002-2017.zip",
         updateFrequency = "unknown",
         downloadDate = ymd("2019-10-10"),
         metadataPath = "",
         metadataLink = "https://www.stats.govt.nz/large-datasets/csv-files-for-download")

normTable(pattern = ds[1],
          ontoMatch = "animal",
          beep = 10)
