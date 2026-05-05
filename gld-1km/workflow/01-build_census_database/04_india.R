# ----
# title       : build census database - indis, mospi
# description : this script integrates data of 'Ministry of statistic and program implementation, government of India' (http://mospi.nic.in/), 'Indiastat Districts' (https://www.indiastatdistricts.com/)
# license     : https://creativecommons.org/licenses/by-sa/4.0/
# authors     : Steffen Ehrmann
# date        : 2025-01-31
# version     : 0.6.0
# status      : work in process [60%]
# notes       :
# ----
# geography   : India
# spatial     : ADM0, ADM1, ADM2
# period      : 2003, 2007, 2012, 2019
# sampling    : survey, census
# comment     : data purchased by Carsten Meyer, not publicly available
# ----

# script arguments ----
#
thisNation <- "India"


# 1. dataseries ----
#
ds <- c("mospi", "indis")
gs <- c("gadm")

regDataseries(name = ds[1],
              description = "Ministry of statistic and program implementation, government of India",
              homepage = "http://mospi.nic.in/",
              version = "2024.01",
              licence_link = "unknown")

regDataseries(name = ds[2],
              description = "Indiastat Districts",
              homepage = "https://www.indiastatdistricts.com/",
              version = "2024.01",
              licence_link = "unknown")


# 2. geometries ----
#


# 3. tables ----
#
schema_livestock_indis2003 <-
  setFilter(rows = 1, invert = TRUE) |>
  setGroups(rows = .sum(c(2:6), fill = c("down", "right"), character = ~ paste0(unique(na.omit(.x)), collapse = "--"))) |>
  setIDVar(name = "ADM1", columns = 1) |>
  setIDVar(name = "ADM2", columns = 2) |>
  setIDVar(name = "year", value = "2003") |>
  setIDVar(name = "method", value = "census") |>
  setIDVar(name = "animal", columns = .find(is.numeric, row = 7), rows = 5) |>
  setObsVar(name = "number_heads", columns = .find(is.numeric, row = 7), top = 6, key = 3, value = "Total")

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "livestockCensus",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_indis2003,
         begin = 2003,
         end = 2003,
         archive = "Agriculture_Requirement_Time_Series_data.rar|District-wise Agriculture_Requirement_Time Series_Data.xlsx",
         archiveLink = "individual_url",
         downloadDate = ymd("2022-11-16"),
         updateFrequency = "annually",
         metadataLink = "missing",
         metadataPath = "unavailable",
         overwrite = TRUE)

schema_livestock_indis2007 <-
  setCluster(id = "ADM1", left = 1, top = .find(fun = is.na, col = c(2:10))) %>%
  setFilter(rows = c(1, 8:115), invert = TRUE) |>
  setGroups(rows = .sum(c(2:7), fill = c("down", "right"), character = ~ paste0(unique(na.omit(.x)), collapse = "--"))) |>
  setIDVar(name = "ADM1", columns = 1, rows = .find(fun = is.na, col = c(2:10))) |>
  setIDVar(name = "ADM2", columns = 1) |>
  setIDVar(name = "year", value = "2007") |>
  setIDVar(name = "method", value = "census") |>
  setIDVar(name = "animal", columns = .find(is.numeric, row = 8), rows = 6) |>
  setObsVar(name = "number_heads", columns = .find(is.numeric, row = 8), top = 7, key = 2, value = "Total")

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "livestockCensus",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_indis2007,
         begin = 2007,
         end = 2007,
         archive = "Agriculture_Requirement_Time_Series_data.rar|District-wise Agriculture_Requirement_Time Series_Data.xlsx",
         archiveLink = "individual_url",
         downloadDate = ymd("2022-11-16"),
         updateFrequency = "annually",
         metadataLink = "missing",
         metadataPath = "unavailable",
         overwrite = TRUE)


schema_livestock_indis2012 <-
  setFilter(rows = c(1, 7:114), invert = TRUE) |>
  setGroups(rows = .sum(c(2:6), fill = c("down", "right"), character = ~ paste0(unique(na.omit(.x)), collapse = "--"))) |>
  setIDVar(name = "ADM1", columns = 1) |>
  setIDVar(name = "ADM2", columns = 2) |>
  setIDVar(name = "year", value = "2012") |>
  setIDVar(name = "method", value = "census") |>
  setIDVar(name = "animal", columns = .find(is.numeric, row = 9), rows = 5) |>
  setObsVar(name = "number_heads", columns = .find(is.numeric, row = 9), top = 6, key = 3, value = "Total")

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "livestockCensus",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_indis2012,
         begin = 2012,
         end = 2012,
         archive = "Agriculture_Requirement_Time_Series_data.rar|District-wise Agriculture_Requirement_Time Series_Data.xlsx",
         archiveLink = "individual_url",
         downloadDate = ymd("2022-11-16"),
         updateFrequency = "annually",
         metadataLink = "missing",
         metadataPath = "unavailable",
         overwrite = TRUE)

schema_livestock_indis2019 <-
  setFilter(rows = c(1, 5:41), invert = TRUE) |>
  setGroups(rows = .sum(c(2:4), fill = c("down", "right"), character = ~ paste0(unique(na.omit(.x)), collapse = "--"))) |>
  setIDVar(name = "ADM1", columns = 1) |>
  setIDVar(name = "ADM2", columns = 2) |>
  setIDVar(name = "year", value = "2019") |>
  setIDVar(name = "method", value = "census") |>
  setIDVar(name = "animal", columns = .find(is.numeric, row = 9), rows = 3) |>
  setObsVar(name = "number_heads", columns = .find(is.numeric, row = 9), top = 4)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "livestockCensus",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_indis2019,
         begin = 2019,
         end = 2019,
         archive = "Agriculture_Requirement_Time_Series_data.rar|District-wise Agriculture_Requirement_Time Series_Data.xlsx",
         archiveLink = "individual_url",
         downloadDate = ymd("2022-11-16"),
         updateFrequency = "annually",
         metadataLink = "missing",
         metadataPath = "unavailable",
         overwrite = TRUE)

# regTable(ADM0 = !!thisNation,
#          label = "ADM2",
#          subset = "poultryCensus",
#          dSeries = ds[2],
#          gSeries = gs[1],
#          schema = schema_livestock_indis,
#          begin = 2007,
#          end = 2007,
#          archive = "Agriculture_Requirement_Time_Series_data.rar|District-wise Agriculture_Requirement_Time Series_Data.xlsx",
#          archiveLink = "individual_url",
#          downloadDate = ymd("2022-11-16"),
#          updateFrequency = "annually",
#          metadataLink = "missing",
#          metadataPath = "unavailable",
#          overwrite = TRUE)
#
# regTable(ADM0 = !!thisNation,
#          label = "ADM2",
#          subset = "poultryCensus",
#          dSeries = ds[2],
#          gSeries = gs[1],
#          schema = schema_livestock_indis,
#          begin = 2012,
#          end = 2012,
#          archive = "Agriculture_Requirement_Time_Series_data.rar|District-wise Agriculture_Requirement_Time Series_Data.xlsx",
#          archiveLink = "individual_url",
#          downloadDate = ymd("2022-11-16"),
#          updateFrequency = "annually",
#          metadataLink = "missing",
#          metadataPath = "unavailable",
#          overwrite = TRUE)

normTable(pattern = paste0("livestock.*", ds[2]),
          ontoMatch = "animal",
          beep = 10)
