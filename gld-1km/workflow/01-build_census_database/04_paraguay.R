# ----
# title       : build census database - inePy
# description : this script integrates data of 'Instituto Nacional de Estadística y Censos' (http://www.senacsa.gov.py/)
# license     : https://creativecommons.org/licenses/by-sa/4.0/
# authors     : Steffen Ehrmann
# date        : 2025-01-31
# version     : 0.3.0
# status      : work in progress [30%]
# notes       :
# ----
# geography   : Paraguay
# spatial     : ADM0, ADM1
# period      : 2007 - 2022
# sampling    : survey, census
# comment     : -
# ----

thisNation <- "Paraguay"

# 1. dataseries ----
#
ds <- c("inePy")
gs <- c("hdx")

regDataseries(name = ds[1],
              description = "Instituto Nacional de Estadística y Censos",
              homepage = "http://www.senacsa.gov.py/",
              version = "2025.01",
              licence_link = "unknown")


# 2. geometries ----
#
# https://data.humdata.org/dataset/cod-ab-pry
regGeometry(ADM0 = !!thisNation,
            gSeries = gs[1],
            label = list(ADM0 = "ADM0_ES"),
            archive = "pry_adm_dgeec_2020_shp.zip|pry_admbnda_adm0_DGEEC_2020.shp",
            archiveLink = "https://data.humdata.org/dataset/212cd82f-bcb8-445f-8b32-aa194387f6c3/resource/7b2e1608-ca01-4271-ba60-dcde5c73433f/download/pry_adm_dgeec_2020_shp.zip",
            downloadDate = ymd("2025-01-27"),
            updateFrequency = "unknown")

regGeometry(ADM0 = !!thisNation,
            gSeries = gs[1],
            label = list(ADM0 = "ADM0_ES", ADM1 = "ADM1_ES"),
            archive = "pry_adm_dgeec_2020_shp.zip|pry_admbnda_adm1_DGEEC_2020.shp",
            archiveLink = "https://data.humdata.org/dataset/212cd82f-bcb8-445f-8b32-aa194387f6c3/resource/7b2e1608-ca01-4271-ba60-dcde5c73433f/download/pry_adm_dgeec_2020_shp.zip",
            downloadDate = ymd("2025-01-27"),
            updateFrequency = "unknown")

normGeometry(pattern = paste0(thisNation, ".*", gs[1]),
             beep = 10)


# 3. tables ----
#
# additional tables in PDFs
# - e590_Capitulo0600.pdf; ADM1; aves detailed 1996-2000, other 1998-2000
# - 4f81_anuario2002cap06.pdf; ADM1; bovinos 2002, aves detailed 1997-2001, other 1999-2001
# - a625_Capitulo_6.pdf; ADM1; aves 2000-2004, other 2002-2004
# - d78d_Capitulo06-2003.pdf; ADM1; aves detailed 1999-2003, other 2001-2003
# - 0bec_Anuario 2005 Cap 6.pdf; ADM1; bovinos 2005, aves detailed 2000-2004, other 2003-2005
# - 45ac_Cap. 06-2008.pdf; ADM1; bovinos 2004-2007
# - b2bd_cap 06.pdf; ADM1; bovinos 2006-2009
# - 51de_cap 06 2010.pdf; ADM1; bovinos 2007-2010
# - 7fa3_Anuario Estadistico 2011.pdf; ADM1; bovinos 2008-2011
# - 8db7_Anuario Estadistico 2013.pdf; ADM1; bovinos 2010-2013
# - 68d1_Anuario Estadistico del Paraguay 2016.pdf; ADM1; bovinos 2013-2016
# - ece9_Anuario Estadistico 2017.pdf; ADM1; bovinos 2014-2017
# - 5f87_Anuario Estadistico 2018.pdf; ADM1; bovinos 2015-2018
# - be0b_Anuario Estadistico 2019_Web.pdf; ADM1; bovinos 2016-2019
# - Anuario_Estadistico_2020.pdf; ADM1; bovinos 2017-2020
# - Anuario Estadistico 2021.pdf; ADM1; bovinos 2018-2021

schema_livestock1 <-
  setIDVar(name = "ADM1", columns = 2) |>
  setIDVar(name = "year", columns = c(3:14), rows = 1) |>
  setIDVar(name = "method", value = "survey") |>
  setIDVar(name = "animal", value = "cattle") |>
  setObsVar(name = "number_heads", columns = c(3:14), top = 1)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "cattle",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock1,
         begin = 2007,
         end = 2019,
         archive = "serie-vacuna.csv",
         archiveLink = "https://www.mag.gov.py/datos/index-serie-vacuno.html#",
         downloadDate = ymd("2025-01-24"),
         updateFrequency = "annually",
         metadataLink = "https://datos.gov.py/dataset/serie-hist%C3%B3rica-cantidad-de-cabezas-de-ganado-vacuno",
         metadataPath = "unknown",
         overwrite = TRUE)

schema_livestock2 <-
  setFilter(rows = c(1, 2), invert = TRUE) |>
  setIDVar(name = "ADM1", columns = 1) |>
  setIDVar(name = "method", value = "survey") |>
  setIDVar(name = "animal", columns = .find(pattern = "Departamento|DEPARTAMENTO", invert = TRUE, row = 4), rows = 4) |>
  setObsVar(name = "number_heads", columns = .find(pattern = "Departamento|DEPARTAMENTO", invert = TRUE, row = 4), top = 4)

schema_livestock2020 <- schema_livestock2 |>
  setIDVar(name = "year", value = "2020")

schema_livestock2021 <- schema_livestock2 |>
  setIDVar(name = "year", value = "2021")

schema_livestock2022 <- schema_livestock2 |>
  setIDVar(name = "year", value = "2022")

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "cattleDetail",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock2020,
         begin = 2020,
         end = 2020,
         archive = "02_ POBLACION BOVINA POR CATEGORIA Y DPTO 1er. PERIODO 2020.xls",
         archiveLink = "unknown",
         downloadDate = ymd("2025-01-24"),
         updateFrequency = "unknown",
         metadataLink = "unknown",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "livestockOther",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock2020,
         begin = 2020,
         end = 2020,
         archive = "13_EXISTENCIA DECLARADA DE ESPECIES_1ER PERIODO 2020.xls",
         archiveLink = "unknown",
         downloadDate = ymd("2025-01-24"),
         updateFrequency = "unknown",
         metadataLink = "unknown",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "cattleDetail",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock2021,
         begin = 2021,
         end = 2021,
         archive = "02_POBLACION BOVINA POR CATEGORIA Y DEPARTAMENTO PRIMER PERIODO.xls",
         archiveLink = "unknown",
         downloadDate = ymd("2025-01-24"),
         updateFrequency = "unknown",
         metadataLink = "unknown",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "livestockOther",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock2021,
         begin = 2021,
         end = 2021,
         archive = "11_EXISTENCIA DECLARADA DE ESPECIES_1ER PERIODO 2021.xls",
         archiveLink = "unknown",
         downloadDate = ymd("2025-01-24"),
         updateFrequency = "unknown",
         metadataLink = "unknown",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "cattleDetail",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock2022,
         begin = 2022,
         end = 2022,
         archive = "02_ POBLACION BOVINA POR CATEGORIA Y DPTO 1er. PERIODO 2022.xls",
         archiveLink = "unknown",
         downloadDate = ymd("2025-01-24"),
         updateFrequency = "unknown",
         metadataLink = "unknown",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "livestockOther",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock2022,
         begin = 2022,
         end = 2022,
         archive = "11_EXISTENCIA DECLARADA DE ESPECIES_1ER PERIODO 2022.xls",
         archiveLink = "unknown",
         downloadDate = ymd("2025-01-24"),
         updateFrequency = "unknown",
         metadataLink = "unknown",
         metadataPath = "unknown",
         overwrite = TRUE)

normTable(pattern = ds[1],
          ontoMatch = "animal",
          beep = 10)
