#' @name positional_accuracy
#'
#' @title Split Strings into Columns and Transform to Long Format
#'
#' @description This function splits strings in a specified column of a data frame into individual characters, creates separate columns for each character position, and then transforms the data from wide to long format. It also extracts the corresponding characters from specified item and response columns based on their positions. This is useful for analyzing character-level data or responses in a structured way.
#'
#' @param df A data frame containing the column to be split and transformed.
#' @param match_col The name of the column in the data frame to be split into multiple columns.
#' @param item_col The name of the column from which characters will be extracted based on their position.
#' @param response_col The name of the column from which characters will be extracted based on their position.
#'
#' @returns A data frame in long format with the original data and the new columns for character positions, as well as three additional columns:
#' \item{position}{The position of the character in the original string.}
#' \item{correct_pos}{The character from the match_col at the given position.}
#' \item{element_in_item}{The character from the item column corresponding to the character position. If the position exceeds the length of the item, it returns NA.}
#' \item{element_in_response}{The character from the response column corresponding to the character position. If the position exceeds the length of the response, it returns NA.}
#'
#' @examples
#' # Example Data Frame
#' df <- data.frame(
#'   itemL_adj_strict_match_pos = c("abc", "de", "fghij"),
#'   item = c("abcd", "efgh", "ijklm"),
#'   Response = c("ab", "d", "fghi"),
#'   stringsAsFactors = FALSE
#' )
#'
#' # Using the positional_accuracy function
#' result_positions <- positional_accuracy(df,
#'                                         match_col = "itemL_adj_strict_match_pos",
#'                                         item_col = "item",
#'                                         response_col = "Response")
#' print(result_positions)
#'
#' @export
positional_accuracy <- function(df, match_col, item_col, response_col) {
  # Ensure input columns are correctly referenced
  if (!all(c(match_col, item_col, response_col) %in% colnames(df))) {
    stop("One or more column names do not exist in the data frame.")
  }

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

  # Transform to long format and apply filters
  df_long <- df_separated %>%
    # Select all columns except those starting with 'x'
    dplyr::select(!tidyselect::starts_with("x")) %>%
    # Add back the 'x' columns
    dplyr::bind_cols(split_df) %>%
    # Transform to long format
    tidyr::pivot_longer(cols = tidyselect::starts_with("x"), names_to = "position", values_to = "correct_pos", names_repair = "minimal") %>%
    # Rename 'position' column by removing the 'x' prefix
    dplyr::mutate(position = as.numeric(stringr::str_remove(position, "^x"))) %>%
    # Filter rows where x1 has NA (keep those rows)
    dplyr::filter(!is.na(correct_pos) | position == 1) %>%
    # Remove rows where all columns from x2 onward are NA
    dplyr::group_by(across(!c(position, correct_pos))) %>%
    dplyr::filter(!all(is.na(correct_pos) & position != 1)) %>%
    dplyr::ungroup() %>%
    # Create new columns for elements in item and response based on position
    dplyr::mutate(
      element_in_item = substr(!!sym(item_col), position, position),
      element_in_response = substr(!!sym(response_col), position, position)
    ) %>%
    # Replace any out-of-bounds positions with NA
    dplyr::mutate(
      element_in_item = if_else(position <= nchar(!!sym(item_col)), element_in_item, NA_character_),
      element_in_response = if_else(position <= nchar(!!sym(response_col)), element_in_response, NA_character_)
    )

  # Return the modified data frame
  return(df_long)
}
