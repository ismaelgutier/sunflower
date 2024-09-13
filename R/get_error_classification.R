#' @name classify_errors
#'
#' @title Classify Responses Based on Multiple Criteria
#'
#' @description This function classifies responses in a dataframe into different categories based on specified criteria. It adds new columns to the dataframe for each classify_errors category, including lexicalization, nonword, neologism, formal, unrelated, morphological, mixed, and semantic. Additionally, it computes a `comment` column indicating if manual review is required based on the sum of classify_errors indicators and the `correct` column.
#'
#' @param dataframe A data frame containing the response data to be classified.
#' @param access_col A string specifying the name of the column in the dataframe that indicates whether the response was accessed (default is "accessed").
#' @param RA_col A string specifying the name of the column in the dataframe that indicates whether the response was a related attempt (default is "RA").
#' @param cosine_limit_value A numeric value specifying the threshold for cosine similarity used in classify_errors (default is 0.46).
#' @param response_col A string specifying the name of the column in the dataframe that contains the response status (default is "response_col").
#' @param also_classify_RAs A logical value indicating whether to classify rows with `RA` equal to 1 according to the conditions (default is FALSE). If FALSE, such rows will have the classify_errors results set to NA.
#'
#' @details The function processes the dataframe by renaming columns and applying a series of conditions to create new classify_errors columns. The conditions are as follows:
#' - `nonword`: Identifies responses that are classified as nonwords.
#' - `neologism`: Identifies responses that are classified as neologisms.
#' - `formal`: Identifies responses that are classified as formal.
#' - `unrelated`: Identifies responses that are classified as unrelated.
#' - `mixed`: Identifies responses that are classified as mixed.
#' - `semantic`: Identifies responses that are classified as semantic.
#'
#' Each condition uses logical operations to check the values in the dataframe's columns and applies criteria based on those values to determine the classify_errors. The resulting classify_errorss are added as new columns in the dataframe with binary indicators (1 for true, 0 for false).
#'
#' Additionally, the function includes:
#' - `no_response`: A binary column indicating if the `response_col` is "Response" and contains NA values (1 if TRUE, 0 if FALSE).
#' - `comment`: A column indicating "required" if the sum of the classify_errors columns (from `nonword` to `no_response`) plus the `correct` column is 0 or greater than or equal to 2 for that row; otherwise, it is empty. Set as `is only considered as RA` in case of RA and parameter `classify_RAs = TRUE`
#'
#' When `also_classify_RAs` is FALSE, rows where `RA` is 1 will have the classify_errors results set to NA. When `classify_RAs` is TRUE, classify_errors is performed normally regardless of the `RA` value.
#'
#' @returns A data frame with additional columns for each classify_errors category:`nonword`, `neologism`, `formal`, `unrelated`, `mixed`, and `semantic`. Each column contains binary values indicating the classify_errors status of each response, along with `no_response` and `comment` columns.
#'
#' @export
#'
classify_errors <- function(dataframe,
                            access_col = "accessed",
                            RA_col = "RA",
                            cosine_limit_value = 0.46,
                            item_col = "item",
                            response_col = "response",
                            also_classify_RAs = FALSE) {

  # Start timing for the total execution
  tictoc::tic()

  # Rename columns in dataframe as per user input
  dataframe <- dataframe %>%
    dplyr::rename(correct = {{ access_col }},
           RA = {{ RA_col }})

  # Add the comparison results to the dataframe
  dataframe <- dataframe %>%
    dplyr::mutate(nonword = ifelse(
      correct != 1 &
        lexicality == 0 &
        p_shared_char >= 0.50,
      1, 0
    ),
    neologism = ifelse(
      correct != 1 &
        lexicality == 0 &
        p_shared_char < 0.50,
      1, 0
    ),
    formal = ifelse(
      correct != 1 &
        lexicality == 1 &
        cosine_similarity < cosine_limit_value &
        (p_shared_char >= 0.50 | shared1char == 1),
            1, 0),
    unrelated = ifelse(
      correct != 1 &
        lexicality == 1 &
        cosine_similarity < cosine_limit_value &
        (p_shared_char < 0.50 & shared1char != 1),
      1, 0
    ),
    mixed = ifelse(
      correct != 1 &
        lexicality == 1 &
        (p_shared_char >= 0.50 | shared1char == 1) &
        cosine_similarity >= cosine_limit_value,
      1, 0
    ),
    semantic = ifelse(
      correct != 1 &
        mixed != 1 &
        formal != 1 &
        unrelated != 1 &
        lexicality == 1 &
        cosine_similarity >= cosine_limit_value,
      1, 0
    ),
    no_response = ifelse(
      is.na(get(response_col)) | get(response_col) == " ",
      1, 0
    ),
    # Set errors to NA if RA is 1 unless also_classify_RAs is TRUE
    dplyr::across(c(nonword, neologism, formal, unrelated, mixed, semantic, no_response),
           ~ ifelse(!also_classify_RAs & RA == 1, NA, .)),
    # New column for human check
    comment = dplyr::case_when(
      !also_classify_RAs & .data[[RA_col]] == 1 ~ "is only considered as RA",
      rowSums(dplyr::across(c(nonword, neologism, formal, unrelated, mixed, semantic, no_response)), na.rm = TRUE) + correct >= 2 ~ "required",
      rowSums(dplyr::across(c(nonword, neologism, formal, unrelated, mixed, semantic, no_response)), na.rm = TRUE) + correct == 0 ~ "required",
      TRUE ~ ""
    )
    )

  # End timing for the total execution and capture the elapsed time
  elapsed_time <- tictoc::toc(quiet = TRUE)

  # Print custom message with the elapsed time rounded to 2 decimal places
  message(sprintf("The function classify_errors() took %.2f seconds to be executed", elapsed_time$toc - elapsed_time$tic))

  return(dataframe)
}
