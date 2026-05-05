# ----
# title       : build census database - ukrstat
# description : this script integrates data of 'State Statistics Service of Ukraine' (https://www.ukrstat.gov.ua/)
# license     : https://creativecommons.org/licenses/by-sa/4.0/
# authors     : Steffen Ehrmann
# date        : 2025-01-31
# version     : 0.3.0
# status      : work in progress [30%]
# notes       :
# ----
# geography   : Ukraine
# spatial     : ADM0, ADM1
# period      : 2003 - 2024 (ADM1), 1990 -  2020 (ADM0)
# sampling    : survey, census
# comment     : -
# ----

thisNation <- "Ukraine"
# source(paste0(db_path, "preprocess_ukrstat.R"))


# 1. dataseries ----
#
ds <- c("ukrstat")
gs <- c("hdx")

regDataseries(name = ds[1],
              description = "State Statistics Service of Ukraine",
              homepage = "https://www.ukrstat.gov.ua/",
              version = "2024.10",
              licence_link = licenses$cc0)


# 2. geometries ----
#
# https://data.humdata.org/dataset/cod-ab-ukr
regGeometry(ADM0 = !!thisNation,
            gSeries = gs[1],
            label = list(ADM0 = "ADM0_UA"),
            archive = "ukr_admbnd_sspe_20240416_ab_shp.zip|ukr_admbnda_adm0_sspe_20240416.shp",
            archiveLink = "https://data.humdata.org/dataset/d23f529f-31e4-4021-a65b-13987e5cfb42/resource/4105bb4d-5a9d-4824-a1d7-53141cf47c44/download/ukr_admbnd_sspe_20240416_ab_shp.zip",
            downloadDate = ymd("2025-01-27"),
            updateFrequency = "unknown")

regGeometry(ADM0 = !!thisNation,
            gSeries = gs[1],
            label = list(ADM0 = "ADM0_UA", ADM1 = "ADM1_UA"),
            archive = "ukr_admbnd_sspe_20240416_ab_shp.zip|ukr_admbnda_adm1_sspe_20240416.shp",
            archiveLink = "https://data.humdata.org/dataset/d23f529f-31e4-4021-a65b-13987e5cfb42/resource/4105bb4d-5a9d-4824-a1d7-53141cf47c44/download/ukr_admbnd_sspe_20240416_ab_shp.zip",
            downloadDate = ymd("2025-01-27"),
            updateFrequency = "unknown")

normGeometry(pattern = paste0(thisNation, ".*", gs[1]),
             beep = 10)


# 3. tables ----
#
schema_livestock_ukrstat_sheep <-
  setFilter(rows = c(1, 3), invert = TRUE) |>
  setFormat(decimal = ",") |>
  setIDVar(name = "ADM1", columns = 1) |>
  setIDVar(name = "method", value = "survey") |>
  setIDVar(name = "animal", columns = c(2, 4), rows = 2)  |>
  setObsVar(name = "number_heads", columns = c(2, 4), top = 3)

schema_livestock_ukrstat_sheep_2003 <- schema_livestock_ukrstat_sheep |>
  setIDVar(name = "year", value = "2003")

schema_livestock_ukrstat_sheep_2004 <- schema_livestock_ukrstat_sheep |>
  setIDVar(name = "year", value = "2004")

schema_livestock_ukrstat_sheep_2005 <- schema_livestock_ukrstat_sheep |>
  setIDVar(name = "year", value = "2005")

schema_livestock_ukrstat_sheep_2006 <- schema_livestock_ukrstat_sheep |>
  setIDVar(name = "year", value = "2006")

schema_livestock_ukrstat_sheep_2007 <- schema_livestock_ukrstat_sheep |>
  setIDVar(name = "year", value = "2007")

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "sheepGoatPoult",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ukrstat_sheep_2003,
         begin = 2003,
         end = 2003,
         archive = "Pok092003.htm",
         archiveLink = "https://www.ukrstat.gov.ua/operativ/operativ2003/sg/pok/pok_e/Pok092003.htm",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "annually",
         metadataLink = "https://www.ukrstat.gov.ua/metod_polog/titul_mps.html",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "sheepGoatPoult",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ukrstat_sheep_2004,
         begin = 2004,
         end = 2004,
         archive = "Pok0904.htm",
         archiveLink = "https://www.ukrstat.gov.ua/operativ/operativ2004/sg/pok/pok_e/Pok0904.htm",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "annually",
         metadataLink = "https://www.ukrstat.gov.ua/metod_polog/titul_mps.html",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "sheepGoatPoult",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ukrstat_sheep_2005,
         begin = 2005,
         end = 2005,
         archive = "pok0905_e.html",
         archiveLink = "https://www.ukrstat.gov.ua/operativ/operativ2005/sg/pok/pok_e/pok0905_e.html",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "annually",
         metadataLink = "https://www.ukrstat.gov.ua/metod_polog/titul_mps.html",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "sheepGoatPoult",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ukrstat_sheep_2006,
         begin = 2006,
         end = 2006,
         archive = "pok0906_e.html",
         archiveLink = "https://www.ukrstat.gov.ua/operativ/operativ2006/sg/pok/pok_e/pok0906_e.html",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "annually",
         metadataLink = "https://www.ukrstat.gov.ua/metod_polog/titul_mps.html",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "sheepGoatPoult",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ukrstat_sheep_2007,
         begin = 2007,
         end = 2007,
         archive = "pok0907_e.html",
         archiveLink = "https://www.ukrstat.gov.ua/operativ/operativ2007/sg/pok/pok_e/pok0907_e.html",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "annually",
         metadataLink = "https://www.ukrstat.gov.ua/metod_polog/titul_mps.html",
         metadataPath = "unknown",
         overwrite = TRUE)


schema_livestock_ukrstat_pig <-
  setFilter(rows = c(1, 3), invert = TRUE) |>
  setFormat(decimal = ",") |>
  setIDVar(name = "ADM1", columns = 1) |>
  setIDVar(name = "method", value = "survey") |>
  setIDVar(name = "animal", columns = c(2, 4, 6), rows = 2)  |>
  setObsVar(name = "number_heads", columns = c(2, 4, 6), top = 3)

schema_livestock_ukrstat_pig_2003 <- schema_livestock_ukrstat_pig |>
  setIDVar(name = "year", value = "2003")

schema_livestock_ukrstat_pig_2004 <- schema_livestock_ukrstat_pig |>
  setIDVar(name = "year", value = "2004")

schema_livestock_ukrstat_pig_2005 <- schema_livestock_ukrstat_pig |>
  setIDVar(name = "year", value = "2005")

schema_livestock_ukrstat_pig_2006 <- schema_livestock_ukrstat_pig |>
  setIDVar(name = "year", value = "2006")

schema_livestock_ukrstat_pig_2007 <- schema_livestock_ukrstat_pig |>
  setIDVar(name = "year", value = "2007")

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "cattlePig",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ukrstat_pig_2003,
         begin = 2003,
         end = 2003,
         archive = "Vrh092003.htm",
         archiveLink = "https://www.ukrstat.gov.ua/operativ/operativ2003/sg/vrh/vrh_e/Vrh092003.htm",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "annually",
         metadataLink = "https://www.ukrstat.gov.ua/metod_polog/titul_mps.html",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "cattlePig",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ukrstat_pig_2004,
         begin = 2004,
         end = 2004,
         archive = "Vrh0904.htm",
         archiveLink = "https://www.ukrstat.gov.ua/operativ/operativ2004/sg/vrh/vrh_e/Vrh0904.htm",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "annually",
         metadataLink = "https://www.ukrstat.gov.ua/metod_polog/titul_mps.html",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "cattlePig",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ukrstat_pig_2005,
         begin = 2005,
         end = 2005,
         archive = "vrh0905_e.html",
         archiveLink = "https://www.ukrstat.gov.ua/operativ/operativ2005/sg/vrh/vrh_e/vrh0905_e.html",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "annually",
         metadataLink = "https://www.ukrstat.gov.ua/metod_polog/titul_mps.html",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "cattlePig",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ukrstat_pig_2006,
         begin = 2006,
         end = 2006,
         archive = "vrh0906_e.html",
         archiveLink = "https://www.ukrstat.gov.ua/operativ/operativ2006/sg/vrh/vrh_e/vrh0906_e.html",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "annually",
         metadataLink = "https://www.ukrstat.gov.ua/metod_polog/titul_mps.html",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "cattlePig",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ukrstat_pig_2007,
         begin = 2007,
         end = 2007,
         archive = "vrh0907_e.html",
         archiveLink = "https://www.ukrstat.gov.ua/operativ/operativ2007/sg/vrh/vrh_e/vrh0907_e.html",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "annually",
         metadataLink = "https://www.ukrstat.gov.ua/metod_polog/titul_mps.html",
         metadataPath = "unknown",
         overwrite = TRUE)


schema_livestock_ukrstat_livestock <-
  setFilter(rows = c(1, 3), invert = TRUE) |>
  setFormat(decimal = ",") |>
  setIDVar(name = "ADM1", columns = 1) |>
  setIDVar(name = "year", columns = 1, rows = 1, split = "(\\d+)(?!.*\\d)") |>
  setIDVar(name = "method", value = "survey") |>
  setIDVar(name = "animal", columns = c(2, 4, 6), rows = 2)  |>
  setObsVar(name = "number_heads", columns = c(2, 4, 6), top = 3)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "livestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ukrstat_livestock,
         begin = 2008,
         end = 2008,
         archive = "php0908_e.html",
         archiveLink = "https://www.ukrstat.gov.ua/operativ/operativ2008/sg/sg_reg/php_reg/php_e/php0908_e.html",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "annually",
         metadataLink = "https://www.ukrstat.gov.ua/metod_polog/titul_mps.html",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "livestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ukrstat_livestock,
         begin = 2009,
         end = 2009,
         archive = "php0909_e.html",
         archiveLink = "https://www.ukrstat.gov.ua/operativ/operativ2009/sg/sg_reg/php_reg/php_e/php0909_e.html",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "annually",
         metadataLink = "https://www.ukrstat.gov.ua/metod_polog/titul_mps.html",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "livestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ukrstat_livestock,
         begin = 2010,
         end = 2010,
         archive = "php0910_e.html",
         archiveLink = "https://www.ukrstat.gov.ua/operativ/operativ2010/sg/sg_reg/php_reg/php_e/php0910_e.html",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "annually",
         metadataLink = "https://www.ukrstat.gov.ua/metod_polog/titul_mps.html",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "livestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ukrstat_livestock,
         begin = 2011,
         end = 2011,
         archive = "b_st_01_09_11.zip|b_st_01_09_11.pdf",
         archiveLink = "https://www.ukrstat.gov.ua/druk/katalog/selo/b_st_01_10_11.zip",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "annually",
         metadataLink = "https://www.ukrstat.gov.ua/metod_polog/titul_mps.html",
         metadataPath = "unknown",
         overwrite = TRUE,
         notes = "csv copied and checked from pdf")

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "livestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ukrstat_livestock,
         begin = 2012,
         end = 2012,
         archive = "bl_st_09_12.zip|bl_st_09_12.pdf",
         archiveLink = "https://www.ukrstat.gov.ua/druk/publicat/kat_u/2012/10_2012/bl_st_09_12.zip",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "annually",
         metadataLink = "https://www.ukrstat.gov.ua/metod_polog/titul_mps.html",
         metadataPath = "unknown",
         overwrite = TRUE,
         notes = "csv copied and checked from pdf")

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "livestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ukrstat_livestock,
         begin = 2013,
         end = 2013,
         archive = "bl_st_09_13.zip|bl_st_09_13.pdf",
         archiveLink = "https://www.ukrstat.gov.ua/druk/publicat/kat_u/2013/bl/10/bl_st_09_13.zip",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "annually",
         metadataLink = "https://www.ukrstat.gov.ua/metod_polog/titul_mps.html",
         metadataPath = "unknown",
         overwrite = TRUE,
         notes = "csv copied and checked from pdf")

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "livestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ukrstat_livestock,
         begin = 2014,
         end = 2014,
         archive = "st_09_14.xl.zip|st_09_14.xl.XLS",
         archiveLink = "https://www.ukrstat.gov.ua/druk/publicat/kat_u/2014/bl/10/st_09_14.xl.zip",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "annually",
         metadataLink = "https://www.ukrstat.gov.ua/metod_polog/titul_mps.html",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "livestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ukrstat_livestock,
         begin = 2015,
         end = 2015,
         archive = "bl_st15_xl.zip|bl_st15_xl.XLS",
         archiveLink = "https://www.ukrstat.gov.ua/druk/publicat/kat_u/2015/bl/10/bl_st15_xl.zip",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "annually",
         metadataLink = "https://www.ukrstat.gov.ua/metod_polog/titul_mps.html",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "livestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ukrstat_livestock,
         begin = 2016,
         end = 2016,
         archive = "bl_vptu0916xl.zip|bl_vptu0916.xls",
         archiveLink = "https://www.ukrstat.gov.ua/druk/publicat/kat_u/2016/bl/10/bl_vptu0916xl.zip",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "annually",
         metadataLink = "https://www.ukrstat.gov.ua/metod_polog/titul_mps.html",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "livestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ukrstat_livestock,
         begin = 2017,
         end = 2017,
         archive = "bl_vpt_10_2017_x.zip|bl_vpt_10_2017_x.xls",
         archiveLink = "https://www.ukrstat.gov.ua/druk/publicat/kat_u/2017/bl/10/bl_vpt_10_2017_x.zip",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "annually",
         metadataLink = "https://www.ukrstat.gov.ua/metod_polog/titul_mps.html",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "livestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ukrstat_livestock,
         begin = 2018,
         end = 2018,
         archive = "ksgt1018_xl.xls",
         archiveLink = "https://www.ukrstat.gov.ua/operativ/operativ2018/sg/ph/xls/ksgt1018_xl.xls",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "annually",
         metadataLink = "https://www.ukrstat.gov.ua/metod_polog/titul_mps.html",
         metadataPath = "unknown",
         overwrite = TRUE,
         notes = "Data exclude the temporarily occupied territory of the Autonomous Republic of Crimea, the city of Sevastopol and a part of temporarily occupied territories in the Donetsk and Luhansk regions.")

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "livestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ukrstat_livestock,
         begin = 2019,
         end = 2019,
         archive = "ksgt1019.xls",
         archiveLink = "https://www.ukrstat.gov.ua/operativ/operativ2019/sg/ksgt/ksgt1019.xls",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "annually",
         metadataLink = "https://www.ukrstat.gov.ua/metod_polog/titul_mps.html",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "livestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ukrstat_livestock,
         begin = 2020,
         end = 2020,
         archive = "ksgt1020.xls",
         archiveLink = "https://www.ukrstat.gov.ua/operativ/operativ2020/sg/ksgt/ksgt1020.xls",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "annually",
         metadataLink = "https://www.ukrstat.gov.ua/metod_polog/titul_mps.html",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "livestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ukrstat_livestock,
         begin = 2021,
         end = 2021,
         archive = "ksgt1021.xls",
         archiveLink = "https://www.ukrstat.gov.ua/operativ/operativ2021/sg/ksgt/ksgt1021.xls",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "annually",
         metadataLink = "https://www.ukrstat.gov.ua/metod_polog/titul_mps.html",
         metadataPath = "unknown",
         overwrite = TRUE)

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "livestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ukrstat_livestock,
         begin = 2022,
         end = 2022,
         archive = "ksgt0122.xls",
         archiveLink = "https://www.ukrstat.gov.ua/operativ/operativ2022/sg/ksgt/ksgt0122.xls",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "annually",
         metadataLink = "https://www.ukrstat.gov.ua/metod_polog/titul_mps.html",
         metadataPath = "unknown",
         overwrite = TRUE,
         notes = "only data for january available")

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "livestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ukrstat_livestock,
         begin = 2023,
         end = 2023,
         archive = "ksgt0123.xls",
         archiveLink = "https://www.ukrstat.gov.ua/operativ/operativ2023/sg/ksgt/ksgt0123.xls",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "annually",
         metadataLink = "https://www.ukrstat.gov.ua/metod_polog/titul_mps.html",
         metadataPath = "unknown",
         overwrite = TRUE,
         notes = "only data for january available")

regTable(ADM0 = !!thisNation,
         label = "ADM1",
         subset = "livestock",
         dSeries = ds[1],
         gSeries = gs[1],
         schema = schema_livestock_ukrstat_livestock,
         begin = 2024,
         end = 2024,
         archive = "ksgt0124.xls",
         archiveLink = "https://www.ukrstat.gov.ua/operativ/operativ2023/sg/ksgt/ksgt0124.xls",
         downloadDate = ymd("2025-01-17"),
         updateFrequency = "annually",
         metadataLink = "https://www.ukrstat.gov.ua/metod_polog/titul_mps.html",
         metadataPath = "unknown",
         overwrite = TRUE,
         notes = "only data for january available")

normTable(pattern = ds[1],
          ontoMatch = "animal",
          beep = 10)
