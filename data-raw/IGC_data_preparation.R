rm(list = ls())

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
colnames(IGC_long_sample)

# sunflower --------------------------------------------------------------------

# For IGC
IGC_sample <- IGC %>%
  group_by(task_ID) %>%
  slice_sample(n = 9) %>%
  ungroup() %>%
  select(ID, task = task_ID, task_item_ID, item, response = final_response, correct, accessed)

#  View(IGC_sample)

# For IGC_long
IGC_long_sample <- IGC_long %>%
  mutate(Attempt = as.numeric(Attempt)) %>%  # Convertir Attempt a numérico
  group_by(task) %>%                     # Agrupar solo por task
  arrange(item_ID) %>%                   # Ordenar por item_ID
  slice_head(n = 25) %>%                 # Obtener las primeras 10 filas por task
  ungroup() %>%
  select(ID, task, item_ID, item, response = Response, accessed, RA, Attempt)

#  View(IGC_long_sample)

# For IGC_long_phon
IGC_long_phon_sample <- IGC_long_phon %>%
  mutate(Attempt = as.numeric(Attempt)) %>%  # Convertir Attempt a numérico
  group_by(task) %>%                     # Agrupar solo por task
  arrange(item_ID) %>%                   # Ordenar por item_ID
  slice_head(n = 25) %>%                 # Obtener las primeras 10 filas por task
  ungroup() %>%
  select(ID, task, item_ID, item, response, item_phon, response_phon, accessed, RA, Attempt)

#  View(IGC_long_phon_sample)

# Save xlsxs
write_xlsx(IGC_sample, path = "data-raw/IGC_sample.xlsx")
write_xlsx(IGC_long_sample, path = "data-raw/IGC_long_sample.xlsx")
write_xlsx(IGC_long_phon_sample, path = "data-raw/IGC_long_phon_sample.xlsx")

# Read xlsx to ensure clean dfs
IGC_sample <- read_xlsx("data-raw/IGC_sample.xlsx")
IGC_long_sample <- read_xlsx("data-raw/IGC_long_sample.xlsx")
IGC_long_phon_sample <- read_xlsx("data-raw/IGC_long_phon_sample.xlsx")

# Save read xlsxs as Rdas
save(IGC_sample, IGC_sample, IGC_sample, file = "data/IGC_sample.Rda")
save(IGC_long_sample, IGC_long_sample, IGC_long_sample, file = "data/IGC_long_sample.Rda")
save(IGC_long_phon_sample, IGC_long_phon_sample, IGC_long_phon_sample, file = "data/IGC_long_phon_sample.Rda")

# mine -------------------------------------------------------------------------

# For IGC
IGC <- IGC %>%
  group_by(task_ID) %>%
  #slice_sample(n = 9) %>%
  ungroup() %>%
  select(ID, task = task_ID, task_item_ID, item, response = final_response, correct, accessed)

#  View(IGC_sample)

# For IGC_long
IGC_long <- IGC_long %>%
  mutate(Attempt = as.numeric(Attempt)) %>%  # Convertir Attempt a numérico
  group_by(task) %>%                     # Agrupar solo por task
  arrange(item_ID) %>%                   # Ordenar por item_ID
  #slice_head(n = 25) %>%                 # Obtener las primeras 10 filas por task
  ungroup() %>%
  select(ID, task, item_ID, item, response = Response, RA, Attempt, accessed)

#  View(IGC_long_sample)

# For IGC_long_phon
IGC_long_phon <- IGC_long_phon %>%
  mutate(Attempt = as.numeric(Attempt)) %>%  # Convertir Attempt a numérico
  group_by(task) %>%                     # Agrupar solo por task
  arrange(item_ID) %>%                   # Ordenar por item_ID
  #slice_head(n = 25) %>%                 # Obtener las primeras 10 filas por task
  ungroup() %>%
  select(ID, task, item_ID, item, response, item_phon, response_phon, RA, Attempt, accessed)

#  View(IGC_long_phon_sample)

# Save xlsxs
write_xlsx(IGC, path = "data-raw/IGC.xlsx")
write_xlsx(IGC_long, path = "data-raw/IGC_long.xlsx")
write_xlsx(IGC_long_phon, path = "data-raw/IGC_long_phon.xlsx")

# Read xlsx to ensure clean dfs
IGC <- read_xlsx("data-raw/IGC.xlsx")
IGC_long <- read_xlsx("data-raw/IGC_long.xlsx")
IGC_long_phon <- read_xlsx("data-raw/IGC_long_phon.xlsx")

# Save read xlsxs as Rdas
save(IGC, IGC, IGC, file = "data/mine/IGC.Rda")
save(IGC_long, IGC_long, IGC_long, file = "data/mine/IGC_long.Rda")
save(IGC_long_phon, IGC_long_phon, IGC_long_phon, file = "data/mine/IGC_long_phon.Rda")

