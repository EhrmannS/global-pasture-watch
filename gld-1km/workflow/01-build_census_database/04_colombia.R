# ----
# title       : build census database - ica
# description : this script integrates data of 'Instituto Colombiano Agropecuario' (https://www.ica.gov.co/)
# license     : https://creativecommons.org/licenses/by-sa/4.0/
# authors     : Steffen Ehrmann
# date        : 2025-01-31
# version     : 0.0.3
# status      : work in progress [30%]
# notes       :
# ----
# geography   : Colombia
# spatial     : ADM0, ADM1, ADM2
# period      : 2017 - 2024
# sampling    : survey, census
# comment     : aves, bovinos, bufalos, caprinos, equinos, ovinos, porcinos
# ----

thisNation <- "Colombia"
# source(paste0(mdl0301, "src/preprocess_ica.R"))

# 1. dataseries ----
#
ds <- c("dane", "ica")
gs <- c("hdx")

# regDataseries(name = ds[1],
#               description = "Departamento Estadistico Nacional de Estadistica",
#               homepage = "https://www.dane.gov.co/",
#               version = _INSERT,
#               licence_link = _INSERT)

regDataseries(name = ds[2],
              description = "Instituto Colombiano Agropecuario",
              homepage = "https://www.ica.gov.co/",
              version = "2025.01",
              licence_link = "https://www.ica.gov.co/home/terminos-y-condiciones")


# 2. geometries ----
#
# https://data.humdata.org/dataset/cod-ab-col
regGeometry(ADM0 = !!thisNation,
            gSeries = gs[1],
            label = list(ADM0 = "ADM0_ES"),
            archive = "col-administrative-divisions-shapefiles.zip|col_admbnda_adm0_mgn_itos_20200416.shp",
            archiveLink = "https://data.humdata.org/dataset/50ea7fee-f9af-45a7-8a52-abb9c790a0b6/resource/32fba556-0109-4d1c-84cb-c8abddf7775b/download/col-administrative-divisions-shapefiles.zip",
            downloadDate = ymd("2025-01-27"),
            updateFrequency = "unknown")

regGeometry(ADM0 = !!thisNation,
            gSeries = gs[1],
            label = list(ADM0 = "ADM0_ES", ADM1 = "ADM1_ES"),
            archive = "col-administrative-divisions-shapefiles.zip|col_admbnda_adm1_mgn_20200416.shp",
            archiveLink = "https://data.humdata.org/dataset/50ea7fee-f9af-45a7-8a52-abb9c790a0b6/resource/32fba556-0109-4d1c-84cb-c8abddf7775b/download/col-administrative-divisions-shapefiles.zip",
            downloadDate = ymd("2025-01-27"),
            updateFrequency = "unknown")

regGeometry(ADM0 = !!thisNation,
            gSeries = gs[1],
            label = list(ADM0 = "ADM0_ES", ADM1 = "ADM1_ES", ADM2 = "ADM2_ES"),
            archive = "col-administrative-divisions-shapefiles.zip|col_admbnda_adm2_mgn_20200416.shp",
            archiveLink = "https://data.humdata.org/dataset/50ea7fee-f9af-45a7-8a52-abb9c790a0b6/resource/32fba556-0109-4d1c-84cb-c8abddf7775b/download/col-administrative-divisions-shapefiles.zip",
            downloadDate = ymd("2025-01-27"),
            updateFrequency = "unknown")

normGeometry(pattern = paste0(thisNation, ".*", gs[1]),
             beep = 10)


# 3. tables ----
#
schema_livestock_ica <-
  setFormat(na_values = "-") |>
  setFilter(rows = .find(fun = is.na, col = 2, invert = TRUE)) |>
  setIDVar(name = "ADM0", value = thisNation) |>
  setIDVar(name = "ADM1", columns = 1) |>
  setIDVar(name = "ADM2", columns = 2) |>
  setIDVar(name = "method", value = "census") |>
  setIDVar(name = "animal", columns = .find(pattern = "Departamento|Departamentos|DEPARTAMENTO|Municipio|MUNICIPIO", invert = TRUE),
           rows = .find(pattern = "Departamento|Departamentos|DEPARTAMENTO", col = 1)) |>
  setObsVar(name = "number_heads", columns = .find(pattern = "Departamento|Departamentos|DEPARTAMENTO|Municipio|MUNICIPIO", invert = TRUE),
            top = .find(pattern = "Departamento|Departamentos|DEPARTAMENTO", col = 1))

schema_livestock_ica_2016 <- schema_livestock_ica |>
  setIDVar(name = "year", value = "2016")

schema_livestock_ica_2017 <- schema_livestock_ica |>
  setIDVar(name = "year", value = "2017")

schema_livestock_ica_2018 <- schema_livestock_ica |>
  setIDVar(name = "year", value = "2018")

schema_livestock_ica_2019 <- schema_livestock_ica |>
  setIDVar(name = "year", value = "2019")

schema_livestock_ica_2020 <- schema_livestock_ica |>
  setIDVar(name = "year", value = "2020")

schema_livestock_ica_2021 <- schema_livestock_ica |>
  setIDVar(name = "year", value = "2021")

schema_livestock_ica_2022 <- schema_livestock_ica |>
  setIDVar(name = "year", value = "2022")

schema_livestock_ica_2023 <- schema_livestock_ica |>
  setIDVar(name = "year", value = "2023")

schema_livestock_ica_2024 <- schema_livestock_ica |>
  setIDVar(name = "year", value = "2024")

### 2016 ----
regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "aves",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2016,
         begin = 2016,
         end = 2016,
         archive = "Aves-por-Muni-y-Dpto-2016.xlsx",
         archiveLink = "https://www.ica.gov.co/Areas/Pecuaria/Servicios/Epidemiologia-Veterinaria/Censos-2016/Censo-2016/Aves-por-Muni-y-Dpto-2016.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "bovinos",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2016,
         begin = 2016,
         end = 2016,
         archive = "Bovinos-por-Muni-y-Dpto-2016.xlsx",
         archiveLink = "https://www.ica.gov.co/Areas/Pecuaria/Servicios/Epidemiologia-Veterinaria/Censos-2016/Censo-2016/Bovinos-por-Muni-y-Dpto-2016.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "porcinos",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2016,
         begin = 2016,
         end = 2016,
         archive = "Porcinos-por-Muni-y-Dpto-2016.xlsx",
         archiveLink = "https://www.ica.gov.co/Areas/Pecuaria/Servicios/Epidemiologia-Veterinaria/Censos-2016/Censo-2016/Porcinos-por-Muni-y-Dpto-2016.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "otras",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2016,
         begin = 2016,
         end = 2016,
         archive = "Bufalos-por-Muni-y-Dpto-2016.xlsx",
         archiveLink = "https://www.ica.gov.co/Areas/Pecuaria/Servicios/Epidemiologia-Veterinaria/Censos-2016/Censo-2016/Bufalos-por-Muni-y-Dpto-2016.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016",
         metadataPath = "unknown",
         overwrite = TRUE)

### 2017 ----
regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "aves",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2017,
         begin = 2017,
         end = 2017,
         archive = "CENSO-AVES-2017-3.xlsx",
         archiveLink = "https://www.ica.gov.co/getattachment/Areas/Pecuaria/Servicios/Epidemiologia-Veterinaria/Censos-2016/Censo-2017/CENSO-AVES-2017-3.xlsx.aspx?lang=es-CO",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2017",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "bovino",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2017,
         begin = 2017,
         end = 2017,
         archive = "CENSO-BOVINO-2017.xlsx",
         archiveLink = "https://www.ica.gov.co/getattachment/Areas/Pecuaria/Servicios/Epidemiologia-Veterinaria/Censos-2016/Censo-2017/CENSO-BOVINO-2017.xlsx.aspx?lang=es-CO",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2017",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "bufalino",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2017,
         begin = 2017,
         end = 2017,
         archive = "CENSO-BUFALINO-2017.xlsx",
         archiveLink = "https://www.ica.gov.co/getattachment/Areas/Pecuaria/Servicios/Epidemiologia-Veterinaria/Censos-2016/Censo-2017/CENSO-BUFALINO-2017.xlsx.aspx?lang=es-CO",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2017",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "caprino",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2017,
         begin = 2017,
         end = 2017,
         archive = "CENSO-CAPRINO-2017.xlsx",
         archiveLink = "https://www.ica.gov.co/getattachment/Areas/Pecuaria/Servicios/Epidemiologia-Veterinaria/Censos-2016/Censo-2017/CENSO-CAPRINO-2017.xlsx.aspx?lang=es-CO",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2017",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "equino",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2017,
         begin = 2017,
         end = 2017,
         archive = "CENSO-EQUINO-2017-1.xlsx",
         archiveLink = "https://www.ica.gov.co/getattachment/Areas/Pecuaria/Servicios/Epidemiologia-Veterinaria/Censos-2016/Censo-2017/CENSO-EQUINO-2017-1.xlsx.aspx?lang=es-CO",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2017",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "ovino",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2017,
         begin = 2017,
         end = 2017,
         archive = "CENSO-OVINO-2017.xlsx",
         archiveLink = "https://www.ica.gov.co/getattachment/Areas/Pecuaria/Servicios/Epidemiologia-Veterinaria/Censos-2016/Censo-2017/CENSO-OVINO-2017.xlsx.aspx?lang=es-CO",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2017",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "porcino",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2017,
         begin = 2017,
         end = 2017,
         archive = "CENSO-PORCINO-2017.xlsx",
         archiveLink = "https://www.ica.gov.co/getattachment/Areas/Pecuaria/Servicios/Epidemiologia-Veterinaria/Censos-2016/Censo-2017/CENSO-PORCINO-2017.xlsx.aspx?lang=es-CO",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2017",
         metadataPath = "unknown",
         overwrite = TRUE)

### 2018 ----
regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "aves",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2018,
         begin = 2018,
         end = 2018,
         archive = "CENSO-AVES-2018.xlsx",
         archiveLink = "https://www.ica.gov.co/getattachment/Areas/Pecuaria/Servicios/Epidemiologia-Veterinaria/Censos-2016/Censo-2018/CENSO-AVES-2018.xlsx.aspx?lang=es-CO",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "bovinos",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2018,
         begin = 2018,
         end = 2018,
         archive = "CENSO-BOVINOS-POR-DEPARTAMENTO-2018.xlsx",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018/censo-bovinos-por-departamento-2018.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "bufalos",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2018,
         begin = 2018,
         end = 2018,
         archive = "CENSO-BUFALOS-2018.xlsx",
         archiveLink = "https://www.ica.gov.co/getattachment/Areas/Pecuaria/Servicios/Epidemiologia-Veterinaria/Censos-2016/Censo-2018/CENSO-BUFALOS-2018.xlsx.aspx?lang=es-CO",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "caprinos",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2018,
         begin = 2018,
         end = 2018,
         archive = "CENSO-CAPRINOS-2018.xlsx",
         archiveLink = "https://www.ica.gov.co/getattachment/Areas/Pecuaria/Servicios/Epidemiologia-Veterinaria/Censos-2016/Censo-2018/CENSO-CAPRINOS-2018.xlsx.aspx?lang=es-CO",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "equinos",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2018,
         begin = 2018,
         end = 2018,
         archive = "CENSO-EQUINOS-2018.xlsx",
         archiveLink = "https://www.ica.gov.co/getattachment/Areas/Pecuaria/Servicios/Epidemiologia-Veterinaria/Censos-2016/Censo-2018/CENSO-EQUINOS-2018.xlsx.aspx?lang=es-CO",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "ovinos",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2018,
         begin = 2018,
         end = 2018,
         archive = "CENSO-OVINOS-2018.xlsx",
         archiveLink = "https://www.ica.gov.co/getattachment/Areas/Pecuaria/Servicios/Epidemiologia-Veterinaria/Censos-2016/Censo-2018/CENSO-OVINOS-2018.xlsx.aspx?lang=es-CO",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "porcinos",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2018,
         begin = 2018,
         end = 2018,
         archive = "CENSO-PORCINOS-2018.xlsx",
         archiveLink = "https://www.ica.gov.co/getattachment/Areas/Pecuaria/Servicios/Epidemiologia-Veterinaria/Censos-2016/Censo-2018/CENSO-PORCINOS-2018.xlsx.aspx?lang=es-CO",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

### 2019 ----
regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "aves",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2019,
         begin = 2019,
         end = 2019,
         archive = "TABLA-AVES-MUNICIPIOS-DEPARTAMENTOS-2019.xlsx",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018/tabla-aves-municipios-departamentos-2019.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "bovinos",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2019,
         begin = 2019,
         end = 2019,
         archive = "TABLA-BOVINOS-MUNICIPIOS-DEPARTAMENTOS-2019.xls",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018/tabla-bovinos-municipios-departamentos-2019.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "bufalos",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2019,
         begin = 2019,
         end = 2019,
         archive = "TABLA-BUFALOS-MUNICIPIOS-DEPARTAMENTOS-2019.xls",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018/tabla-bufalos-municipios-departamentos-2019.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "caprinos",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2019,
         begin = 2019,
         end = 2019,
         archive = "TABLA-CAPRINOS-MUNICIPIOS-DEPARTAMENTOS-2019.xls",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018/tabla-caprinos-municipios-departamentos-2019.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "equinos",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2019,
         begin = 2019,
         end = 2019,
         archive = "TABLA-EQUINOS-MUNICIPIOS-DEPARTAMENTOS-2019.xls",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018/tabla-equinos-municipios-departamentos-2019.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "ovinos",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2019,
         begin = 2019,
         end = 2019,
         archive = "TABLA-OVINOS-MUNICIPIOS-DEPARTAMENTOS-2019.xls",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018/tabla-ovinos-municipios-departamentos-2019.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "porcinos",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2019,
         begin = 2019,
         end = 2019,
         archive = "TABLA-PORCINOS-MUNICIPIOS-DEPARTAMENTOS-2019.xls",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018/tabla-porcinos-municipios-departamentos-2019.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

### 2020 ----
regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "aves",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2020,
         begin = 2020,
         end = 2020,
         archive = "AVES-CENSOS-2020.xlsx",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2020/aves-censos-2020.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "bovinos",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2020,
         begin = 2020,
         end = 2020,
         archive = "BOVINOS-CENSO-2020.xlsx",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2020/bovinos-censo-2020.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "bufalos",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2020,
         begin = 2020,
         end = 2020,
         archive = "BUFALOS-CENSO-2020.xlsx",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2020/bufalos-censo-2020.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "equinosCaprinosOvinos",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2020,
         begin = 2020,
         end = 2020,
         archive = "Equinos-Caprinos-Ovinos-CENSOS-2020.xlsx",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2020/equinos-caprinos-ovinos-censos-2020-2.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "porcinos",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2020,
         begin = 2020,
         end = 2020,
         archive = "PORCINOS-CENSOS-2020.xlsx",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2020/porcinos-censos-2020.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

### 2021 ----
regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "aves",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2021,
         begin = 2021,
         end = 2021,
         archive = "CENSO-AVES-2021.xlsx",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018/censo-aves-2021.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "bovino",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2021,
         begin = 2021,
         end = 2021,
         archive = "CENSO-BOVINO-2021.xlsx",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018/censo-bovino-2021-1.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "bufalo",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2021,
         begin = 2021,
         end = 2021,
         archive = "CENSO-BUFALO-2021.xlsx",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018/censo-bufalo-202.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "porcino",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2021,
         begin = 2021,
         end = 2021,
         archive = "CENSO-PORCINO-2021.xlsx",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018/censo-porcino-2021.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "equinosOvinosCaprinos",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2021,
         begin = 2021,
         end = 2021,
         archive = "CENSOS-EQUINOS-OVINOS-CAPRINOS-2021.xlsx",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018/censos-equinos-ovinos-caprinos-2021.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

### 2022 ----
regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "aves",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2022,
         begin = 2022,
         end = 2022,
         archive = "CENSOS-AVES-2022.xlsx",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018/censos-aves-2022.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "bovinos",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2022,
         begin = 2022,
         end = 2022,
         archive = "CENSOS-BOVINOS-2022.xlsx",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018/censos-bovinos-2022.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "bufalos",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2022,
         begin = 2022,
         end = 2022,
         archive = "CENSOS-BUFALOS-2022.xlsx",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018/censos-bufalos-2022.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "otras",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2022,
         begin = 2022,
         end = 2022,
         archive = "CENSOS-OTRAS-ESPECIES-2022.xlsx",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018/censos-otras-especies-2022-1.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "porcinos",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2022,
         begin = 2022,
         end = 2022,
         archive = "CENSOS-PORCINOS-2022.xlsx",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018/censo-porcinos-2022.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

### 2023 ----
regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "aves",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2023,
         begin = 2023,
         end = 2023,
         archive = "CENSOS-AVES-2023-Final.xls",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-aves-2023-final.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "bovinos",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2023,
         begin = 2023,
         end = 2023,
         archive = "CENSOS-BOVINOS-2023-Final.xls",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-bovinos-2023-final.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "bufalos",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2023,
         begin = 2023,
         end = 2023,
         archive = "CENSOS-BUFALOS-2023-Final.xls",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-bufalos-2023-final.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "caprinosOvinos",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2023,
         begin = 2023,
         end = 2023,
         archive = "CENSOS-CAPRINOS-Y-OVINOS-2023-Final.xls",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-caprinos-y-ovinos-2023-final.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "equinos",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2023,
         begin = 2023,
         end = 2023,
         archive = "CENSOS-EQUINOS-2023-Final.xls",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-equinos-2023-final.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "porcinos",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2023,
         begin = 2023,
         end = 2023,
         archive = "CENSOS-PORCINOS-2023-filtros-habilitados.xlsx",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/bol/epi/boletines-seccionales/2021-1/censo-porcinos-2023-filtros-habilitados.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

### 2024 ----
regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "bovinos",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2024,
         begin = 2024,
         end = 2024,
         archive = "CENSO-BOVINO-FINAL.xlsx",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/enfermedades-animales/fiebre-aftosa/censo-bovino-final.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "bufalos",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2024,
         begin = 2024,
         end = 2024,
         archive = "CENSO-BUFALINO-FINAL.xlsx",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/enfermedades-animales/fiebre-aftosa/censo-bufalino-final.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "caprinosOvinos",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2024,
         begin = 2024,
         end = 2024,
         archive = "censo-poblacion-ovina-por-municipio-y-departamento-2024_.xlsx",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/enfermedades-animales/fiebre-aftosa/censo-poblacion-ovina-por-municipio-y-departamento.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "porcinos",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2024,
         begin = 2024,
         end = 2024,
         archive = "CENSOS-PORCINOS-2024_FINAL.xlsx",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/enfermedades-animales/fiebre-aftosa/censos-porcinos-2024_final.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "aves",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2024,
         begin = 2024,
         end = 2024,
         archive = "TABLA-DE-POBLACION-AVIAR-2024_final.xlsx",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/enfermedades-animales/fiebre-aftosa/tabla-de-poblacion-aviar-2024_final.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM2",
         subset = "equina",
         dSeries = ds[2],
         gSeries = gs[1],
         schema = schema_livestock_ica_2024,
         begin = 2024,
         end = 2024,
         archive = "Tabla-de-poblacion-equina-por-municipio-y-departamento-2024-final.xlsx",
         archiveLink = "https://www.ica.gov.co/areas/pecuaria/servicios/enfermedades-animales/fiebre-aftosa/tabla-de-poblacion-equina-por-municipio-y-depa-1.aspx",
         downloadDate = ymd("2025-01-15"),
         updateFrequency = "annually",
         metadataLink = "https://www.ica.gov.co/areas/pecuaria/servicios/epidemiologia-veterinaria/censos-2016/censo-2018",
         metadataPath = "unknown",
         overwrite = TRUE)

normTable(pattern = ds[2],
          ontoMatch = "animal",
          beep = 10)
