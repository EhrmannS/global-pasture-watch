# ----
# title       : build census database - _INESRT
# description : this script integrates data of '_INSERT' (LINK)
# license     : https://creativecommons.org/licenses/by-sa/4.0/
# authors     : Steffen Ehrmann
# date        : YYYY-MM-DD
# version     : 0.0.0
# status      : work in progress [%], finished
# notes       :
# ----
# geography   : _INSERT
# spatial     : _INSERT
# period      : _INSERT
# sampling    : survey, census
# comment     : _INSERT
# ----

thisNation <- _INSERT

# 1. dataseries ----
#
ds <- c(_INSERT)
gs <- c(_INSERT)

regDataseries(name = ds[],
              description = _INSERT,
              homepage = _INSERT,
              version = _INSERT,
              licence_link = _INSERT)


# 2. geometries ----
#
regGeometry(ADM0 = !!thisNation,
            gSeries = gs[],
            label = list(ADM_ = ""),
            archive = "|",
            archiveLink = _INSERT,
            downloadDate = _INSERT,
            updateFrequency = _INSERT)

normGeometry(pattern = gs[],
             beep = 10)


# 3. tables ----
#
schema_livestock <- setCluster(id = _INSERT) |>
  setFormat(header = _INSERT, decimal = _INSERT, thousand = _INSERT,
            na_values = _INSERT) |>
  setFilter() |>
  setIDVar(name = "ADM0", ) |>
  setIDVar(name = "ADM1", ) |>
  setIDVar(name = "ADM2", ) |>
  setIDVar(name = "year", ) |>
  setIDVar(name = "method", value = "") |>
  setIDVar(name = "animal", ) |>
  setObsVar(name = "number_heads", )

regTable(al1 = !!thisNation,
         label = "ADM_",
         subset = _INSERT,
         dSeries = ds[],
         gSeries = gs[],
         schema = schema_livestock,
         begin = _INSERT,
         end = _INSERT,
         archive = _INSERT,
         archiveLink = _INSERT,
         downloadDate = ymd(_INSERT),
         updateFrequency = _INSERT,
         metadataLink = _INSERT,
         metadataPath = _INSERT,
         overwrite = TRUE)

normTable(pattern = ds[],
          ontoMatch = "animal",
          beep = 10)
