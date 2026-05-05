# ----
# title       : build census database - bps
# description : this script integrates data of 'Badan Pusat Statistik' (https://www.bps.go.id)
# license     : https://creativecommons.org/licenses/by-sa/4.0/
# authors     : Steffen Ehrmann
# date        : 2025-01-31
# version     : 0.0.3
# status      : work in progress [30%]
# notes       :
# ----
# geography   : Indonesia
# spatial     : ADM0, ADM1, (ADM2)
# period      : 2000 - 2022
# sampling    : survey
# comment     : level 4 data available at province-level websites (very hard to get, need to click through each website and download manually)
# ----

thisNation <- "Indonesia"
# source(paste0(db_path, "preprocess_bps.R"))

# 1. dataseries ----
#
ds <- c("bps")
gs <- c("gadm", "bps")

regDataseries(name = ds[1],
              description = "Badan Pusat Statistik",
              homepage = "https://www.bps.go.id",
              licence_link = "https://www.bps.go.id/website/fileMenu/law16_97_eng.pdf",
              version = "2024.07",
              notes = "metadata namely concept and methodology is downloaded from mainpage but apply for all sub-websites")


# 2. register geometries ----
#
regGeometry(ADM0 = !!thisNation,
            gSeries = gs[2],
            label = list(ADM0 = "ADM0_EN"),
            archive = "idn_adm_bps_20200401_shp.zip|idn_admbnda_adm0_bps_20200401.shp",
            archiveLink = "https://data.amerigeoss.org/ro/dataset/indonesia-central-sulawesi-administrative-boundary-polygons-levels-1-4",
            updateFrequency = "notplanned",
            downloadDate = ymd("2022-03-14"),
            overwrite = TRUE)

regGeometry(ADM0 = !!thisNation,
            gSeries = gs[2],
            label = list(ADM0 = "ADM0_EN", ADM1 = "ADM1_EN"),
            archive = "idn_adm_bps_20200401_shp.zip|idn_admbnda_adm1_bps_20200401.shp",
            archiveLink = "https://data.amerigeoss.org/ro/dataset/indonesia-central-sulawesi-administrative-boundary-polygons-levels-1-4",
            updateFrequency = "notplanned",
            downloadDate = ymd("2022-03-14"),
            overwrite = TRUE)

regGeometry(ADM0 = !!thisNation,
            gSeries = gs[2],
            label = list(ADM0 = "ADM0_EN", ADM1 = "ADM1_EN", ADM2 = "ADM2_EN"),
            archive = "idn_adm_bps_20200401_shp.zip|idn_admbnda_adm2_bps_20200401.shp",
            archiveLink = "https://data.amerigeoss.org/ro/dataset/indonesia-central-sulawesi-administrative-boundary-polygons-levels-1-4",
            updateFrequency = "notplanned",
            downloadDate = ymd("2022-03-14"),
            overwrite = TRUE)

# regGeometry(ADM0 = !!thisNation,
#             gSeries = gs[2],
#             label = list(ADM0 = "ADM0_EN", ADM1 = "ADM1_EN", ADM2 = "ADM2_EN", ADM3 = "ADM3_EN"),
#             archive = "idn_adm_bps_20200401_shp.zip|idn_admbnda_adm3_bps_20200401.shp",
#             archiveLink = "https://data.amerigeoss.org/ro/dataset/indonesia-central-sulawesi-administrative-boundary-polygons-levels-1-4",
#             updateFrequency = "notplanned",
#             downloadDate = ymd("2022-03-14"),
#             overwrite = TRUE)

normGeometry(pattern = paste0(thisNation, ".*", gs[2]),
             beep = 10)

# 3. register census tables ----
#
schema_livestock_bps_ADM1 <-
  setFormat(na_values = "-", decimal = ",") |>
  setFilter(rows = 1, invert = TRUE) |>
  setIDVar(name = "ADM1", columns = 1) |>
  setIDVar(name = "year", columns = .find(fun = is.numeric, row = 2), rows = 2) |>
  setIDVar(name = "method", value = "survey") |>
  setIDVar(name = "animal", columns = 2, rows = 1, distinct = TRUE)  |>
  setObsVar(name = "number_heads", columns = .find(fun = is.numeric, row = 2), top = 3)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "buffalo",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_bps_ADM1,
         begin = 2000,
         end = 2022,
         archive = "buffalo_headcount_province_2000-2022.csv",
         archiveLink = "https://www.bps.go.id/en/statistics-table/2/NDcxIzI=/buffalo-population-by-province--heads-.html",
         downloadDate = ymd("2024-07-26"),
         updateFrequency = "annual",
         metadataLink = "https://www.bps.go.id/en/statistics-table?subject=557",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "cattleBeef",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_bps_ADM1,
         begin = 2000,
         end = 2022,
         archive = "cattle_beef_headcount_province_2000-2022.csv",
         archiveLink = "https://www.bps.go.id/en/statistics-table/2/NDY5IzI=/beef-cattle-population-by-province--heads-.html",
         downloadDate = ymd("2024-07-26"),
         updateFrequency = "annual",
         metadataLink = "https://www.bps.go.id/en/statistics-table?subject=557",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "cattleDairy",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_bps_ADM1,
         begin = 2000,
         end = 2022,
         archive = "cattle_dairy_headcount_province_2000-2022.csv",
         archiveLink = "https://www.bps.go.id/en/statistics-table/2/NDcwIzI=/dairy-cattle-population-by-provinsi--heads-.html",
         downloadDate = ymd("2024-07-26"),
         updateFrequency = "annual",
         metadataLink = "https://www.bps.go.id/en/statistics-table?subject=557",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "chickenBroiler",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_bps_ADM1,
         begin = 2000,
         end = 2022,
         archive = "chicken_broiler_headcount_province_2000-2022.csv",
         archiveLink = "https://www.bps.go.id/en/statistics-table/2/NDc4IzI=/broiler-population-by-province--heads-.html",
         downloadDate = ymd("2024-07-26"),
         updateFrequency = "annual",
         metadataLink = "https://www.bps.go.id/en/statistics-table?subject=557",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "chickenLayer",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_bps_ADM1,
         begin = 2000,
         end = 2022,
         archive = "chicken_layer_headcount_province_2000-2022.csv",
         archiveLink = "https://www.bps.go.id/en/statistics-table/2/NDc2IzI=/native-chicken-population-by-province--heads-.html",
         downloadDate = ymd("2024-07-26"),
         updateFrequency = "annual",
         metadataLink = "https://www.bps.go.id/en/statistics-table?subject=557",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "chickenNative",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_bps_ADM1,
         begin = 2000,
         end = 2022,
         archive = "chicken_native_headcount_province_2000-2022.csv",
         archiveLink = "https://www.bps.go.id/en/statistics-table/2/NDc2IzI=/native-chicken-population-by-province--heads-.html",
         downloadDate = ymd("2024-07-26"),
         updateFrequency = "annual",
         metadataLink = "https://www.bps.go.id/en/statistics-table?subject=557",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "duck",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_bps_ADM1,
         begin = 2000,
         end = 2022,
         archive = "duck_headcount_province_2000-2022.csv",
         archiveLink = "https://www.bps.go.id/en/statistics-table/2/NDc5IzI=/duck-muscovy-duck-population-by-province--heads-.html",
         downloadDate = ymd("2024-07-26"),
         updateFrequency = "annual",
         metadataLink = "https://www.bps.go.id/en/statistics-table?subject=557",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "goat",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_bps_ADM1,
         begin = 2000,
         end = 2022,
         archive = "goat_headcount_province_2000-2022.csv",
         archiveLink = "https://www.bps.go.id/en/statistics-table/2/NDcyIzI=/goat-population-by-province--heads-.html",
         downloadDate = ymd("2024-07-26"),
         updateFrequency = "annual",
         metadataLink = "https://www.bps.go.id/en/statistics-table?subject=557",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "horse",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_bps_ADM1,
         begin = 2000,
         end = 2022,
         archive = "horse_headcount_province_2000-2022.csv",
         archiveLink = "https://www.bps.go.id/en/statistics-table/2/NDc1IzI=/horse-population-by-province--heads-.html",
         downloadDate = ymd("2024-07-26"),
         updateFrequency = "annual",
         metadataLink = "https://www.bps.go.id/en/statistics-table?subject=557",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "pig",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_bps_ADM1,
         begin = 2000,
         end = 2022,
         archive = "pig_headcount_province_2000-2022.csv",
         archiveLink = "https://www.bps.go.id/en/statistics-table/2/NDc0IzI=/pig-population-by-province--heads-.html",
         downloadDate = ymd("2024-07-26"),
         updateFrequency = "annual",
         metadataLink = "https://www.bps.go.id/en/statistics-table?subject=557",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "sheep",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_bps_ADM1,
         begin = 2000,
         end = 2022,
         archive = "sheep_headcount_province_2000-2022.csv",
         archiveLink = "https://www.bps.go.id/en/statistics-table/2/NDczIzI=/sheep-population-by-province--heads-.html",
         downloadDate = ymd("2024-07-26"),
         updateFrequency = "annual",
         metadataLink = "https://www.bps.go.id/en/statistics-table?subject=557",
         metadataPath = "unknown",
         overwrite = TRUE)

normTable(pattern = ds[1],
          ontoMatch = "animal",
          beep = 10)
