# ----
# title       : build census database - rosstat
# description : this script integrates data of the Russian National Statistics Agency (www.fedstat.ru)
# license     : https://creativecommons.org/licenses/by-sa/4.0/
# authors     : Steffen Ehrmann
# date        : 2025-01-31
# version     : 0.7.0
# status      : work in progress [70%]
# notes       :
# ----
# geography   : Russian Federation
# spatial     : ADM0, ADM1, ADM2
# period      : 2007 - 2022
# sampling    : survey
# comment     : look for some more older data (should be available at lower level); check misaligned files
# ----

thisNation <- "Russian Federation"
# source(paste0(db_path, "preprocess_rosstat.R"))

ds <- c("rosstat")
gs <- c("gadm")


# 1. dataseries ----
#
regDataseries(name = ds[1],
              description = "Russian National Statistics Agency",
              homepage = "www.fedstat.ru",
              version = "2023.12",
              licence_link = "unknown")

locNames <- "голова|области|район|округ|огруг|город|поселок|центнеров с гектара|Республика|"

# 2. geometries ----
#
# based on GADM 3.6


# 3. tables ----
#
## livestock ----
rosstat_livestock <- list.files(path = paste0(db_path, "/tables/stage1/rosstat/"),
                                pattern = "livestock")

for(i in seq_along(rosstat_livestock)){

  thisFile <- rosstat_livestock[i]
  name <- str_split(thisFile, "_")[[1]]
  munst <- name[2]
  ADM1Val <- str_split(name[1], "[.]")[[1]][1]

  schema_livestock <-
    setCluster(id = "ADM2", left = 1, top = .find(pattern = "значение за год|значение показателя за год", col = 1)) |>
    setFilter(rows = .find(pattern = paste0(locNames, "голов"), col = 1, invert = TRUE), clusters = FALSE) |>
    setIDVar(name = "ADM1", value = ADM1Val) |>
    setIDVar(name = "ADM2", columns = 1, split = "(?<=категорий\\, ).*", rows = .find(row = 1, relative = TRUE)) |>
    setIDVar(name = "year", columns = .find(fun = is.numeric, row = 2, relative = TRUE), rows = .find(row = 2, relative = TRUE)) |>
    setIDVar(name = "method", value = "survey") |>
    setIDVar(name = "crop", columns = 1) |>
    setObsVar(name = "number_heads", columns = .find(fun = is.numeric, row = 2, relative = TRUE))

  regTable(ADM0 = !!thisNation,
           label = "ADM2",
           subset = paste0("livestock", ADM1Val),
           dSeries = ds[1],
           gSeries = gs[1],
           schema = schema_livestock,
           begin = 2008,
           end = 2023,
           archive = thisFile,
           archiveLink = paste0("https://www.gks.ru/dbscripts/munst/munst", munst, "/DBInet.cgi"),
           updateFrequency = "annually",
           downloadDate = dmy("05-02-2025"),
           metadataLink = "unknown",
           metadataPath = "unknown",
           overwrite = TRUE)

}

normTable(pattern = paste0("livestock.*", ds[1]),
          ontoMatch = "animal",
          beep = 10)

