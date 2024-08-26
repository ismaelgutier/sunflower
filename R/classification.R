#' @name classification
#'
#' @title Classify Responses Based on Multiple Criteria
#'
#' @description This function classifies responses in a dataframe into different categories based on specified criteria. It adds new columns to the dataframe for each classification category, including lexicalization, nonword, neologism, formal, unrelated, morphological, mixed, and semantic.
#'
#' @param dataframe A data frame containing the response data to be classified.
#' @param access_col A string specifying the name of the column in the dataframe that indicates whether the response was accessed (default is "accessed").
#' @param RA_col A string specifying the name of the column in the dataframe that indicates whether the response was a related attempt (default is "RA").
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
#' @returns A data frame with additional columns for each classification category: `lexicalization`, `nonword`, `neologism`, `formal`, `unrelated`, `morphological`, `mixed`, and `semantic`. Each column contains binary values indicating the classification status of each response.
#'
#' @export

classification <- function(dataframe, access_col = "accessed", RA_col = "RA") {

  dataframe %>%
    rename(correct = {{ access_col }},
           RA = {{ RA_col }}) %>%
    mutate(correct = as.numeric(correct),
           lexicalization = ifelse(correct != 1 &
                                     RA != 1 &
                                     is_response_word == TRUE &
                                     is_target_nonword != 0, 1, 0),
           nonword = ifelse(correct != 1 &
                              RA != 1 &
                              is_response_word != TRUE &
                              lexicalization != 1 &
                              shared_proportion >= 0.50, 1, 0),
           neologism = ifelse(correct != 1 &
                                RA != 1 &
                                is_response_word != TRUE &
                                lexicalization != 1 &
                                shared_proportion < 0.50, 1, 0),
           formal = ifelse(correct != 1 &
                             RA != 1 &
                             same_root == 1 &
                             is_target_nonword != TRUE &
                             is_response_word == TRUE &
                             is_plural != TRUE &
                             (shared_proportion >= 0.50 | shared1char == TRUE), 1, 0),
           unrelated = ifelse(correct != 1 &
                                same_root != TRUE &
                                RA != 1 &
                                is_plural != TRUE &
                                cosine_similarity < 0.50, 1, 0),
           morphological = ifelse(correct != 1 &
                                    same_root == TRUE &
                                    RA != 1 &
                                    is_target_nonword != 1 &
                                    is_plural == 1, 1, 0),
           mixed = ifelse(correct != 1 &
                            same_root != TRUE &
                            RA != 1 &
                            is_target_nonword != TRUE &
                            is_plural != TRUE &
                            (shared_proportion >= 0.50 | shared1char == TRUE) &
                            is_response_word == TRUE &
                            cosine_similarity > 0.46, 1, 0),
           semantic = ifelse(correct != 1 &
                               same_root != TRUE &
                               mixed != 1 &
                               RA != 1 &
                               is_plural != TRUE &
                               formal != 1 &
                               unrelated != 1 &
                               is_response_word == TRUE &
                               cosine_similarity > 0.46, 1, 0))
}
