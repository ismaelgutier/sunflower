# Code to prepare sunflower datasets

# Load required libraries
require(tidyverse)
require(readxl)
require(writexl)
require(here)
require(usethis)

# Set working directory
here()

# Data cleaning code
BPAL_freq <- read_excel(here("data-raw/bpal_freq.xlsx"))
RAE_wordlist <- readLines(here("data-raw/0_palabras_todas_no_conjugaciones.txt"))

# Read and filter datasets
IGC <- read_excel("~/mi paquete de R/sunflower/dataframes/ANC_database_raw_NEW.xlsx") %>%
  dplyr::filter(test %in% c("Gutiérrez-Cordero", "SnodgrassVanderwart")) %>%
  dplyr::filter(modality == "spoken")

IGC_long <- read_excel("~/mi paquete de R/sunflower/dataframes/dataframeWORK.xlsx") %>%
  dplyr::filter(test %in% c("Gutiérrez-Cordero", "SnodgrassVanderwart")) %>%
  dplyr::filter(modality == "spoken")

IGC_long_phon <- read_excel("~/mi paquete de R/sunflower/dataframes/dataframeWORKphono.xlsx") %>%
  dplyr::filter(test %in% c("Gutiérrez-Cordero", "SnodgrassVanderwart")) %>%
  dplyr::filter(modality == "spoken")

# Save datasets as xlsx files
write_xlsx(IGC, path = "data-raw/IGC.xlsx")
write_xlsx(IGC_long, path = "data-raw/IGC_long.xlsx")
write_xlsx(IGC_long_phon, path = "data-raw/IGC_long_phon.xlsx")

# Save datasets for use in the package
usethis::use_data(BPAL_freq, overwrite = TRUE)
usethis::use_data(RAE_wordlist, overwrite = TRUE)
usethis::use_data(IGC, overwrite = TRUE)
usethis::use_data(IGC_long, overwrite = TRUE)
usethis::use_data(IGC_long_phon, overwrite = TRUE)
