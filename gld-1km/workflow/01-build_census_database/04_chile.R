# ----
# title       : build census database - ineCl
# description : this script integrates data of 'Instituto Nacional de Estadísticas' (https://www.ine.gob.cl/)
# license     : https://creativecommons.org/licenses/by-sa/4.0/
# authors     : Steffen Ehrmann
# date        : 2025-01-31
# version     : 0.0.3
# status      : work in progress [30%]
# notes       :
# ----
# geography   : Chile
# spatial     : ADM0, ADM1, ADM2
# period      : 2007 - 2021
# sampling    : survey, census
# comment     : -
# ----

thisNation <- "Chile"

# 1. dataseries ----
#
ds <- c("ineCl")
gs <- c("hdx")

regDataseries(name = ds[1],
              description = "Instituto Nacional de Estadísticas",
              homepage = "https://www.ine.gob.cl/",
              version = "2025.01",
              licence_link = "unknown")


# 2. geometries ----
#
# https://data.humdata.org/dataset/cod-ab-chl
regGeometry(ADM0 = !!thisNation,
            gSeries = gs[1],
            label = list(ADM0 = "ADM0_ES"),
            archive = "chl_adm_bcn_20211008_shp.zip|chl_admbnda_adm0_bcn_20211008.shp",
            archiveLink = "https://data.humdata.org/dataset/70ca85b0-336a-407e-b9e5-f32a7e4840d0/resource/f9c77184-d0bf-494e-b690-070e2266e9cd/download/chl_adm_bcn_20211008_shp.zip",
            downloadDate = ymd("2025-01-27"),
            updateFrequency = "unknown")

regGeometry(ADM0 = !!thisNation,
            gSeries = gs[1],
            label = list(ADM0 = "ADM0_ES", ADM1 = "ADM1_ES"),
            archive = "chl_adm_bcn_20211008_shp.zip|chl_admbnda_adm1_bcn_20211008.shp",
            archiveLink = "https://data.humdata.org/dataset/70ca85b0-336a-407e-b9e5-f32a7e4840d0/resource/f9c77184-d0bf-494e-b690-070e2266e9cd/download/chl_adm_bcn_20211008_shp.zip",
            downloadDate = ymd("2025-01-27"),
            updateFrequency = "unknown")

regGeometry(ADM0 = !!thisNation,
            gSeries = gs[1],
            label = list(ADM0 = "ADM0_ES", ADM1 = "ADM1_ES", ADM2 = "ADM2_ES"),
            archive = "chl_adm_bcn_20211008_shp.zip|chl_admbnda_adm2_bcn_20211008.shp",
            archiveLink = "https://data.humdata.org/dataset/70ca85b0-336a-407e-b9e5-f32a7e4840d0/resource/f9c77184-d0bf-494e-b690-070e2266e9cd/download/chl_adm_bcn_20211008_shp.zip",
            downloadDate = ymd("2025-01-27"),
            updateFrequency = "unknown")

normGeometry(pattern = paste0(thisNation, ".*", gs[1]),
             beep = 10)


# 3. tables ----
#
# other data for:
# census 1997: censo-agropecuario-1997.pdf
# bovino 2011: encuesta-de-ganado-bovino-2011.pdf
# bovino 2009: encuesta-de-ganado-bovino-zona-sur-2009.pdf
# ovino 2006: ganadería-ovina-en-la-agricultura-familiar-campesina-zona-sur-2006.pdf
# ovino 2010: encuesta-ganado-ovino-año-2010---publicación-trianual-convenio-con-odepa.pdf
# caprino 2006: estudio-2006-ganadería-caprina-provincias-de-elqui-limarí-y-choapa.pdf
# caprino 2010: encuesta-ganado-caprino.-año-2010---publicación-trianual-convenio-con-odepa.pdf

schema_livestock_ineCl <-
  setFormat(na_values = "-") |>
  setFilter(rows = .find(fun = is.na, col = 3, invert = TRUE)) |>
  setIDVar(name = "ADM0", value = thisNation) |>
  setIDVar(name = "method", value = "census") |>
  setIDVar(name = "year", columns = 1, rows = 1, split = "(\\d+)(?!.*\\d)") |>
  setIDVar(name = "animal", columns = .find(pattern = "PAÍS|REGIÓN|Región|PROVINCIA", invert = TRUE),
           rows = .find(pattern = "PAÍS|REGIÓN|Región|PROVINCIA", col = 1)) |>
  setObsVar(name = "number_heads", columns = .find(pattern = "PAÍS|REGIÓN|Región|PROVINCIA", invert = TRUE),
            top = .find(pattern = "PAÍS|REGIÓN|Región|PROVINCIA", col = 1))

schema_livestock_ineCl1 <- schema_livestock_ineCl |>
  setIDVar(name = "ADM1", columns = 1)

schema_livestock_ineCl2 <- schema_livestock_ineCl |>
  setIDVar(name = "ADM2", columns = 1)

### bovino ----
regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "bovino",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ineCl1,
         begin = 2007,
         end = 2007,
         archive = "encuesta-de-ganado-bovino-2013.xls",
         archiveLink = "https://www.ine.gob.cl/docs/default-source/produccion-pecuaria/cuadros-estadisticos/ganaderia-bovina/encuesta-de-ganado-bovino-2013.xls",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "irregular",
         metadataLink = "https://www.ine.gob.cl/estadisticas/economia/agricultura-agroindustria-y-pesca/produccion-pecuaria",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "bovino",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ineCl2,
         begin = 2013,
         end = 2013,
         archive = "encuesta-de-ganado-bovino-2013.xls",
         archiveLink = "https://www.ine.gob.cl/docs/default-source/produccion-pecuaria/cuadros-estadisticos/ganaderia-bovina/encuesta-de-ganado-bovino-2013.xls",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "irregular",
         metadataLink = "https://www.ine.gob.cl/estadisticas/economia/agricultura-agroindustria-y-pesca/produccion-pecuaria",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "bovino",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ineCl2,
         begin = 2015,
         end = 2015,
         archive = "encuesta-de-ganado-bovino-2015.xlsx",
         archiveLink = "https://www.ine.gob.cl/docs/default-source/produccion-pecuaria/cuadros-estadisticos/ganaderia-bovina/encuesta-de-ganado-bovino-2015.xlsx",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "irregular",
         metadataLink = "https://www.ine.gob.cl/estadisticas/economia/agricultura-agroindustria-y-pesca/produccion-pecuaria",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "bovino",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ineCl2,
         begin = 2017,
         end = 2017,
         archive = "encuesta-de-ganado-bovino-2017.xls",
         archiveLink = "https://www.ine.gob.cl/docs/default-source/produccion-pecuaria/cuadros-estadisticos/ganaderia-bovina/encuesta-de-ganado-bovino-2017.xls",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "irregular",
         metadataLink = "https://www.ine.gob.cl/estadisticas/economia/agricultura-agroindustria-y-pesca/produccion-pecuaria",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "bovino",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ineCl2,
         begin = 2019,
         end = 2019,
         archive = "encuesta-de-ganado-bovino-2019.xlsx",
         archiveLink = "https://www.ine.gob.cl/docs/default-source/produccion-pecuaria/cuadros-estadisticos/ganaderia-bovina/encuesta-de-ganado-bovino-2019.xlsx",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "irregular",
         metadataLink = "https://www.ine.gob.cl/estadisticas/economia/agricultura-agroindustria-y-pesca/produccion-pecuaria",
         metadataPath = "unknown",
         overwrite = TRUE)

### ovino ----
regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "ovino",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ineCl2,
         begin = 2007,
         end = 2007,
         archive = "encuesta-de-ganado-ovino-año-2013.xls",
         archiveLink = "https://www.ine.gob.cl/docs/default-source/produccion-pecuaria/cuadros-estadisticos/ganado-ovino/encuesta-de-ganado-ovino-a%C3%B1o-2013.xls",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "irregular",
         metadataLink = "https://www.ine.gob.cl/estadisticas/economia/agricultura-agroindustria-y-pesca/produccion-pecuaria",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "ovino",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ineCl2,
         begin = 2013,
         end = 2013,
         archive = "encuesta-de-ganado-ovino-año-2013.xls",
         archiveLink = "https://www.ine.gob.cl/docs/default-source/produccion-pecuaria/cuadros-estadisticos/ganado-ovino/encuesta-de-ganado-ovino-a%C3%B1o-2013.xls",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "irregular",
         metadataLink = "https://www.ine.gob.cl/estadisticas/economia/agricultura-agroindustria-y-pesca/produccion-pecuaria",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "ovino",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ineCl2,
         begin = 2015,
         end = 2015,
         archive = "encuesta-de-ganado-ovino-año-2015.xlsx",
         archiveLink = "https://www.ine.gob.cl/docs/default-source/produccion-pecuaria/cuadros-estadisticos/ganado-ovino/encuesta-de-ganado-ovino-a%C3%B1o-2015.xlsx",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "irregular",
         metadataLink = "https://www.ine.gob.cl/estadisticas/economia/agricultura-agroindustria-y-pesca/produccion-pecuaria",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "ovino",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ineCl2,
         begin = 2017,
         end = 2017,
         archive = "encuesta-de-ganado-ovino-año-2017.xlsx",
         archiveLink = "https://www.ine.gob.cl/docs/default-source/produccion-pecuaria/cuadros-estadisticos/ganado-ovino/encuesta-de-ganado-ovino-a%C3%B1o-2017.xlsx",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "irregular",
         metadataLink = "https://www.ine.gob.cl/estadisticas/economia/agricultura-agroindustria-y-pesca/produccion-pecuaria",
         metadataPath = "unknown",
         overwrite = TRUE)

### caprino ----
regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "caprina",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ineCl1,
         begin = 2007,
         end = 2007,
         archive = "encuesta-ganadería-caprina-2013.xls",
         archiveLink = "https://www.ine.gob.cl/docs/default-source/produccion-pecuaria/cuadros-estadisticos/ganaderia-caprina/encuesta-ganader%C3%ADa-caprina-2013.xls",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "irregular",
         metadataLink = "https://www.ine.gob.cl/estadisticas/economia/agricultura-agroindustria-y-pesca/produccion-pecuaria",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "caprina",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ineCl1,
         begin = 2013,
         end = 2013,
         archive = "encuesta-ganadería-caprina-2013.xls",
         archiveLink = "https://www.ine.gob.cl/docs/default-source/produccion-pecuaria/cuadros-estadisticos/ganaderia-caprina/encuesta-ganader%C3%ADa-caprina-2013.xls",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "irregular",
         metadataLink = "https://www.ine.gob.cl/estadisticas/economia/agricultura-agroindustria-y-pesca/produccion-pecuaria",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "caprina",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ineCl1,
         begin = 2015,
         end = 2015,
         archive = "encuesta-ganadería-caprina-2015.xls",
         archiveLink = "https://www.ine.gob.cl/docs/default-source/produccion-pecuaria/cuadros-estadisticos/ganaderia-caprina/encuesta-ganader%C3%ADa-caprina-2015.xls",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "irregular",
         metadataLink = "https://www.ine.gob.cl/estadisticas/economia/agricultura-agroindustria-y-pesca/produccion-pecuaria",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "caprina",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ineCl1,
         begin = 2017,
         end = 2017,
         archive = "encuesta-ganadería-caprina-2017.xls",
         archiveLink = "https://www.ine.gob.cl/docs/default-source/produccion-pecuaria/cuadros-estadisticos/ganaderia-caprina/encuesta-ganader%C3%ADa-caprina-2017.xls",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "irregular",
         metadataLink = "https://www.ine.gob.cl/estadisticas/economia/agricultura-agroindustria-y-pesca/produccion-pecuaria",
         metadataPath = "unknown",
         overwrite = TRUE)

### all ----
schema_livestock_ine_all <-
  setFormat(na_values = "-") |>
  setFilter(rows = .find(fun = is.na, col = 3, invert = TRUE)) |>
  setIDVar(name = "ADM0", value = thisNation) |>
  setIDVar(name = "ADM1", columns = 1) |>
  setIDVar(name = "method", value = "census") |>
  setIDVar(name = "year", columns = 1, rows = 1, split = "(\\d+)(?!.*\\d)") |>
  setIDVar(name = "animal", columns = .find(pattern = "Total Nacional - Región", invert = TRUE),
           rows = .find(pattern = "Total Nacional - Región", col = 1)) |>
  setObsVar(name = "number_heads", columns = .find(pattern = "Total Nacional - Región", invert = TRUE),
            top = .find(pattern = "Total Nacional - Región", col = 1))

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "allLivestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ine_all,
         begin = 2021,
         end = 2021,
         archive = "existencias-animales.xlsx",
         archiveLink = "https://www.ine.gob.cl/docs/default-source/censo-agropecuario/cuadros-estadisticos/2021/existencias-animales.xlsx",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "irregular",
         metadataLink = "https://www.ine.gob.cl/estadisticas/economia/agricultura-agroindustria-y-pesca/censos-agropecuarios",
         metadataPath = "unknown",
         overwrite = TRUE)

normTable(pattern = ds[1],
          ontoMatch = "animal",
          beep = 10)
