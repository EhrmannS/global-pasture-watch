# ----
# title       : build census database - ibge, mapb
# description : this script integrates data of 'Instituto Brasileiro de Geografia e Estatistica' (https://sidra.ibge.gov.br), 'MapBiomas' (https://mapbiomas.org/)
# license     : https://creativecommons.org/licenses/by-sa/4.0/
# authors     : Steffen Ehrmann
# date        : 2025-01-31
# version     : 1.0.0
# status      : done
# notes       :
# ----
# geography   : Brazil
# spatial     : ADM0, ADM1, ADM2
# period      : (1974)1990 - 2022
# sampling    : survey, census
# comment     : -
# ----

thisNation <- "Brazil"

ds <- c("ibge", "mapb")
gs <- c("ibge")


# 1. dataseries ----
#
regDataseries(name = ds[1],
              description = "Instituto Brasileiro de Geografia e Estatistica",
              version = "2023.12.14",
              homepage = "https://sidra.ibge.gov.br",
              licence_link = "unknown")

regDataseries(name = ds[2],
              description = "MapBiomas",
              version = "2023.12.14",
              homepage = "https://mapbiomas.org/",
              licence_link = "unknown")


# 2. geometries ----
#
regGeometry(ADM0 = !!thisNation,
            gSeries = gs[1],
            label = list(ADM1 = "NM_ESTADO"),
            archive = "br_unidades_da_federacao.zip|BRUFE250GC_SIR.shp",
            archiveLink = "https://mapas.ibge.gov.br/bases-e-referenciais/bases-cartograficas/malhas-digitais",
            downloadDate = ymd("2019-10-10"),
            updateFrequency = "notPlanned")

regGeometry(ADM0 = !!thisNation,
            gSeries = gs[1],
            label = list(ADM2 = "NM_MUNICIP"),
            archive = "br_municipios.zip|BRMUE250GC_SIR.shp",
            archiveLink = "https://mapas.ibge.gov.br/bases-e-referenciais/bases-cartograficas/malhas-digitais",
            downloadDate = ymd("2019-10-10"),
            updateFrequency = "notPlanned")

normGeometry(pattern = gs[1],
             beep = 10)

# 3. tables ----
#
schema_ibge <-
  setFormat(na_values = c("...", "-")) |>
  setFilter(rows = c(1:3), invert = TRUE) |>
  setIDVar(name = "ADM1", columns = 1, split = "((?<=\\().*(?=\\)))") |>
  setIDVar(name = "ADM2", columns = 1, split = "(^.*?(?=\\s\\())") |>
  setIDVar(name = "year", columns = 3) |>
  setIDVar(name = "method", value = "survey") |>
  setIDVar(name = "animal", columns = 2) |>
  setObsVar(name = "number_heads", columns = 4)

regTable(ADM0 = !!thisNation,
         subset = "bovino",
         label = "ADM2",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_ibge,
         begin = 1990,
         end = 2022,
         archive = "tabela3939_bovino.csv",
         archiveLink = "https://sidra.ibge.gov.br/tabela/3939",
         downloadDate = ymd("2014-07-02"),
         updateFrequency = "annually",
         metadataLink = "https://metadados.ibge.gov.br/consulta/estatisticos/operacoes-estatisticas/PA",
         metadataPath = "unavailable",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         subset = "bubalino",
         label = "ADM2",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_ibge,
         begin = 1990,
         end = 2022,
         archive = "tabela3939_bubalino.csv",
         archiveLink = "https://sidra.ibge.gov.br/tabela/3939",
         downloadDate = ymd("2014-07-02"),
         updateFrequency = "annually",
         metadataLink = "https://metadados.ibge.gov.br/consulta/estatisticos/operacoes-estatisticas/PA",
         metadataPath = "unavailable",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         subset = "equino",
         label = "ADM2",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_ibge,
         begin = 1990,
         end = 2022,
         archive = "tabela3939_equino.csv",
         archiveLink = "https://sidra.ibge.gov.br/tabela/3939",
         downloadDate = ymd("2014-07-02"),
         updateFrequency = "annually",
         metadataLink = "https://metadados.ibge.gov.br/consulta/estatisticos/operacoes-estatisticas/PA",
         metadataPath = "unavailable",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         subset = "suino",
         label = "ADM2",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_ibge,
         begin = 1990,
         end = 2022,
         archive = "tabela3939_suino.csv",
         archiveLink = "https://sidra.ibge.gov.br/tabela/3939",
         downloadDate = ymd("2014-07-02"),
         updateFrequency = "annually",
         metadataLink = "https://metadados.ibge.gov.br/consulta/estatisticos/operacoes-estatisticas/PA",
         metadataPath = "unavailable",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         subset = "caprino",
         label = "ADM2",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_ibge,
         begin = 1990,
         end = 2022,
         archive = "tabela3939_caprino.csv",
         archiveLink = "https://sidra.ibge.gov.br/tabela/3939",
         downloadDate = ymd("2014-07-02"),
         updateFrequency = "annually",
         metadataLink = "https://metadados.ibge.gov.br/consulta/estatisticos/operacoes-estatisticas/PA",
         metadataPath = "unavailable",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         subset = "ovino",
         label = "ADM2",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_ibge,
         begin = 1990,
         end = 2022,
         archive = "tabela3939_ovino.csv",
         archiveLink = "https://sidra.ibge.gov.br/tabela/3939",
         downloadDate = ymd("2014-07-02"),
         updateFrequency = "annually",
         metadataLink = "https://metadados.ibge.gov.br/consulta/estatisticos/operacoes-estatisticas/PA",
         metadataPath = "unavailable",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         subset = "galinaceos",
         label = "ADM2",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_ibge,
         begin = 1990,
         end = 2022,
         archive = "tabela3939_galinaceos.csv",
         archiveLink = "https://sidra.ibge.gov.br/tabela/3939",
         downloadDate = ymd("2014-07-02"),
         updateFrequency = "annually",
         metadataLink = "https://metadados.ibge.gov.br/consulta/estatisticos/operacoes-estatisticas/PA",
         metadataPath = "unavailable",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         subset = "codornas",
         label = "ADM2",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_ibge,
         begin = 1990,
         end = 2022,
         archive = "tabela3939_codornas.csv",
         archiveLink = "https://sidra.ibge.gov.br/tabela/3939",
         downloadDate = ymd("2014-07-02"),
         updateFrequency = "annually",
         metadataLink = "https://metadados.ibge.gov.br/consulta/estatisticos/operacoes-estatisticas/PA",
         metadataPath = "unavailable",
         overwrite = TRUE)

normTable(pattern = ds[1],
          ontoMatch = "animal",
          beep = 10)
