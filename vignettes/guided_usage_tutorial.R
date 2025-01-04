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
dataframe0 = sunflower::IGC_long_phon_sample

# Data wrangling: Separate responses
dataframe1 =  dataframe0 %>% separate_responses(col_name = "response", separate_with = ", ")

# Extract attempts and clean blank spaces
dataframe2 = dataframe1 %>% get_attempts(drop_blank_spaces = T)

View(dataframe2)

# Calculate formal similarity
dataframe3 = dataframe2 %>%
              get_formal_similarity(item_col = "item",
                                     response_col = "response",
                                     attempt_col = "attempt",
                                     group_cols = c("ID", "item_ID", "item")
                                     )

View(dataframe3)

# Calculate positional accuracy
dataframe3.1 = dataframe3 %>% positional_accuracy(item_col = "item",
                                                  response_col = "response",
                                                  match_col = "adj_strict_match_pos")

# Check lexicality

  # this procedure might take more or less time depending on the number of rows
  {
    total_time_ms = 14.580
    num_items = 1529
    time_per_item_ms = round((total_time_ms / num_items) * 1000, 2)
    print(paste(time_per_item_ms, "ms per row"))
  }

dataframe4 = dataframe3 %>% check_lexicality(item_col = "item",
                                            response_col = "response",
                                            criterion = "dictionary")


# Load a pre-trained word2vec model (using file selection dialog)

  # locate the word2vec model file on your computer before proceeding
  # ensure that the dependency bundle has been downloaded and
  # all files have been extracted to a folder in your system

model = word2vec::read.word2vec(file = file.choose(), normalize = F)

# Calculate semantic similarity
dataframe5 = dataframe4 %>% get_semantic_similarity(item_col = "item",
                                                response_col = "response",
                                                model = model)

# Classify errors
dataframe6a <- dataframe5 %>%
                        dplyr::select(-correct) %>%
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
  #dplyr::mutate(accessed = ifelse(item == response, 1, 0)) %>%
  classify_errors_regular(access_col = "correct",
                          response_col = "response",
                          item_col = "item",
                          cosine_limit_value = 0.46)
View(dataframe6b)

# As can be noted, we can work stepwise,
# saving the results of each individual procedure in a new dataframe
# but we can also working stacking functions thansk to tidyverse

dataframe6c = dataframe0 %>%
  separate_responses(col_name = "response", separate_with = ", ") %>%
  get_attempts(first_production = attempt_1, drop_blank_spaces = T) %>%
  get_formal_similarity(item_col = "item",
                        response_col = "response",
                        attempt_col = "attempt",
                        group_cols = c("ID", "item_ID", "item")) %>%
  check_lexicality(item_col = "item",
                     response_col = "response",
                     criterion = "dictionary") %>%
  get_semantic_similarity(item_col = "item",
                            response_col = "response",
                            model = model) %>%
  dplyr::select(-correct) %>%
  dplyr::mutate(accessed = ifelse(item == response, 1, 0)) %>%
  classify_errors(access_col = "accessed",
                  RA_col = "RA",
                  response_col = "response",
                  item_col = "item",
                  also_classify_RAs = TRUE,
                  cosine_limit_value = 0.46)
