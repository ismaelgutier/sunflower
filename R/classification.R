#' @name classification
#'
#' @title Classify Responses Based on Multiple Criteria
#'
#' @description This function classifies responses in a dataframe into different categories based on specified criteria. It adds new columns to the dataframe for each classification category, including lexicalization, nonword, neologism, formal, unrelated, morphological, mixed, and semantic. Additionally, it computes a `human_check` column indicating if manual review is required based on the sum of classification indicators and the `correct` column.
#'
#' @param dataframe A data frame containing the response data to be classified.
#' @param access_col A string specifying the name of the column in the dataframe that indicates whether the response was accessed (default is "accessed").
#' @param RA_col A string specifying the name of the column in the dataframe that indicates whether the response was a related attempt (default is "RA").
#' @param cosine_limit_value A numeric value specifying the threshold for cosine similarity used in classification (default is 0.46).
#' @param response_col A string specifying the name of the column in the dataframe that contains the response status (default is "response_col").
#' @param classify_RAs A logical value indicating whether to classify rows with `RA` equal to 1 according to the conditions (default is FALSE). If FALSE, such rows will have the classification results set to NA.
#'
#' @details The function processes the dataframe by renaming columns and applying a series of conditions to create new classification columns. The conditions are as follows:
#' - `lexicalization`: Identifies responses that are lexicalized based on specific conditions.
#' - `nonword`: Identifies responses that are classified as nonwords.
#' - `neologism`: Identifies responses that are classified as neologisms.
#' - `formal`: Identifies responses that are classified as formal.
#' - `unrelated`: Identifies responses that are classified as unrelated.
#' - `morphological`: Identifies responses that are classified as morphological.
#' - `mixed`: Identifies responses that are classified as mixed.
#' - `semantic`: Identifies responses that are classified as semantic.
#'
#' Each condition uses logical operations to check the values in the dataframe's columns and applies criteria based on those values to determine the classification. The resulting classifications are added as new columns in the dataframe with binary indicators (1 for true, 0 for false).
#'
#' Additionally, the function includes:
#' - `no_response`: A binary column indicating if the `response_col` is "Response" and contains NA values (1 if TRUE, 0 if FALSE).
#' - `human_check`: A column indicating "required" if the sum of the classification columns (from `lexicalization` to `no_response`) plus the `correct` column is 0 or greater than or equal to 2 for that row; otherwise, it is empty.
#'
#' When `classify_RAs` is FALSE, rows where `RA` is 1 will have the classification results set to NA. When `classify_RAs` is TRUE, classification is performed normally regardless of the `RA` value.
#'
#' @returns A data frame with additional columns for each classification category: `lexicalization`, `nonword`, `neologism`, `formal`, `unrelated`, `morphological`, `mixed`, and `semantic`. Each column contains binary values indicating the classification status of each response, along with `no_response` and `human_check` columns.
#'
#' @export
classification <- function(dataframe, access_col = "accessed", RA_col = "RA",
                           cosine_limit_value = 0.46, response_col = "response_col",
                           classify_RAs = FALSE) {

  dataframe <- dataframe %>%
    rename(correct = {{ access_col }},
           RA = {{ RA_col }}) %>%
    mutate(
      correct = as.numeric(correct),   # Ensure 'correct' is numeric
      RA = as.numeric(RA),             # Ensure 'RA' is numeric
      lexicalization = ifelse(
        correct != 1 &
          is_response_word == 1 &
          is_target_nonword != 0,
        1, 0
      ),
      nonword = ifelse(
        correct != 1 &
          is_response_word != 1 &
          lexicalization != 1 &
          shared_proportion >= 0.50,
        1, 0
      ),
      neologism = ifelse(
        correct != 1 &
          is_response_word != 1 &
          lexicalization != 1 &
          shared_proportion < 0.50,
        1, 0
      ),
      formal = ifelse(
        correct != 1 &
          same_root == 1 &
          is_target_nonword != 1 &
          is_response_word == 1 &
          is_plural != 1 &
          (shared_proportion >= 0.50 | shared1char == 1),
        1, 0
      ),
      unrelated = ifelse(
        correct != 1 &
          same_root != 1 &
          is_plural != 1 &
          cosine_similarity < cosine_limit_value,
        1, 0
      ),
      morphological = ifelse(
        correct != 1 &
          same_root == 1 &
          is_target_nonword != 1 &
          is_plural == 1,
        1, 0
      ),
      mixed = ifelse(
        correct != 1 &
          same_root != 1 &
          is_target_nonword != 1 &
          is_plural != 1 &
          (shared_proportion >= 0.50 | shared1char == 1) &
          is_response_word == 1 &
          cosine_similarity > cosine_limit_value,
        1, 0
      ),
      semantic = ifelse(
        correct != 1 &
          same_root != 1 &
          mixed != 1 &
          is_plural != 1 &
          formal != 1 &
          unrelated != 1 &
          is_response_word == 1 &
          cosine_similarity > cosine_limit_value,
        1, 0
      ),
      # New column to handle NA values in response_col
      no_response = ifelse(
        is.na(get(response_col)) & response_col == "Response",
        1, 0
      ),
      # Set errors to NA if RA is 1 unless classify_RAs is TRUE
      across(c(lexicalization, nonword, neologism, formal, unrelated, morphological, mixed, semantic, no_response),
             ~ ifelse(!classify_RAs & RA == 1, NA, .)),
      # New column for human check
      human_check = case_when(
        rowSums(across(c(lexicalization, nonword, neologism, formal, unrelated, morphological, mixed, semantic, no_response)), na.rm = TRUE) + correct >= 2 ~ "required",
        rowSums(across(c(lexicalization, nonword, neologism, formal, unrelated, morphological, mixed, semantic, no_response)), na.rm = TRUE) + correct == 0 ~ "required",
        TRUE ~ ""
      )
    )

  return(dataframe)
}
