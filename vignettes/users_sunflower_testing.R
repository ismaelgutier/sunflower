# Clear the workspace and unload all loaded packages
rm(list = ls())
invisible(lapply(paste("package:", names(sessionInfo()$otherPkgs), sep = ""),
                 detach, character.only = TRUE, unload = TRUE))

# 1. Install the devtools package (if not already installed)
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}
library(devtools)

# 2. Install RTools on Windows (if using Windows)
# Visit: https://cran.rstudio.com/bin/windows/Rtools/ for installation.
# Not needed on macOS or Linux.

# Possible dependencies 1: Install additional packages (tidyverse, htmlTable, knitr, if needed)
possible_dependencies <- c("tidyverse", "htmlTable", "knitr")
for (pkg in possible_dependencies) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
}

# Possible dependencies 2: Install the xfun package from source (only if necessary)
if (!requireNamespace("xfun", quietly = TRUE)) {
  install.packages("xfun", type = "source")
  # Alternatively, install from GitHub:
  # devtools::install_github("yihui/xfun")
}

# 3. Install the sunflower package from GitHub
if (!requireNamespace("sunflower", quietly = TRUE)) {
  devtools::install_github("ismaelgutier/sunflower")
}

# 4. Load all required packages
library(sunflower)
#library(tidyverse)
#library(htmlTable)
#library(knitr)

# Environment is now ready for analysis


# Load dataset
dataframe0 = sunflower::simulated_sample

# Data wrangling: Separate responses
dataframe1 = sunflower::separate_responses(dataframe0, 
                                           col_name = "response",
                                           separate_with = ", ")

dataframe1 = separate_responses(dataframe0, 
                                           col_name = "response",
                                           separate_with = ", ")

# Extract attempts and clean blank spaces
dataframe2 = sunflower::get_attempts(dataframe1, 
                                     first_production = attempt_1, 
                                     drop_blank_spaces = T) 

dataframe2 = get_attempts(dataframe1, 
                                     first_production = attempt_1, 
                                     drop_blank_spaces = T) 

# formal similarity
dataframe3 = sunflower::get_formal_similarity(dataframe2, 
                                              item_col = "item",
                                              response_col = "response",
                                              attempt_col = "attempt",
                                              group_cols = c("item_id"))

# Calculate formal similarity
dataframe3 = get_formal_similarity(dataframe2, 
                                              item_col = "item",
                                              response_col = "response",
                                              attempt_col = "attempt",
                                              group_cols = c("item_id"))

dataframe3 = dataframe2 %>% get_formal_similarity(item_col = "item",
                                   response_col = "response",
                                   attempt_col = "attempt",
                                   group_cols = c("item_id"))

# Calculate positional accuracy
dataframe3.1 = sunflower::positional_accuracy(dataframe3, item_col = "item", 
                                              response_col = "response",
                                              match_col = "adj_strict_match_pos")

dataframe3.1 = dataframe3 %>% positional_accuracy(item_col = "item", 
                                              response_col = "response",
                                              match_col = "adj_strict_match_pos")

# Check lexicality
dataframe4 = sunflower::check_lexicality(dataframe3, item_col = "item",
                                              response_col = "response",
                                              criterion = "dictionary")

# Load a pre-trained word2vec model (using file selection dialog)
model = word2vec::read.word2vec(file = file.choose(), normalize = F)

# Calculate semantic similarity
dataframe5 = sunflower::get_semantic_similarity(dataframe4, 
                                                item_col = "item",
                                                response_col = "response",
                                                model = model)

dataframe5 = dataframe4 %>% get_semantic_similarity(item_col = "item",
                                                response_col = "response",
                                                model = model)
# Classify errors
dataframe6a <- dataframe5 %>%
                        dplyr::mutate(accessed = ifelse(item == response, 1, 0)) %>%
                        classify_errors(access_col = "accessed", 
                                           RA_col = "RA",
                                           response_col = "response", 
                                           item_col = "item",
                                           also_classify_RAs = TRUE,
                                           cosine_limit_value = 0.46)
View(dataframe6a)

# Classify errors (function not considering RAs)
dataframe6b <- dataframe5 %>%
  dplyr::mutate(accessed = ifelse(item == response, 1, 0)) %>%
  classify_errors_regular(access_col = "accessed", 
                  response_col = "response", 
                  item_col = "item",
                  cosine_limit_value = 0.46)
View(dataframe6b)
