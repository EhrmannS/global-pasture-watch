# ----
# title       : build census database - nso
# description : this script integrates data of 'National Statistics Office of Mongolia' (https://www.1212.mn/en)
# license     : https://creativecommons.org/licenses/by-sa/4.0/
# authors     : Steffen Ehrmann
# date        : 2026-05-04
# version     : 0.1.0
# status      : work in progress [%], finished
# notes       :
# ----
# geography   : Mongolia
# spatial     : ADM0, ADM1
# period      : 1989 - 2024
# sampling    : survey, census
# comment     :
# ----

thisNation <- "Mongolia"

# 1. dataseries ----
#
ds <- c("nso")
gs <- c("gadm")

regDataseries(name         = gs[1],
              description  = "GADM database of Global Administrative Areas",
              homepage     = "https://gadm.org",
              version      = "4.1",
              licence_link = "https://gadm.org/license.html")

regDataseries(name         = ds[1],
              description  = "National Statistics Office of Mongolia",
              homepage     = "https://www.1212.mn/en",
              version      = "2026.04",
              licence_link = "https://www.1212.mn/en/about-us")


# 2. geometries ----
#
regGeometry(ADM0            = !!thisNation,
            gSeries         = gs[1],
            label           = list(ADM0 = "COUNTRY"),
            archive         = "gadm41_MNG.gpkg",
            archiveLink     = "https://geodata.ucdavis.edu/gadm/gadm4.1/gpkg/gadm41_MNG.gpkg",
            downloadDate    = ymd("2026-05-04"),
            updateFrequency = "asNeeded")

regGeometry(ADM0            = !!thisNation,
            gSeries         = gs[1],
            label           = list(ADM0 = "COUNTRY", ADM1 = "NAME_1"),
            archive         = "gadm41_MNG.gpkg",
            archiveLink     = "https://geodata.ucdavis.edu/gadm/gadm4.1/gpkg/gadm41_MNG.gpkg",
            downloadDate    = ymd("2026-05-04"),
            updateFrequency = "asNeeded")

regGeometry(ADM0            = !!thisNation,
            gSeries         = gs[1],
            label           = list(ADM0 = "COUNTRY", ADM1 = "NAME_1", ADM2 = "NAME_2"),
            archive         = "gadm41_MNG.gpkg",
            archiveLink     = "https://geodata.ucdavis.edu/gadm/gadm4.1/gpkg/gadm41_MNG.gpkg",
            downloadDate    = ymd("2026-05-04"),
            updateFrequency = "asNeeded")

normGeometry(pattern = gs[1], beep = 10)
# this will open the shiny app "match_builder" that helps you find the right matches. Click on "Show all (including resolved)" to get the full picture


# 3. tables ----
#
schema_nso <-
  setFilter(rows = .find(pattern = "^Total$", col = 2, invert = TRUE)) |>
  setFilter(rows = .find(pattern = "^    \\S", col = 2, invert = TRUE)) |>  # drop region rows too
  setFormat(na_values = c("", "NA"), decimal = ",") |>
  setIDVar(name = "animal",  columns = 1) |>
  setIDVar(name = "ADM0",    value = thisNation) |>
  setIDVar(name = "ADM1",    columns = 2, split = "^            (\\S.*?)\\s*$") |>
  setIDVar(name = "year",    columns = .find(fun = is.numeric, row = 2), rows = 2) |>
  setIDVar(name = "method",  value = "census") |>
  setObsVar(name = "number_heads", columns = .find(fun = is.numeric, row = 2), factor = 1000)

regTable(ADM0            = !!thisNation,
         label           = "ADM1",
         subset          = "alllivestock",   # no underscores in subset
         dSeries         = ds[1],
         gSeries         = gs[1],
         schema          = schema_nso,
         begin           = 1989,
         end             = 2024,
         archive         = "NUMBER OF LIVESTOCK, by type of livestock, aimags and the Capital, and by year_2026-05-05_0003.xlsx",
         archiveLink     = "https://www.1212.mn/en/statcate/table-view/Regional%20development/Livestock/DT_NSO_1001_109V1.px",
         downloadDate    = ymd("2026-05-04"),
         updateFrequency = "annually",
         overwrite       = TRUE)

normTable(pattern   = paste0("ADM1.*", ds[1]),
          ontoMatch = "animal",
          beep      = 10)


# building and debugging schemas

# instead of read_csv, we can also use read_xlsx in the readxl package
# input <- readxl::read_xlsx(
#   path      = paste0(db_path, "_censusDB/tables/stage1/nso/NUMBER OF LIVESTOCK, by type of livestock, aimags and the Capital, and by year_2026-05-05_0003.xlsx"),
#   col_names = FALSE,
#   col_types = "text"
# )
input <- read.csv(file = paste0(db_path, "_censusDB/tables/stage2/Mongolia_ADM2_alllivestock_1989_2024_nso.csv"), header = FALSE, strip.white = FALSE, as.is = TRUE, colClasses = "character", encoding = "UTF-8") %>%
  as_tibble() %>%
  mutate(across(where(is.character), ~na_if(x = ., y = "")))

# schema_nso <- schema_builder(input)
# you need to set up a function to filter out all rows that are not ADM2 territories and everything is as in the demonstration.

schema_nso <-
  setFilter(rows = .find(pattern = "^Total$", col = 1, invert = TRUE)) |>
  setFormat(na_values = c("", "NA"), decimal = ",") |>
  setIDVar(name = "animal",  columns = 1) |>
  setIDVar(name = "ADM0",    value = thisNation) |>
  setIDVar(name = "ADM1",    columns = 2, split = "^    (\\S.*?)\\s*$") |>
  setIDVar(name = "ADM2",    columns = 2, split = "^            (\\S.*?)\\s*$") |>
  setIDVar(name = "year",    columns = .find(fun = is.numeric, row = 2), rows = 2) |>
  setIDVar(name = "method",  value = "census") |>
  setObsVar(name = "number_heads", columns = .find(fun = is.numeric, row = 2), factor = 1000)

output <- reorganise(input = input, schema = schema_nso)
