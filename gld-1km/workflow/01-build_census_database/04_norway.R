# ----
# title       : build census database - ssbno
# description : this script integrates data of 'Statistics Norway' (https://www.ssb.no/en/, https://www.ssb.no/en/statbank/list/stjord)
# license     : https://creativecommons.org/licenses/by-sa/4.0/
# authors     : Steffen Ehrmann
# date        : 2025-01-31
# version     : 0.3.0
# status      : work in progress [30%]
# notes       :
# ----
# geography   : Norway
# spatial     : ADM1, ADM2
# period      : 1969 - 2023
# sampling    : survey, census
# comment     : -
# ----

thisNation <- "Norway"

# 1. dataseries ----
#
ds <- c("ssbno")
gs <- c("ssbno")

regDataseries(name = ds[1],
              description = "Statistics Norway",
              homepage = "https://www.ssb.no/en/",
              version = "2024.09",
              licence_link = licenses$by4)


# 2. geometries ----
#
regGeometry(ADM0 = !!thisNation,
            gSeries = gs[1],
            label = list(ADM1 = "fylkesnavn"),
            archive = "45ce04cf-b10b-4277-a64f-2a2d14e886c1.zip|fylke.shp",
            archiveLink = "https://kart.ssb.no/",
            downloadDate = ymd("2024-07-22"),
            updateFrequency = "unknown")

regGeometry(ADM0 = !!thisNation,
            gSeries = gs[1],
            label = list(ADM2 = "kommunenav"),
            archive = "45ce04cf-b10b-4277-a64f-2a2d14e886c1.zip|kommune.shp",
            archiveLink = "https://kart.ssb.no/",
            downloadDate = ymd("2024-07-22"),
            updateFrequency = "unknown")

normGeometry(pattern = gs[1],
             beep = 10)


# 3. tables ----
#
schema_livestock_ssbno1 <-
  setIDVar(name = "ADM0", value = "Norway") |>
  setIDVar(name = "ADM1", columns = 2) |>
  setIDVar(name = "year", columns = .find(fun = is.numeric, row = 3), rows = 3) |>
  setIDVar(name = "method", value = "survey") |>
  setIDVar(name = "animal", columns = 3)  |>
  setObsVar(name = "number_heads", columns = .find(fun = is.numeric, row = 3), top = 3)

### detailed species ----
regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "surveySpecies",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ssbno1,
         begin = 1969,
         end = 2023,
         archive = "11507_20240722-204729.xlsx",
         archiveLink = "https://www.ssb.no/en/statbank/table/11507/tableViewLayout1/",
         downloadDate = ymd("2025-01-16"),
         updateFrequency = "annually",
         metadataLink = "https://www.ssb.no/en/statbank/table/11507",
         metadataPath = "unknown",
         overwrite = TRUE)

### detailed admin units ----
schema_livestock_ssbno2 <-
  setIDVar(name = "ADM0", value = "Norway") |>
  setIDVar(name = "ADM2", columns = 3) |>
  setIDVar(name = "year", columns = .find(fun = is.numeric, row = 3), rows = 3) |>
  setIDVar(name = "method", value = "survey") |>
  setIDVar(name = "animal", columns = 4)  |>
  setObsVar(name = "number_heads", columns = .find(fun = is.numeric, row = 3), top = 3)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "surveyAdmin",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ssbno2,
         begin = 1969,
         end = 2023,
         archive = "06447_20240722-204649.xlsx",
         archiveLink = "https://www.ssb.no/en/statbank/table/06447/tableViewLayout1/",
         downloadDate = ymd("2025-01-16"),
         updateFrequency = "annually",
         metadataLink = "https://www.ssb.no/en/statbank/table/06447",
         metadataPath = "unkown",
         overwrite = TRUE)

normTable(pattern = ds[1],
          ontoMatch = "animal",
          beep = 10)
