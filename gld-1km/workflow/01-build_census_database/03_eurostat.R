# ----
# title       : build census database - eurostat, nuts
# description : this script integrates data of 'Statistical office of the European Union' (https://ec.europa.eu/eurostat/web/main/home), 'Nomenclature des unités territoriales statistiques' (https://ec.europa.eu/eurostat/web/nuts/background)
# license     : https://creativecommons.org/licenses/by-sa/4.0/
# authors     : Steffen Ehrmann
# date        : 2025-01-31
# version     : 0.8.0
# status      : finished
# notes       :
# ----
# geography   : Europe
# spatial     : NUTS0, NUTS1, NUTS2, NUTS3
# period      : 1975 - 2022
# sampling    : survey, census
# comment     : https://ec.europa.eu/eurostat/documents/3859598/15193590/KS-GQ-22-010-EN-N.pdf
# ----

thisNation <- "Europe"
# source(paste0(db_path, "preprocess_eurostat.R"))
#
# any data about horses? also in the US
# how about zeros? Where are they, do my schemas capture them correctly?

# flag information: https://ec.europa.eu/eurostat/data/database/information
flags <- tibble(flag = c("b", "c", "d", "e", "f", "n", "p", "r", "s", "u", "z"),
                value = c("break in time series", "confidential",
                          "definition differs, see metadata", "estimated",
                          "forecast", "not significatn", "provisional",
                          "revised", "Eurostat estimate", "low reliability",
                          "not applicable"))


# 1. dataseries ----
#
ds <- c("eurostat")
gs <- c("nuts")

regDataseries(name = ds[1],
              description = "Statistical office of the European Union",
              homepage = "https://ec.europa.eu/eurostat/web/main/home",
              version = "2023.12.12",
              licence_link = "unknown")

regDataseries(name = gs[1],
              description = "Nomenclature des unités territoriales statistiques",
              homepage = "https://ec.europa.eu/eurostat/web/nuts/background",
              version = "2021",
              licence_link = "https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units/nuts")


# 2. geometries ----
#
regGeometry(gSeries = gs[1],
            label = list(ADM0 = "CNTR_CODE"),
            ancillary = list(name_ltn = "NAME_LATN", name_lcl = "NUTS_NAME"),
            archive = "ref-nuts-2021-01m.shp.zip|NUTS_RG_01M_2021_3035_LEVL_0.shp",
            archiveLink = "https://gisco-services.ec.europa.eu/distribution/v2/nuts/download/ref-nuts-2021-01m.shp.zip",
            downloadDate = ymd("2023-11-29"),
            updateFrequency = "unknown",
            overwrite = TRUE)

regGeometry(gSeries = gs[1],
            label = list(ADM0 = "CNTR_CODE", ADM1 = "NUTS_ID"),
            ancillary = list(name_ltn = "NAME_LATN", name_lcl = "NUTS_NAME"),
            archive = "ref-nuts-2021-01m.shp.zip|NUTS_RG_01M_2021_3035_LEVL_1.shp",
            archiveLink = "https://gisco-services.ec.europa.eu/distribution/v2/nuts/download/ref-nuts-2021-01m.shp.zip",
            downloadDate = ymd("2023-11-29"),
            updateFrequency = "unknown",
            overwrite = TRUE)

regGeometry(gSeries = gs[1],
            label = list(ADM0 = "CNTR_CODE", ADM2 = "NUTS_ID"),
            ancillary = list(name_ltn = "NAME_LATN", name_lcl = "NUTS_NAME"),
            archive = "ref-nuts-2021-01m.shp.zip|NUTS_RG_01M_2021_3035_LEVL_2.shp",
            archiveLink = "https://gisco-services.ec.europa.eu/distribution/v2/nuts/download/ref-nuts-2021-01m.shp.zip",
            downloadDate = ymd("2023-11-29"),
            updateFrequency = "unknown",
            overwrite = TRUE)

regGeometry(gSeries = gs[1],
            label = list(ADM0 = "CNTR_CODE", ADM3 = "NUTS_ID"),
            ancillary = list(name_ltn = "NAME_LATN", name_lcl = "NUTS_NAME"),
            archive = "ref-nuts-2021-01m.shp.zip|NUTS_RG_01M_2021_3035_LEVL_3.shp",
            archiveLink = "https://gisco-services.ec.europa.eu/distribution/v2/nuts/download/ref-nuts-2021-01m.shp.zip",
            downloadDate = ymd("2023-11-29"),
            updateFrequency = "unknown",
            overwrite = TRUE)

normGeometry(pattern = gs[1],
             # query = "where CNTR_CODE = 'DE'",
             beep = 10)


# 3. tables ----
#
schema_eurostat <-
  setFormat(na_values = ":", flags = flags, decimal = ".") |>
  setIDVar(name = "year", columns = .find(fun = is.numeric, row = 1), rows = 1)

schema_ADM0 <- schema_eurostat |>
  setIDVar(name = "ADM0", columns = .find(pattern = "^geo", row = 1))

schema_ADM1 <- schema_eurostat |>
  setIDVar(name = "ADM0", columns = .find(pattern = "^geo$", row = 1), split = "(.{2})") |>
  setIDVar(name = "ADM1", columns = .find(pattern = "^geo", row = 1), split = "(.{3})")

schema_ADM2 <- schema_eurostat |>
  setIDVar(name = "ADM0", columns = .find(pattern = "^geo$", row = 1), split = "(.{2})") |>
  setIDVar(name = "ADM1", columns = .find(pattern = "^geo$", row = 1), split = "(.{3})") |>
  setIDVar(name = "ADM2", columns = .find(pattern = "^geo", row = 1))

## Animal populations (agr_r_animal) ----
schema_agrranimal <- schema_ADM2 |>
  setIDVar(name = "method", value = "survey") |>
  setIDVar(name = "animal", columns = 2) |>
  setObsVar(name = "number_heads", factor = 1000, columns = .find(fun = is.numeric, row = 1))

regTable(un_region = thisNation,
         label = "ADM2",
         subset = "agrranimal",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_agrranimal,
         begin = 1977,
         end = 2023,
         archive = "agr_r_animal.tsv.gz",
         archiveLink = "https://ec.europa.eu/eurostat/databrowser/view/agr_r_animal/",
         updateFrequency = "annually",
         downloadDate = ymd("2024-07-29"),
         metadataLink = "https://ec.europa.eu/eurostat/cache/metadata/en/apro_anip_esms.htm",
         metadataPath = "unknown",
         overwrite = TRUE)

# as some nations don't have recent data at level 3 (looking at you, Germany!), also read in level 2 data
schema_agrranimADM1 <- schema_ADM1 |>
  setIDVar(name = "method", value = "survey") |>
  setIDVar(name = "animal", columns = 2) |>
  setObsVar(name = "number_heads", factor = 1000, columns = .find(fun = is.numeric, row = 1))

regTable(un_region = thisNation,
         label = "ADM1",
         subset = "agrranimal",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_agrranimADM1,
         begin = 1977,
         end = 2023,
         archive = "agr_r_animal.tsv.gz",
         archiveLink = "https://ec.europa.eu/eurostat/databrowser/view/agr_r_animal/",
         updateFrequency = "annually",
         downloadDate = ymd("2024-07-29"),
         metadataLink = "https://ec.europa.eu/eurostat/cache/metadata/en/apro_anip_esms.htm",
         metadataPath = "unknown",
         overwrite = TRUE)

# ignore files for some southern and eastern neighbours because they are also covered by FAOstat
# - ENP-South Livestock: https://ec.europa.eu/eurostat/databrowser/view/enps_apro_mt_ls/
# - ENP-South Livestock - historical data: https://ec.europa.eu/eurostat/databrowser/view/med_ag33/
# - ENP-South Poultry farming - historical data: https://ec.europa.eu/eurostat/databrowser/view/med_ag34/
# - ENP-East Livestock: https://ec.europa.eu/eurostat/databrowser/view/enpe_apro_mt_ls/

normTable(pattern = paste0("agrranimal.*", ds[1]),
          ontoMatch = "animal",
          # query = "ADM0 == 'DK'",
          beep = 10)
