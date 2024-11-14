#' @name separation_counting
#'
#' @title Count the number of separations to determine the number of columns
#'
#' @description Calculate the number of occurrences of a specified separator character (e.g., ", ") in a response column to determine how many columns will be needed to separate the responses provided by a patient. It depends on the \code{df_from_column()} function and supports the \code{separate_responses()} function.
#'
#' @param df A data frame to work with.
#' @param col_name The target column containing the responses that will be analyzed.
#' @param separate_with A character string used to separate the responses (e.g., " - ", " ", or " & "). By default, it uses commas followed by an empty space (i.e., ", ").
#' @param new_col_names A base name for the new columns that will be created. The actual column names will be this base name followed by the column number (e.g., "attempt_1", "attempt_2"). Default is \code{"attempt"}.
#' @returns A list containing two elements: \code{column_names}, a character vector with the names of the new columns; and \code{count}, an integer representing the number of columns needed.
#' @export
#'
separation_counting <- function(df,
                                col_name,
                                separate_with = ", ",
                                new_col_names = "attempt"){

  # Extract the column from the data frame and handle NA
  col_to_count1 <- df %>% dplyr::pull({{col_name}})

  # Replace NA with an empty string to avoid errors in str_count
  col_to_count1[is.na(col_to_count1)] <- ""

  # Calculate the number of separations (+1 for the number of columns)
  ncols <- max(stringr::str_count(col_to_count1, pattern = separate_with)) + 1

  # Create column names based on the count
  colmn <- paste(new_col_names, 1:ncols, sep = "_")

  # Return the column names and the count of separations
  list(column_names = colmn, count = ncols)
}
