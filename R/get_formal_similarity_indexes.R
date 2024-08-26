#' @name get_formal_similarity_indexes
#'
#' @title Compute Formal Similarity Indexes Between Target and Response Columns
#'
#' @description This function computes various formal similarity indexes between the target and response columns in a dataframe. It calculates metrics such as shared proportion of characters, shared starting characters, plural/singular agreement, and root similarity. Additionally, it checks if the responses are present in specified source lists and adds this information to the dataframe.
#'
#' @param dataframe A dataframe containing the data to analyze.
#' @param target_col A string specifying the name of the column containing the target items. Default is `"item"`.
#' @param response_col A string specifying the name of the column containing the response items. Default is `"response"`.
#' @param item_type A string specifying the name of the column indicating the item type. Default is `"task_type"`.
#' @param source1 An optional vector of words to check against the responses. Default is `NULL`.
#' @param source2 An optional vector of words to check against the responses. Default is `NULL`.
#' @param source3 An optional vector of words to check against the responses. Default is `NULL`.
#'
#' @details The function calculates the following similarity metrics:
#' \itemize{
#'   \item `shared_proportion`: The proportion of shared characters between target and response.
#'   \item `shared1char`: A measure indicating whether the target and response share the same starting letter.
#'   \item `is_plural`: An indicator of whether the target and response agree in terms of plurality.
#'   \item `is_target_nonword`: (Placeholder for future implementation) Checks if the target is a non-word.
#'   \item `same_root`: A measure indicating whether the target and response share the same root.
#' }
#'
#' The function also combines the provided source lists into a single unique list, and adds a new column, `is_response_word`, indicating whether each response is present in this combined list.
#'
#' @returns A dataframe with additional columns for the calculated similarity indexes, including:
#' \itemize{
#'   \item `shared_proportion`: Proportion of shared characters.
#'   \item `shared1char`: Shared starting letter indicator.
#'   \item `is_plural`: Plurality agreement indicator.
#'   \item `is_target_nonword`: Placeholder column.
#'   \item `same_root`: Root similarity indicator.
#'   \item `is_response_word`: Indicator if the response is found in the combined source lists.
#' }
#'
#' @export
get_formal_similarity_indexes <- function(dataframe,
                                      target_col = "item",
                                      response_col = "response",
                                      item_type = "task_type",
                                      source1 = NULL,
                                      source2 = NULL,
                                      source3 = NULL) {

  # Start timing for the total execution
  tictoc::tic()

  # Initialize vectors for formal indexes
  n <- nrow(dataframe)
  shared_proportion <- vector("numeric", length = n)
  shared1char <- vector("numeric", length = n)
  is_plural <- vector("numeric", length = n)
  is_target_nonword <- vector("numeric", length = n)
  same_root <- vector("numeric", length = n)

  # Calculate the formal indexes
  for (i in 1:n) {
    row <- dataframe[i, ]
    shared_proportion[i] <- shared_proportion(row[[target_col]], row[[response_col]])
    shared1char[i] <- same_letter_start(row[[target_col]], row[[response_col]])
    is_plural[i] <- is_plural_singular(row[[target_col]], row[[response_col]])
    same_root[i] <- same_root(row[[target_col]], row[[response_col]])
  }

  # Combine the results into a dataframe
  result <- cbind(dataframe, shared_proportion, shared1char, is_plural, is_target_nonword, same_root)

  # Create a list of sources, excluding those that are NULL
  sources <- list(source1, source2, source3)
  sources <- sources[!sapply(sources, is.null)]  # Filter out the NULL values

  # Combine the sources into a single unique list
  combined_sources <- unique(unlist(sources))  # Ensure there are no duplicates

  # Apply the check and add the column to the dataframe
  result <- result %>%
    mutate(
      is_response_word = ifelse(
        get(response_col) %in% combined_sources,
        1,
        0
      )
    )

  # End timing for the total execution and capture the elapsed time
  elapsed_time <- tictoc::toc(quiet = TRUE)

  # Print custom message with the elapsed time rounded to 2 decimal places
  message(sprintf("The function get_formal_similarity_indexes() took %.2f seconds to be executed", elapsed_time$toc - elapsed_time$tic))

  return(result)
}
