
allInput <- list.files(paste0(db_path, "tables/stage2/"), pattern = "genesis", full.names = TRUE)

for(i in seq_along(allInput)){

  temp <- read_csv(file = allInput[i],
                   col_names = FALSE,
                   col_types = cols(.default = "c"),
                   trim_ws = FALSE)

  temp <- temp |>
    mutate(adm1 = str_split_i(X3, pattern = "  ", i = 2),
           adm1 = if_else(adm1 == "", NA, adm1),
           adm2 = str_split_i(X3, pattern = "      ", i = 2),
           adm2 = str_replace_all(adm2, ", Landkreis|, Kreis|, kreisfreie Stadt|, Landeshauptstadt|, Hansestadt|, Stadtkreis|, Wissenschaftsstadt|, documenta-Stadt|,  kreisfreie Stadt", ""),
           .after = X3)

  # write_csv(temp, allInput[i], na = "", col_names = FALSE)

}
