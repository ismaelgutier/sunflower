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

# Get column names
colnames(IGC)
colnames(IGC_long)
colnames(IGC_long_sampled)

# For IGC
IGC_sampled <- IGC %>%
  group_by(task_ID) %>%
  slice_sample(n = 9) %>%
  ungroup() %>%
  select(ID, task = task_ID, task_item_ID, item, response = final_response, correct, accessed)

# For IGC_long

IGC_long_sampled <- IGC_long %>%
  mutate(Attempt = as.numeric(Attempt)) %>%  # Convertir Attempt a numérico
  group_by(task) %>%                     # Agrupar solo por task
  arrange(item_ID) %>%                   # Ordenar por item_ID
  slice_head(n = 25) %>%                 # Obtener las primeras 10 filas por task
  ungroup() %>%
  select(ID, task, item_ID, item, response = Response, RA, Attempt)

  #View(IGC_long_sampled)

# For IGC_long_phon
IGC_long_phon_sampled <- IGC_long_phon %>%
  mutate(Attempt = as.numeric(Attempt)) %>%  # Convertir Attempt a numérico
  group_by(task) %>%                     # Agrupar solo por task
  arrange(item_ID) %>%                   # Ordenar por item_ID
  slice_head(n = 25) %>%                 # Obtener las primeras 10 filas por task
  ungroup() %>%
  select(ID, task, item_ID, item, response, item_phon, response_phon, RA, Attempt)

  #View(IGC_long_phon_sampled)

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

