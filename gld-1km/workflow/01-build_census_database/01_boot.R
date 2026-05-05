# ----
# title       : build census database - boot software
# description : sets paths and initialises the arealDB database
# license     : https://creativecommons.org/licenses/by-sa/4.0/
# authors     : Steffen Ehrmann
# date        : 2026-05-03
# version     : 0.1.0
# status      : work in progress
# ntoes       :
# ----

# authors ----
#
model_version <- "0.8.3"
authors <- list(
  cre = list("Steffen Ehrmann"),
  aut = list(cens = c("Katya Perez Guzman")),
  ctb = list(onto = c("Nathália Monteiro Teles"),
             cens = c("Ivelina Georgieva"))
)

# initialise database ----
#
adb_init(root    = paste0(db_path, "_censusDB"),
         version = model_version,
         licence = "https://creativecommons.org/licenses/by-sa/4.0/",
         author  = list(cre = authors$cre,
                        aut = authors$aut$cens,
                        ctb = authors$ctb$cens),
         level   = c("ADM0", "ADM1", "ADM2"))
