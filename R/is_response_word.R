#' @name is_response_word
#'
#' @title Check if Response is a Word from Specified Sources
#'
#' @description This function checks if the values in the specified response column are found within any of the provided word source lists. It adds a new column, `is_response_word`, to the dataframe indicating whether each response is present in the combined source list.
#'
#' @param dataframe A data frame containing the response data.
#' @param response_col A string specifying the name of the column in the dataframe that contains the responses to be checked.
#' @param source1 An optional vector of words. This is the first source against which the responses will be checked. Defaults to `NULL`.
#' @param source2 An optional vector of words. This is the second source against which the responses will be checked. Defaults to `NULL`.
#' @param source3 An optional vector of words. This is the third source against which the responses will be checked. Defaults to `NULL`.
#'
#' @details The function checks if each value in the specified response column exists in any of the provided source lists (source1, source2, source3). The sources are first combined into a single list, excluding any `NULL` values, and then checked for duplicates to ensure uniqueness. The function then creates a new column, `is_response_word`, in the dataframe, where a value of `1` indicates the response is found in the combined sources, and `0` indicates it is not.
#'
#' @returns A data frame with an additional column named `is_response_word`. This column is a numeric vector where `1` indicates that the response is a word found in the provided sources, and `0` indicates it is not.
#'
#' @export
is_response_word <- function(dataframe, response_col, source1 = NULL, source2 = NULL, source3 = NULL) {
  # Create a list of sources, excluding those that are NULL
  sources <- list(source1, source2, source3)
  sources <- sources[!sapply(sources, is.null)]  # Filter out the NULL values

  # Combine the sources into a single unique list
  combined_sources <- unique(unlist(sources))  # Ensure there are no duplicates

  # Apply the check and add the column to the dataframe
  dataframe <- dataframe %>%
    mutate(
      is_response_word = ifelse(
        .data[[response_col]] %in% combined_sources,
        1,
        0
      )
    )

  return(dataframe)
}
