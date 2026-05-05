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


# 3. tables ----
#
schema_nso <-
  setIDVar(name = "ADM1", columns = 1) |>
  setIDVar(name = "year",
           columns = .find(fun = is.numeric, row = 1, relative = TRUE),
           rows    = .find(row = 1, relative = TRUE)) |>
  setIDVar(name = "animal", columns = c(2:7), rows    = 1) |>
  setIDVar(name = "method", value = "census") |>
  setObsVar(name    = "number_heads", columns = c(2:7),
            factor  = 1000)   # NSO reports thousands of heads

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
         metadataLink    = "https://www.1212.mn/en/data-base/meta-data/questionnaire/24068263",
         downloadDate    = ymd("2026-05-04"),
         updateFrequency = "annually",
         overwrite       = TRUE)

normTable(pattern   = paste0("ADM1.*", ds[1]),
          ontoMatch = "animal",
          beep      = 10)



# =============================================================================
# 04_mongolia.R
# =============================================================================
# Mongolia livestock census — National Statistics Office (NSO, www.1212.mn)
# Geometry from GADM 4.1
#
# Administrative levels:
#   ADM0 = country (Mongolia)
#   ADM1 = aimag (province) — 21 aimags + Ulaanbaatar capital city
#   ADM2 = sum (district)
#
# NSO publishes annual livestock counts by aimag (and by sum at the finer level)
# from 1989 onwards. The traditional five livestock types ("tavan khoshuu mal")
# are: sheep, goats, cattle, horses, camels. NSO reports these plus minor
# categories. The schema below assumes the wide layout where animal types are
# spread across columns; verify the actual file layout before running.
#
# Author: Steffen Ehrmann
# =============================================================================



# Dataseries shorthand -------------------------------------------------------
# ds = table dataseries (statistical sources)
# gs = geometry dataseries (boundary providers)

# =============================================================================
# 1. DATASERIES
# =============================================================================
# regDataseries() is idempotent — if "gadm" was already registered for another
# country (Argentina, Brazil, ...) this call is a no-op. Same for "nso" if you
# happen to have used it before (unlikely).

# =============================================================================
# 2. GEOMETRIES — three administrative levels from GADM
# =============================================================================
# Place the GADM file in geometries/stage1/ before running.
# GADM ships gadm41_MNG.gpkg which contains layers for ADM_0 / ADM_1 / ADM_2.
# normGeometry() will (a) extract from the archive, (b) reproject to EPSG:4326
# if needed (GADM is already in 4326), (c) match names against the gazetteer,
# and (d) write one stage3 GeoPackage per top-level unit.

# =============================================================================
# 3. TABLES — NSO livestock counts
# =============================================================================
# NSO data portal: https://www2.1212.mn/Stat.aspx?LIST_ID=976_L10_1
# Series: "Number of livestock, by aimag and the Capital", annual, 1989–present
#
# Typical wide layout: one column per animal type, rows = aimags × years.
# Adjust the schema if the actual download is in long format or has multi-row
# headers. Use schema_builder() to verify column positions interactively.


# =============================================================================
# Verification
# =============================================================================
# After running, check the stage3 output:
#
#   readRDS(file.path(adb_path, "tables", "stage3", "Mongolia.rds")) |>
#     dplyr::glimpse()
#
# Expected columns include: ADM0, ADM1, year, animal, method, number_heads,
# plus arealDB bookkeeping columns (gazetteer_match, source_label, etc.).
#
# Common things to check:
#   • Aimag names — NSO may use Mongolian transliterations that differ from
#     GADM's NAME_1; unmatched names will open match_builder() interactively.
#   • Animal terms — "sheep", "goats", "cattle", "horses", "camels" should
#     match the GPW commodity ontology; check for typos / Mongolian terms.
#   • Year column — if the year is in the column header rather than a value
#     column, the .find() call above resolves it from row 1.
# =============================================================================
