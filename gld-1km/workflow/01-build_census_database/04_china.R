# ----
# title       : build census database - nbs, cnki, goahr
# description : this script integrates data of ' National Bureau of Statistics of China' (http://www.data.stats.gov.cn/english/), 'Data for Agriculture, Forest, Livestock and Fishery' (https://www.cnki.net/), 'National Geomatics Center of China' (http://gaohr.win/site/blogs/2017/2017-04-18-GIS-basic-data-of-China.html)
# license     : https://creativecommons.org/licenses/by-sa/4.0/
# authors     : Steffen Ehrmann
# date        : 2025-01-31
# version     : 0.3.0
# status      : work in progress [30%]
# notes       :
# ----
# geography   : China
# spatial     : ADM0, ADM1
# period      : 1949 - 2020
# sampling    : survey, census
# comment     : -
# ----

thisNation <- "China"

# 1. dataseries ----
#
ds <- c("nbs", "cnki")
gs <- c("gadm", "gaohr")

regDataseries(name = ds[1],
              description = "National Bureau of Statistics of China",
              homepage = "https://www.data.stats.gov.cn/english/",
              version = "2024.07",
              licence_link = "https://www.stats.gov.cn/english/nbs/200701/t20070104_59236.html")

regDataseries(name = ds[2],
              description = "Data for Agriculture, Forest, Livestock and Fishery",
              homepage = "https://www.cnki.net/",
              version = "2024.07",
              licence_link = "unknown")

regDataseries(name = gs[2],
              description = "National Geomatics Center of China",
              homepage = "http://gaohr.win/site/blogs/2017/2017-04-18-GIS-basic-data-of-China.html",
              version = "2024.07",
              licence_link = "unknown")


# 2. geometries ----
#


# 3. tables ----
#
nbs_data <- list.files(path = paste0(db_path, "/tables/stage1/nbs"))

schema_nbs <- setCluster(id = "animal", left = 1, top = 4) |>
  setFormat(decimal = ",") |>
  setIDVar(name = "ADM0", value = "China") |>
  setIDVar(name = "ADM1", rows = 4, columns = .find(fun = is.na, row = 3)) |>
  setIDVar(name = "year", columns = 1) |>
  setIDVar(name = "method", value = "survey")

### nbs ----
nbs_livestock <- nbs_data[str_which(string = nbs_data, pattern = c("headcount"))]

for(i in seq_along(nbs_livestock)){

  temp <- str_split(nbs_livestock[i], "_")[[1]]
  temp[2] <- str_split(temp[2], "[.]")[[1]][1]

  schema_nbs_livestock <- schema_nbs |>
    setIDVar(name = "animal", value = temp[2]) |>
    setObsVar(name = "number_heads", factor = 10000, columns = .find(fun = is.na, row = 3))

  regTable(ADM0 = !!thisNation,
           label = "ADM1",
           subset = paste0(temp[2], .toCap(temp[1])),
           dSeries = ds[1],
           gSeries = gs[1],
           schema = schema_nbs_livestock,
           begin = 1978,
           end = 2020,
           archive = nbs_livestock[i],
           archiveLink = "https://www.stats.gov.cn/english/",
           downloadDate = ymd("2024-07-17"),
           updateFrequency = "annually",
           metadataLink = "unavailable",
           metadataPath = "unavailable",
           overwrite = TRUE)

}

normTable(pattern = ds[1],
          ontoMatch = "animal",
          beep = 10)
