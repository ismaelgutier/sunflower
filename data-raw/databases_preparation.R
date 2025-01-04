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
IGC_sample <- read_excel("~/mi paquete de R/sunflower/dataframes/ANC_database_raw_NEW.xlsx") %>%
  dplyr::filter(test != "Gutiérrez-Cordero") %>%
  dplyr::filter(!grepl("Token", task_ID)) %>%
  dplyr::filter(!grepl("WAB", task_ID)) %>%
  dplyr::filter(modality == "spoken")  %>%
  dplyr::filter(!grepl("nonword", task_type)) %>%
  dplyr::filter(task_modality %in% c("repetition", "naming")) %>%
  select(ID, task = task_ID, item_ID = task_item_ID, item, response = final_response, correct, accessed)

IGC_long_sample <- read_excel("~/mi paquete de R/sunflower/dataframes/dataframeWORK.xlsx") %>%
  dplyr::filter(test != "Gutiérrez-Cordero") %>%
  dplyr::filter(!grepl("WAB", test)) %>%
  dplyr::filter(!grepl("Token", test)) %>%
  dplyr::filter(modality == "spoken")  %>%
  dplyr::filter(!grepl("nonword", task_type)) %>%
  dplyr::filter(task_modality %in% c("repetition", "naming")) %>%
  select(ID, task, item_ID, item, response = Response, accessed, RA, attempt = Attempt)

IGC_long_phon_sample <- read_excel("~/mi paquete de R/sunflower/dataframes/dataframeWORKphono.xlsx") %>%
  dplyr::filter(test != "Gutiérrez-Cordero") %>%
  dplyr::filter(!grepl("WAB", test)) %>%
  dplyr::filter(!grepl("Token", test)) %>%
  dplyr::filter(modality == "spoken")  %>%
  dplyr::filter(!grepl("nonword", task_type)) %>%
  dplyr::filter(task_modality %in% c("repetition", "naming")) %>%
  select(ID, task, item_ID, item, response, item_phon, response_phon, accessed, RA, attempt = Attempt)

# Save datasets as xlsx files
write_xlsx(IGC_sample, path = "C:/Users/Maria/Desktop/sunflower 2025/data-raw/IGC_sample.xlsx")
write_xlsx(IGC_long_sample, path = "C:/Users/Maria/Desktop/sunflower 2025/data-raw/IGC_long_sample.xlsx")
write_xlsx(IGC_long_phon_sample, path = "C:/Users/Maria/Desktop/sunflower 2025/data-raw/IGC_long_phon_sample.xlsx")

# Save datasets for use in the package
usethis::use_data(BPAL_freq, overwrite = TRUE)
usethis::use_data(RAE_wordlist, overwrite = TRUE)
usethis::use_data(IGC_sample, overwrite = TRUE)
usethis::use_data(IGC_long_sample, overwrite = TRUE)
usethis::use_data(IGC_long_phon_sample, overwrite = TRUE)

