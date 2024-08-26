#' @name separate_responses
#'
#' @title Split the Response in Consecutive Columns
#'
#' @description
#' This function separates the text in a specified column of a data frame into consecutive independent columns based on a specified separator. It uses the `separation_counting()` function to determine the number of separations needed and create new column names. It also creates an additional column (`RA`) indicating whether the response was split.
#'
#' @param df A data frame containing the responses to split.
#' @param col_name The name of the target column to be split into multiple columns.
#' @param separate_with A character string used to separate the responses (e.g., ", ", " - ", or " & "). By default, it uses a comma followed by a space (", ").
#' @param show_previous Logical; indicates whether the previous columns not used in the separation (i.e., the identifier columns) should be included in the output. If \code{FALSE}, only the separated columns and the `RA` column are provided in the output. Default is \code{TRUE}.
#'
#' @details
#' This function relies on the `separation_counting()` function to determine the number of separations and generate the new column names. The function handles NA values appropriately and converts all separated columns to character type for consistency.
#'
#' The `RA` column is created to flag rows that contain multiple responses. A value of 1 indicates that the response was split, while 0 indicates no splitting. If the value is NA in the response column, the `RA` value is also set to NA.
#'
#' @return A data frame with the separated columns. If \code{show_previous} is \code{TRUE}, the output includes the original columns that were not split, along with the separated columns and the `RA` column. If \code{show_previous} is \code{FALSE}, only the separated columns and the `RA` column are returned.
#'
#' @export
separate_responses <- function(df,
                               col_name,
                               separate_with = ", ",
                               show_previous = TRUE){

  # Clean the dataframe to keep ID columns
  previous <- df %>% dplyr::select(-{{col_name}})

  # Get the column names and separation count
  separation_info <- separation_counting(df, {{col_name}}, separate_with)
  colmn <- separation_info$column_names

  # Extract the column and handle NA
  col_to_split <- df %>% dplyr::pull({{col_name}})

  # Create the RA column and handle NA in the separation
  df <- df %>% dplyr::mutate(
    RA = ifelse(stringr::str_detect(!!rlang::sym(col_name), separate_with), 1, 0),
    RA = ifelse(is.na(!!rlang::sym(col_name)), NA, RA)
  )

  # Separate the string based on the specified character
  separated_columns <- reshape2::colsplit(
    col_to_split,
    pattern = separate_with,
    names = colmn
  )

  # Handle NA in separated_columns
  separated_columns[is.na(separated_columns)] <- NA

  # Convert all columns to character
  separated_columns <- separated_columns %>% dplyr::mutate_if(is.integer, as.character)

  # Combine with the original dataframe based on the show_previous flag
  if (show_previous) {
    return(cbind(previous, df %>% dplyr::select(RA), separated_columns))
  } else {
    return(cbind(df %>% dplyr::select(RA), separated_columns))
  }
}
