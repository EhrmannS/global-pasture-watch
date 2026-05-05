
allInput <- list.files(paste0(db_path, "tables/stage2/"), pattern = "aves", full.names = TRUE)

for(i in seq_along(allInput)){

  thisName <- tail(str_split(allInput[i], "/")[[1]], 1)

  temp <- read_csv(file = allInput[i],
                   col_names = FALSE,
                   col_types = cols(.default = "c")) |>
    mutate(across(everything(), ~ str_to_title(.x))) |>
    mutate(across(everything(), ~ str_replace_all(.x, pattern = "(?<=\\S)-(?=\\S)|(?<=\\S)_(?=\\S)", " ")))

  write_csv(temp, allInput[i], na = "", col_names = FALSE)
}
