# Code to prepare `IGC` datasets

usethis::use_data(IGC, overwrite = TRUE)
usethis::use_data(IGC_long, overwrite = TRUE)
usethis::use_data(IGC_long_phon, overwrite = TRUE)

# Dependencies
require(tidyverse)
require(readxl)
require(writexl)

# Data cleaning code
IGC <- read_excel("~/mi paquete de R/sunflower/dataframes/ANC_database_raw_NEW.xlsx") %>% dplyr::filter(test == "Gutiérrez-Cordero") %>% dplyr::filter(modality == "spoken")
IGC_long <- read_excel("~/mi paquete de R/sunflower/dataframes/dataframeWORK.xlsx") %>% dplyr::filter(test == "Gutiérrez-Cordero") %>% dplyr::filter(modality == "spoken")
IGC_long_phon <- read_excel("~/mi paquete de R/sunflower/dataframes/dataframeWORKphono.xlsx") %>% dplyr::filter(test == "Gutiérrez-Cordero") %>% dplyr::filter(modality == "spoken")

# Save xlsxs
write_xlsx(IGC, path = "IGC.xlsx")
write_xlsx(IGC_long, path = "IGC_long.xlsx")
write_xlsx(IGC_long_phon, path = "IGC_long_phon.xlsx")

# This should be the last line.
# Note that names are unquoted.
# I like using overwrite = T so everytime I run the script the
# updated objects are saved, but the default is overwrite = F
usethis::use_data(IGC, IGC, overwrite = T)
usethis::use_data(IGC_long, IGC_long, overwrite = T)
usethis::use_data(IGC_long_phon, IGC_long_phon, overwrite = T)

