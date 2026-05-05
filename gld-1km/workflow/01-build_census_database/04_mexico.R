# ----
# title       : build census database - siap, inegi
# description : this script integrates data of 'Servicio de Información Agroalimentaria y Pesquera' (https://www.gob.mx/siap/), National Institute of Statistics and Geography (https://en.www.inegi.org.mx/)
# license     : https://creativecommons.org/licenses/by-sa/4.0/
# authors     : Steffen Ehrmann
# date        : 2025-01-31
# version     : 0.3.0
# status      : work in progress [30%]
# notes       :
# ----
# geography   : Mexico
# spatial     : ADM0, ADM1
# period      : 2012, 2014, 2017, 2019 (census); 2014 - 2023 (survey)
# sampling    : survey, census
# comment     : ave, bovino, caprino, guajolote, ovino, porcino, abeja
# ----

thisNation <- "Mexico"

# 1. dataseries ----
#
ds <- c("inegi", "siap")
gs <- c("hdx")

# regDataseries(name = ds[1],
#               description = "National Institute of Statistics and Geography",
#               homepage = "https://en.www.inegi.org.mx/",
#               version = _INSERT,
#               licence_link = _INSERT)

regDataseries(name = ds[2],
              description = "Gobierno de Mexico - ",
              homepage = "https://www.gob.mx/siap/acciones-y-programas/produccion-pecuaria",
              version = "2025.01",
              licence_link = "unknown")


# 2. geometries ----
#
# https://data.humdata.org/dataset/cod-ab-mex
regGeometry(ADM0 = !!thisNation,
            gSeries = gs[1],
            label = list(ADM0 = "ADM0_ES"),
            archive = "mex_admbnda_govmex_20210618_shp.zip|mex_admbnda_adm0_govmex_20210618.shp",
            archiveLink = "https://data.humdata.org/dataset/9721eaf0-5663-4137-b3a2-c21dc8fac15a/resource/f151b1c1-1353-4f57-bdb2-b1b1c18a1fd1/download/mex_admbnda_govmex_20210618_shp.zip",
            downloadDate = ymd("2025-01-27"),
            updateFrequency = "unknown")

regGeometry(ADM0 = !!thisNation,
            gSeries = gs[1],
            label = list(ADM0 = "ADM0_ES", ADM1 = "ADM1_ES"),
            archive = "mex_admbnda_govmex_20210618_shp.zip|mex_admbnda_adm1_govmex_20210618.shp",
            archiveLink = "https://data.humdata.org/dataset/9721eaf0-5663-4137-b3a2-c21dc8fac15a/resource/f151b1c1-1353-4f57-bdb2-b1b1c18a1fd1/download/mex_admbnda_govmex_20210618_shp.zip",
            downloadDate = ymd("2025-01-27"),
            updateFrequency = "unknown")

normGeometry(pattern = paste0(thisNation, ".*", gs[1]),
             beep = 10)


# 3. tables ----
#
schema_livestock_gobmx <-
  setFormat(thousand = ",") |>
  setIDVar(name = "ADM1", columns = 1) |>
  setIDVar(name = "year", columns = c(2:11), rows = 9) |>
  setIDVar(name = "method", value = "survey") |>
  setIDVar(name = "animal", columns = 1, rows = 1) |>
  setObsVar(name = "number_heads", columns = c(2:11), top = 9)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "abeja",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_gobmx,
         begin = 2014,
         end = 2023,
         archive = "Inventario 2023 Abeja.xls",
         archiveLink = "https://nube.siap.gob.mx/poblacion_ganadera/",
         downloadDate = ymd("2025-01-14"),
         updateFrequency = "annually",
         metadataLink = "https://nube.siap.gob.mx/poblacion_ganadera/",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "avesCarne",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_gobmx,
         begin = 2014,
         end = 2023,
         archive = "Inventario 2023 Ave para carne.xls",
         archiveLink = "https://nube.siap.gob.mx/poblacion_ganadera/",
         downloadDate = ymd("2025-01-14"),
         updateFrequency = "annually",
         metadataLink = "https://nube.siap.gob.mx/poblacion_ganadera/",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "avesHuevo",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_gobmx,
         begin = 2014,
         end = 2023,
         archive = "Inventario 2023 Ave para huevo.xls",
         archiveLink = "https://nube.siap.gob.mx/poblacion_ganadera/",
         downloadDate = ymd("2025-01-14"),
         updateFrequency = "annually",
         metadataLink = "https://nube.siap.gob.mx/poblacion_ganadera/",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "avesTotal",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_gobmx,
         begin = 2014,
         end = 2023,
         archive = "Inventario 2023 Aves carne y huevo.xls",
         archiveLink = "https://nube.siap.gob.mx/poblacion_ganadera/",
         downloadDate = ymd("2025-01-14"),
         updateFrequency = "annually",
         metadataLink = "https://nube.siap.gob.mx/poblacion_ganadera/",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "bovinoCarne",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_gobmx,
         begin = 2014,
         end = 2023,
         archive = "Inventario 2023 Bovino para carne.xls",
         archiveLink = "https://nube.siap.gob.mx/poblacion_ganadera/",
         downloadDate = ymd("2025-01-14"),
         updateFrequency = "annually",
         metadataLink = "https://nube.siap.gob.mx/poblacion_ganadera/",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "bovinoLeche",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_gobmx,
         begin = 2014,
         end = 2023,
         archive = "Inventario 2023 Bovino para leche.xls",
         archiveLink = "https://nube.siap.gob.mx/poblacion_ganadera/",
         downloadDate = ymd("2025-01-14"),
         updateFrequency = "annually",
         metadataLink = "https://nube.siap.gob.mx/poblacion_ganadera/",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "bovinoTotal",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_gobmx,
         begin = 2014,
         end = 2023,
         archive = "Inventario 2023 Bovinos carne y leche.xls",
         archiveLink = "https://nube.siap.gob.mx/poblacion_ganadera/",
         downloadDate = ymd("2025-01-14"),
         updateFrequency = "annually",
         metadataLink = "https://nube.siap.gob.mx/poblacion_ganadera/",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "caprino",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_gobmx,
         begin = 2014,
         end = 2023,
         archive = "Inventario 2023 Caprino.xls",
         archiveLink = "https://nube.siap.gob.mx/poblacion_ganadera/",
         downloadDate = ymd("2025-01-14"),
         updateFrequency = "annually",
         metadataLink = "https://nube.siap.gob.mx/poblacion_ganadera/",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "guajolote",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_gobmx,
         begin = 2014,
         end = 2023,
         archive = "Inventario 2023 Guajolote.xls",
         archiveLink = "https://nube.siap.gob.mx/poblacion_ganadera/",
         downloadDate = ymd("2025-01-14"),
         updateFrequency = "annually",
         metadataLink = "https://nube.siap.gob.mx/poblacion_ganadera/",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "ovino",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_gobmx,
         begin = 2014,
         end = 2023,
         archive = "Inventario 2023 Ovino.xls",
         archiveLink = "https://nube.siap.gob.mx/poblacion_ganadera/",
         downloadDate = ymd("2025-01-14"),
         updateFrequency = "annually",
         metadataLink = "https://nube.siap.gob.mx/poblacion_ganadera/",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "porcino",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_gobmx,
         begin = 2014,
         end = 2023,
         archive = "Inventario 2023 Porcino.xls",
         archiveLink = "https://nube.siap.gob.mx/poblacion_ganadera/",
         downloadDate = ymd("2025-01-14"),
         updateFrequency = "annually",
         metadataLink = "https://nube.siap.gob.mx/poblacion_ganadera/",
         metadataPath = "unknown",
         overwrite = TRUE)

normTable(pattern = ds[2],
          ontoMatch = "animal",
          beep = 10)
