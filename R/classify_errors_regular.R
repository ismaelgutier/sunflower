#' @name classify_errors_regular
#'
#' @title Classify Responses Based on Multiple Criteria (Excluding Repeated Attempts)
#'
#' @description This function classifies responses in a dataframe into different categories based on specified criteria. It adds new columns to the dataframe for each error category, including nonword, neologism, formal, unrelated, mixed, and semantic. Additionally, it computes a `comment` column indicating if manual review is required based on the sum of error indicators and the `correct` column. This function differs from `classify_errors` in that it does not consider instances with repeated attempts (RA), making it simpler and more straightforward for classical/regular error classification tasks.
#'
#' @param dataframe A data frame containing the response data to be classified.
#' @param access_col A string specifying the name of the column in the dataframe that indicates whether the response was accessed correctly (default is "accessed").
#' @param cosine_limit_value A numeric value specifying the threshold for cosine similarity used in error classification (default is 0.46).
#' @param item_col A string specifying the name of the column in the dataframe that contains the target item (default is "item").
#' @param response_col A string specifying the name of the column in the dataframe that contains the response (default is "response").
#'
#' @details The function processes the dataframe by renaming columns and applying a series of conditions to create new error classification columns. The conditions are as follows:
#' - `nonword`: Identifies responses that are classified as nonwords.
#' - `neologism`: Identifies responses that are classified as neologisms.
#' - `formal`: Identifies responses that are classified as formal errors.
#' - `unrelated`: Identifies responses that are classified as unrelated errors.
#' - `mixed`: Identifies responses that are classified as mixed errors.
#' - `semantic`: Identifies responses that are classified as semantic errors.
#'
#' Each condition uses logical operations to check the values in the dataframe's columns and applies criteria based on those values to determine the error classification. The resulting classifications are added as new columns in the dataframe with binary indicators (1 for true, 0 for false).
#'
#' Additionally, the function includes:
#' - `no_response`: A binary column indicating if the `response_col` is NA or an empty space (1 if TRUE, 0 if FALSE).
#' - `comment`: A column indicating "required" if the sum of the error columns (from `nonword` to `no_response`) plus the `correct` column is 0 or greater than or equal to 2 for that row; otherwise, it is empty.
#'
#' @returns A data frame with additional columns for each error category: `nonword`, `neologism`, `formal`, `unrelated`, `mixed`, and `semantic`. Each column contains binary values indicating the error classification status of each response, along with `no_response` and `comment` columns.
#'
#' @export
classify_errors_regular <- function(dataframe,
                            access_col = "accessed",
                            cosine_limit_value = 0.46,
                            item_col = "item",
                            response_col = "response") {

  # Start timing for the total execution
  tictoc::tic()

  # Rename columns in dataframe as per user input
  dataframe <- dataframe %>%
    dplyr::rename(correct = {{ access_col }})

  # Add the comparison results to the dataframe
  dataframe <- dataframe %>%
    dplyr::mutate(
      nonword = dplyr::case_when(
        correct == 1 ~ 0,
        lexicality == 0 & p_shared_char >= 0.50 ~ 1,
        lexicality == 0 & p_shared_char < 0.50 ~ 0,
        TRUE ~ 0
      ),
      neologism = dplyr::case_when(
        correct == 1 ~ 0,
        lexicality == 0 & p_shared_char < 0.50 ~ 1,
        lexicality == 0 & p_shared_char >= 0.50 ~ 0,
        TRUE ~ 0
      ),
      formal = dplyr::case_when(
        correct == 1 ~ 0,
        lexicality == 1 & cosine_similarity < cosine_limit_value &
          (p_shared_char >= 0.50 | shared1char == 1) ~ 1,
        TRUE ~ 0
      ),
      unrelated = dplyr::case_when(
        correct == 1 ~ 0,
        lexicality == 1 & cosine_similarity < cosine_limit_value &
          p_shared_char < 0.50 & shared1char != 1 ~ 1,
        TRUE ~ 0
      ),
      mixed = dplyr::case_when(
        correct == 1 ~ 0,
        lexicality == 1 & (p_shared_char >= 0.50 | shared1char == 1) &
          cosine_similarity >= cosine_limit_value ~ 1,
        TRUE ~ 0
      ),
      semantic = dplyr::case_when(
        correct == 1 ~ 0,
        lexicality == 1 & cosine_similarity >= cosine_limit_value &
          !(p_shared_char >= 0.50 | shared1char == 1) ~ 1,
        TRUE ~ 0
      ),
      no_response = dplyr::case_when(
        is.na(get(response_col)) | get(response_col) == " " ~ 1,
        TRUE ~ 0
      ),
      # New column for human check
      comment = dplyr::case_when(
        rowSums(dplyr::across(c(nonword, neologism, formal, unrelated, mixed, semantic, no_response))) + correct >= 2 ~ "required",
        rowSums(dplyr::across(c(nonword, neologism, formal, unrelated, mixed, semantic, no_response))) + correct == 0 ~ "required",
        TRUE ~ ""
      )
    )

  # End timing for the total execution and capture the elapsed time
  elapsed_time <- tictoc::toc(quiet = TRUE)

  # Print custom message with the elapsed time rounded to 2 decimal places
  message(sprintf("The function classify_errors() took %.2f seconds to be executed", elapsed_time$toc - elapsed_time$tic))

  return(dataframe)
}
