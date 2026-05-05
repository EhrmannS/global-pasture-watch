# ----
# title       : build census database - inei
# description : this script integrates data of 'Instituto Nacional de Estadística e Informática' (https://www.gob.pe/inei/)
# license     : https://creativecommons.org/licenses/by-sa/4.0/
# authors     : Steffen Ehrmann
# date        : 2025-01-31
# version     : 0.3.0
# status      : work in progress [30%]
# notes       :
# ----
# geography   : Peru
# spatial     : ADM0, ADM1
# period      : 2016 - 2023
# sampling    : survey, census
# comment     : -
# ----

thisNation <- "Peru"

# 1. dataseries ----
#
ds <- c("inei")
gs <- c("hdx")

regDataseries(name = ds[1],
              description = "Instituto Nacional de Estadística e Informática",
              homepage = "https://www.gob.pe/inei/",
              version = "2025.01",
              licence_link = "unknwon")



# 2. geometries ----
#
# https://data.humdata.org/dataset/cod-ab-per
regGeometry(ADM0 = !!thisNation,
            gSeries = gs[1],
            label = list(ADM0 = "ADM0_ES"),
            archive = "per_adm_ign_20200714_shp.zip|per_admbnda_adm0_ign_20200714.shp",
            archiveLink = "https://data.humdata.org/dataset/54fc7f4d-f4c0-4892-91f6-2fe7c1ecf363/resource/63cc642a-2957-4f25-8a17-086c99d275e8/download/per_adm_ign_20200714_shp.zip",
            downloadDate = ymd("2025-01-27"),
            updateFrequency = "unknown")

regGeometry(ADM0 = !!thisNation,
            gSeries = gs[1],
            label = list(ADM0 = "ADM0_ES", ADM1 = "ADM1_ES"),
            archive = "per_adm_ign_20200714_shp.zip|per_admbnda_adm1_ign_20200714.shp",
            archiveLink = "https://data.humdata.org/dataset/54fc7f4d-f4c0-4892-91f6-2fe7c1ecf363/resource/63cc642a-2957-4f25-8a17-086c99d275e8/download/per_adm_ign_20200714_shp.zip",
            downloadDate = ymd("2025-01-27"),
            updateFrequency = "unknown")

regGeometry(ADM0 = !!thisNation,
            gSeries = gs[1],
            label = list(ADM0 = "ADM0_ES", ADM1 = "ADM1_ES", ADM2 = "ADM2_ES"),
            archive = "per_adm_ign_20200714_shp.zip|per_admbnda_adm2_ign_20200714.shp",
            archiveLink = "https://data.humdata.org/dataset/54fc7f4d-f4c0-4892-91f6-2fe7c1ecf363/resource/63cc642a-2957-4f25-8a17-086c99d275e8/download/per_adm_ign_20200714_shp.zip",
            downloadDate = ymd("2025-01-27"),
            updateFrequency = "unknown")

normGeometry(pattern = paste0(thisNation, ".*", gs[1]),
             beep = 10)


# 3. tables ----
#
schema_livestock_inei <-
  setFormat(decimal = ",") |>
  setFilter(rows = .find(pattern = "unidades", invert = TRUE)) |>
  setIDVar(name = "ADM1", columns = 1) |>
  setIDVar(name = "year", columns = 1, rows = 1, split = "(\\d+)(?!.*\\d)") |>
  setIDVar(name = "method", value = "survey") |>
  setIDVar(name = "animal", columns = .find(fun = is.numeric, row = 5), rows = 4) |>
  setObsVar(name = "number_heads", columns = .find(fun = is.numeric, row = 5), top = 4)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "livestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_inei,
         begin = 2016,
         end = 2016,
         archive = "Cuadros en Excel del anuario _PRODUCCIÓN GANADERA Y AVÍCOLA_ 2016.xlsx",
         archiveLink = "https://cdn.www.gob.pe/uploads/document/file/2803278/Cuadros%20en%20Excel%20del%20anuario%20%22PRODUCCI%C3%93N%20GANADERA%20Y%20AV%C3%8DCOLA%22%202016.xlsx",
         downloadDate = ymd("2025-01-25"),
         updateFrequency = "annually",
         metadataLink = "https://www.gob.pe/institucion/midagri/informes-publicaciones/2730346-compendio-anual-de-produccion-ganadera-y-avicola",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "livestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_inei,
         begin = 2017,
         end = 2017,
         archive = "Cuadros en Excel del anuario _PRODUCCIÓN GANADERA Y AVÍCOLA_ 2017.xlsx",
         archiveLink = "https://cdn.www.gob.pe/uploads/document/file/2803276/Cuadros%20en%20Excel%20del%20anuario%20%22PRODUCCI%C3%93N%20GANADERA%20Y%20AV%C3%8DCOLA%22%202017.xlsx",
         downloadDate = ymd("2025-01-25"),
         updateFrequency = "annually",
         metadataLink = "https://www.gob.pe/institucion/midagri/informes-publicaciones/2730346-compendio-anual-de-produccion-ganadera-y-avicola",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "livestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_inei,
         begin = 2018,
         end = 2018,
         archive = "Cuadros en Excel del anuario _PRODUCCIÓN GANADERA Y AVÍCOLA_ 2018.xls",
         archiveLink = "https://cdn.www.gob.pe/uploads/document/file/2803274/Cuadros%20en%20Excel%20del%20anuario%20%22PRODUCCI%C3%93N%20GANADERA%20Y%20AV%C3%8DCOLA%22%202018.xls",
         downloadDate = ymd("2025-01-25"),
         updateFrequency = "annually",
         metadataLink = "https://www.gob.pe/institucion/midagri/informes-publicaciones/2730346-compendio-anual-de-produccion-ganadera-y-avicola",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "livestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_inei,
         begin = 2019,
         end = 2019,
         archive = "Cuadros en Excel del anuario _PRODUCCIÓN GANADERA Y AVÍCOLA_ 2019.xlsx",
         archiveLink = "https://cdn.www.gob.pe/uploads/document/file/2803272/Cuadros%20en%20Excel%20del%20anuario%20%22PRODUCCI%C3%93N%20GANADERA%20Y%20AV%C3%8DCOLA%22%202019.xlsx",
         downloadDate = ymd("2025-01-25"),
         updateFrequency = "annually",
         metadataLink = "https://www.gob.pe/institucion/midagri/informes-publicaciones/2730346-compendio-anual-de-produccion-ganadera-y-avicola",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "livestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_inei,
         begin = 2020,
         end = 2020,
         archive = "Cuadros en Excel del anuario _PRODUCCIÓN GANADERA Y AVÍCOLA_ 2020.xlsx",
         archiveLink = "https://cdn.www.gob.pe/uploads/document/file/2803270/Cuadros%20en%20Excel%20del%20anuario%20%22PRODUCCI%C3%93N%20GANADERA%20Y%20AV%C3%8DCOLA%22%202020.xlsx",
         downloadDate = ymd("2025-01-25"),
         updateFrequency = "annually",
         metadataLink = "https://www.gob.pe/institucion/midagri/informes-publicaciones/2730346-compendio-anual-de-produccion-ganadera-y-avicola",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "livestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_inei,
         begin = 2021,
         end = 2021,
         archive = "Cuadros en Excel del anuario _PRODUCCIÓN GANADERA Y AVÍCOLA_ 2021.xlsx",
         archiveLink = "https://cdn.www.gob.pe/uploads/document/file/3427795/Cuadros%20en%20Excel%20del%20anuario%20%22PRODUCCI%C3%93N%20GANADERA%20Y%20AV%C3%8DCOLA%22%202021.xlsx",
         downloadDate = ymd("2025-01-25"),
         updateFrequency = "annually",
         metadataLink = "https://www.gob.pe/institucion/midagri/informes-publicaciones/2730346-compendio-anual-de-produccion-ganadera-y-avicola",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "livestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_inei,
         begin = 2022,
         end = 2022,
         archive = "Cuadros en Excel del anuario _PRODUCCIÓN GANADERA Y AVÍCOLA_ 2022.xlsx",
         archiveLink = "https://cdn.www.gob.pe/uploads/document/file/4920793/Cuadros%20en%20Excel%20del%20anuario%20%22PRODUCCI%C3%93N%20GANADERA%20Y%20AV%C3%8DCOLA%22%202022.xlsx",
         downloadDate = ymd("2025-01-25"),
         updateFrequency = "annually",
         metadataLink = "https://www.gob.pe/institucion/midagri/informes-publicaciones/2730346-compendio-anual-de-produccion-ganadera-y-avicola",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "livestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_inei,
         begin = 2023,
         end = 2023,
         archive = "2730346-cuadros-en-excel-del-anuario-produccion-ganadera-y-avicola-2023.xlsx",
         archiveLink = "https://cdn.www.gob.pe/uploads/document/file/6837082/2730346-cuadros-en-excel-del-anuario-produccion-ganadera-y-avicola-2023.xlsx",
         downloadDate = ymd("2025-01-25"),
         updateFrequency = "annually",
         metadataLink = "https://www.gob.pe/institucion/midagri/informes-publicaciones/2730346-compendio-anual-de-produccion-ganadera-y-avicola",
         metadataPath = "unknown",
         overwrite = TRUE)

normTable(pattern = ds[1],
          ontoMatch = "animal",
          beep = 10)
