# ----
# title       : build census database - faostat
# description : this script integrates data of 'FAO statistical data' (http://www.fao.org/faostat/en/)
# license     : https://creativecommons.org/licenses/by-sa/4.0/
# authors     : Steffen Ehrmann
# date        : 2025-01-31
# version     : 1.0.0
# status      : finished
# notes       :
# ----
# geography   : Global
# spatial     : ADM0
# period      : 1961 - 2022
# sampling    : survey, census
# comment     : -
# ----

thisNation <- "global"

ds <- c("faostat")
gs <- c("gadm")

# 1. dataseries ----
#
regDataseries(name         = ds[1],
              description  = "FAO statistical data",
              homepage     = "http://www.fao.org/faostat/en/",
              version      = "2024.06",
              licence_link = "unknown")


# 2. geometries ----
#
regDataseries(name         = gs[1],
              description  = "Database of Global Administrative Areas",
              homepage     = "https://gadm.org/index.html",
              version      = "4.1",
              licence_link = "https://gadm.org/license.html")

regGeometry(gSeries         = gs[1],
            label           = list(ADM0 = "COUNTRY"),
            ancillary       = list(code = "GID_0"),
            layer           = "ADM_0",
            archive         = "gadm_410-levels.gpkg.zip|gadm_410-levels.gpkg",
            archiveLink     = "https://geodata.ucdavis.edu/gadm/gadm4.1/gadm_410-levels.gpkg.zip",
            downloadDate    = ymd("2024-06-03"),
            updateFrequency = "asNeeded")

normGeometry(pattern = gs[1],
             beep    = 10)


## livestock ----

### number heads ----
schema_faostat1 <-
  setIDVar(name = "ADM0", columns = 3) %>%
  setIDVar(name = "year", columns = 10) %>%
  setIDVar(name = "method", value = "survey, yearbook [1]") %>%
  setIDVar(name = "animal", columns = 6) %>%
  setObsVar(name = "number_heads", columns = 12) # this needs a fix in 'factor' for chicken/ducks

regTable(label = "ADM0",
         subset = "livestock",
         dSeries = ds[1],
         gSeries = gs[1],
         begin = 1961,
         end = 2022,
         schema = schema_faostat1,
         archive = "Production_Crops_Livestock_E_All_Data_(Normalized).zip|Production_Crops_Livestock_E_All_Data_(Normalized).csv",
         archiveLink = "https://bulks-faostat.fao.org/production/Production_Crops_Livestock_E_All_Data_(Normalized).zip",
         downloadDate = ymd("2024-06-03"),
         updateFrequency = "annually",
         metadataLink = "https://www.fao.org/faostat/en/#data/QCL/metadata",
         metadataPath = "meta_faostat_1",
         overwrite = TRUE)

normTable(pattern = paste0("livestock.*", ds[1]),
          # query = "ADM0 %in% 'Chile'",
          ontoMatch = "animal",
          beep = 10)
