allInput <- list.files(paste0(db_path, "tables/stage1/siip/"), full.names = TRUE)
allInput <- allInput[!str_detect(allInput, "avicola")]

# store files with good name ----
#
for(i in seq_along(allInput)){

  tempData <- html_table(x = read_html(x = allInput[i]))[[1]]
  tempData[[2]] <- str_replace_all(string = tempData[[2]], pattern = "[.]", replacement = "")

  tempName <- tail(str_split(allInput[i], "/")[[1]], 1)
  tempName <- str_split(tempName, "[.]")[[1]][1]
  newName <- str_split(tempName, "-|_")[[1]]
  newName <- paste0("Bolivia_ADM3_", newName[3], str_to_title(newName[2]), "_", newName[1], "_", newName[1], "_siip")

  write_delim(x = tempData, file = paste0(db_path, "tables/stage2/", newName, ".csv"), delim = ",", na = "", col_names = FALSE)

}
