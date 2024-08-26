#' @name separate_responses
#'
#' @title Split the response in consecutive columns
#'
#' @description Separates the text of an answer column into consecutive independent columns according to the number of separations in that answer column. Depends on the \code{counting_to_split()} function.
#' @param df A data frame containing the responses to join together.
#' @param col_name Target column to be considered as response column.
#' @param separate_with A character string used separate the responses (e.g., " - ", " ", or " & "). By default it uses commas (i.e., ", ").
#' @param show_previous Logical; whether the previous columns not used in the merge (i.e. the identifier columns) are provided in the output or not. If \code{'FALSE'} only the separated columns are provided in the output. Default is \code{'TRUE'}.
#'
#' @details This function relies on `separation_counting()`.
#'
#'
#'
#' @returns A data frame.
#' @export
#'
#' @examples
#'
#' data("IGC")
#'
#' IGC %>% separate_responses(col_name = "final_response",
#'                                 separate_with = ", ",
#'                                 show_previous = F)
#' separate_responses(df = IGC, col_name = "final_response",
#'                                 separate_with = ", ",
#'                                 show_previous = F)
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
    RA = ifelse(stringr::str_detect({{col_name}}, separate_with), 1, 0),
    RA = ifelse(is.na({{col_name}}), NA, RA)
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
