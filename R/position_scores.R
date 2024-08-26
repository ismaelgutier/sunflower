#' @name position_scores
#'
#' @title Split Strings into Columns and Transform to Long Format
#'
#' @description This function splits strings in a specified column of a data frame into individual characters, creates separate columns for each character position, and then transforms the data from wide to long format. Useful for analyzing character-level data or responses.
#' @param df A data frame containing the column to be split and transformed.
#' @param match_col The name of the column in the data frame to be split into multiple columns.
#' @param last_ID_col The name of the last column in the original data frame that should be included in the final output. Columns after this will be split into separate columns and included in the long format.
#' @returns A data frame in long format with the original data and the new columns for character positions.
#'
#' @examples
#'
#' data("IGC_long")
#'
#' result <- get_formal_metrics(df = IGC_long,
#'                                 item_col = "item",
#'                                 response_col = "Response",
#'                                 attempt_col = "Attempt",
#'                                 group_cols = c("ID", "item_ID"))
#'
#' result_positions <- result %>% position_scores(match_col = "itemL_adj_strict_match_pos",
#'                                               last_ID_col = "targetL")
#' print(result_positions)
#'
#' @export
#'
position_scores <- function(df, match_col, last_ID_col) {
# Extract the column of interest
strings <- df[[match_col]]

# Split each string into a list of vectors
split_strings <- stringr::str_split(strings, "", simplify = FALSE)

# Find the maximum number of characters in the strings
max_length <- max(purrr::map_int(split_strings, length))

# Create a data frame with the separated columns
split_df <- purrr::map_dfc(seq_len(max_length), function(i) {
  purrr::map_chr(split_strings, function(s) {
    if (i <= length(s)) s[i] else NA_character_
  })
})

# Rename the columns
colnames(split_df) <- paste0("x", seq_len(max_length))

# Join the original data frame with the separated data frame
df_separated <- df %>%
  dplyr::bind_cols(split_df)

# Determine the columns up to the last defined column
col_names <- colnames(df_separated)
last_ID_index <- match(last_ID_col, col_names)

if (is.na(last_ID_index)) {
  stop("The name of the last defined column was not found in the dataframe.")
}

# Select columns up to the defined column and add the x1, x2, ...
selected_cols <- col_names[1:last_ID_index]
selected_cols <- c(selected_cols, paste0("x", seq_len(max_length)))

# Transform to long format and apply filters
df_long <- df_separated %>%
  # Select identifier columns and x1, x2, x3, etc.
  dplyr::select(tidyselect::all_of(selected_cols)) %>%
  # Transform to long format
  tidyr::pivot_longer(cols = tidyselect::starts_with("x"), names_to = "Position", values_to = "correct_pos", names_repair = "minimal") %>%
  # Rename 'Position' column by removing the 'x' prefix
  dplyr::mutate(Position = stringr::str_remove(Position, "^x")) %>%
  # Filter rows where x1 has NA (keep those rows)
  dplyr::filter(!is.na(correct_pos) | Position == "1") %>%
  # Remove rows where all columns from x2 onward are NA
  dplyr::group_by(across(tidyselect::starts_with("test")), across(tidyselect::starts_with("task")), across(tidyselect::starts_with("ID")),
                  across(tidyselect::starts_with("item_ID")), across(tidyselect::starts_with("item")), across(tidyselect::starts_with("item_phon")),
                  across(tidyselect::starts_with("RA")), across(tidyselect::starts_with("Attempt")), across(tidyselect::starts_with("Response")),
                  across(tidyselect::starts_with("response_phon"))) %>%
  dplyr::filter(!all(is.na(correct_pos) & Position != "1")) %>%
  dplyr::ungroup()

return(df_long)
}

