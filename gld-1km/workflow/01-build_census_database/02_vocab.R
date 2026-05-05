# ----
# title       : build census database - vocabularies
# description : this script integrates a basic gazetteer from the UNSD geoscheme and a basic vocabulary from the GPW livestock ontology
# license     : https://creativecommons.org/licenses/by-sa/4.0/
# authors     : Steffen Ehrmann
# date        : 2026-05-03
# version     : 0.1.0
# status      : finished
# ntoes       :
# ----

# 1. gazetteer
#
regDataseries(name        = "unsd",
              description = "United Nations Statistics Division — M49 geoscheme",
              homepage    = "https://unstats.un.org/unsd/methodology/m49/",
              version     = "2024",
              licence_link = "https://www.un.org/en/about-us/terms-of-use")

schema_gazetteer_unsd <-
  setIDVar(name = "global",              columns = 2) |>
  setIDVar(name = "region",              columns = 4) |>
  setIDVar(name = "sub_region",          columns = 6) |>
  setObsVar(name = "ADM0",               columns = 9, type = "charcter")

regVocabulary(name         = "gazetteer",
              dSeries      = "unsd",
              description  = "UN M49 geoscheme",
              schema       = schema_gazetteer_unsd,
              archive      = "UNSD — Methodology.csv",
              archiveLink  = "https://unstats.un.org/unsd/methodology/m49/overview/",
              downloadDate = "2024-01-01",
              version      = "2024",
              licence_link = "https://www.un.org/en/about-us/terms-of-use",
              overwrite    = TRUE)

normVocabulary(pattern = "gazetteer__unsd")


# 2. vocabulary
#
regDataseries(name         = "gpw_onto",
              description  = "GPW livestock ontology",
              homepage     = "https://github.com/wri/global-pasture-watch",
              version      = "2.0.0",
              licence_link = "https://creativecommons.org/licenses/by-sa/4.0/")

schema_commodity_onto <-
  setIDVar(name = "class",        columns = 2) |>
  setIDVar(name = "parent_label", columns = 3) |>
  setObsVar(name = "label",       columns = 1, type = "character") |>
  setObsVar(name = "description", columns = 4, type = "character")

regVocabulary(name         = "animal",
              dSeries      = "gpw_onto",
              description  = "livestock commodity vocabulary derived from the LUCKINet land use ontology",
              schema       = schema_commodity_onto,
              archive      = "livestock.csv",
              archiveLink  = "https://zenodo.org/records/10867511",
              downloadDate = "2024-03-27",
              version      = "2.0.0",
              licence_link = "https://creativecommons.org/licenses/by-sa/4.0/",
              overwrite    = TRUE)

normVocabulary(pattern = "animal__gpw_onto")

