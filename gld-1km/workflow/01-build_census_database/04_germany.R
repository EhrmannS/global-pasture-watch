# ----
# title       : build census database - genesis
# description : this script integrates data of 'Regionaldatenbank Deutschland' (https://www.regionalstatistik.de/genesis/online)
# license     : https://creativecommons.org/licenses/by-sa/4.0/
# authors     : Steffen Ehrmann
# date        : 2025-01-31
# version     : 0.0.1
# status      : work in progress
# notes       :
# ----
# geography   : Germany
# spatial     : ADM0, ADM1, ADM2
# period      : _INSERT
# sampling    : census
# comment     : -
# ----

thisNation <- "Germany"
# source(paste0(db_path, "preprocess_genesis.R"))

# 1. dataseries ----
#
ds <- c("genesis")
gs <- c("gadm")

regDataseries(name = ds[1],
              description = "Regionaldatenbank Deutschland",
              homepage = "https://www.regionalstatistik.de/genesis/online",
              version = "2024.07",
              licence_link = "https://www.govdata.de/dl-de/by-2-0")


# 2. geometries ----
#


# 3. tables ----
#
schema_livestock_genesis <-
  setFilter(rows = 1:6, invert = TRUE) |>
  setIDVar(name = "ADM0", value = "Germany") |>
  setIDVar(name = "ADM1", columns = 4) |>
  setIDVar(name = "ADM2", columns = 5) |>
  setIDVar(name = "year", columns = 1) |>
  setIDVar(name = "method", value = "census") |>
  setIDVar(name = "animal", columns = .find(fun = is.na, row = 7, invert = TRUE), rows = 7) |>
  setObsVar(name = "number_heads", columns = .find(fun = is.na, row = 7, invert = TRUE), top = 8)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "livestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_genesis,
         begin = 1999,
         end = 2007,
         archive = "41120-12-01-4.csv",
         archiveLink = "https://www.regionalstatistik.de/genesis//online?operation=table&code=41120-12-01-4",
         downloadDate = ymd("2024-07-30"),
         updateFrequency = "annually",
         metadataPath = "",
         metadataLink = "https://www.regionalstatistik.de/genesis/online?operation=statistic&levelindex=0&levelid=1722440782412&code=41312",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "livestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_genesis,
         begin = 2010,
         end = 2010,
         archive = "41141-03-02-4_2010.csv",
         archiveLink = "https://www.regionalstatistik.de/genesis//online?operation=table&code=41141-03-02-4",
         downloadDate = ymd("2024-07-30"),
         updateFrequency = "annually",
         metadataPath = "",
         metadataLink = "https://www.regionalstatistik.de/genesis/online?operation=statistic&levelindex=0&levelid=1722440782412&code=41312",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "livestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_genesis,
         begin = 2016,
         end = 2016,
         archive = "41141-03-02-4_2016.csv",
         archiveLink = "https://www.regionalstatistik.de/genesis//online?operation=table&code=41141-03-02-4",
         downloadDate = ymd("2024-07-30"),
         updateFrequency = "annually",
         metadataPath = "",
         metadataLink = "https://www.regionalstatistik.de/genesis/online?operation=statistic&levelindex=0&levelid=1722440782412&code=41312",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "livestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_genesis,
         begin = 2020,
         end = 2020,
         archive = "41141-03-02-4_2020.csv",
         archiveLink = "https://www.regionalstatistik.de/genesis//online?operation=table&code=41141-03-02-4",
         downloadDate = ymd("2024-07-30"),
         updateFrequency = "annually",
         metadataPath = "",
         metadataLink = "https://www.regionalstatistik.de/genesis/online?operation=statistic&levelindex=0&levelid=1722440782412&code=41312",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "cattle",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_genesis,
         begin = 2009,
         end = 2023,
         archive = "41312-01-01-4.csv",
         archiveLink = "https://www.regionalstatistik.de/genesis//online?operation=table&code=41312-01-01-4",
         downloadDate = ymd("2024-07-30"),
         updateFrequency = "annuallyly",
         metadataPath = "",
         metadataLink = "https://www.regionalstatistik.de/genesis/online?operation=statistic&levelindex=0&levelid=1722440782412&code=41312",
         overwrite = TRUE)

normTable(pattern = ds[1],
          ontoMatch = "animal",
          beep = 10)
