#' @name calculate_damerau_levenshtein
#'
#' @title Calculate the Damerau-Levenshtein distance
#'
#' @description Computes the Damerau-Levenshtein distance between two strings located in `target_col` and `response_col`. The Damerau-Levenshtein distance is a metric that measures the number of single-character edits (insertions, deletions, substitutions) and transpositions required to change one string into the other.
#'
#' @inheritParams shared_proportion
#'
#' @details This function uses the `stringdist` package's implementation of the Damerau-Levenshtein distance. This distance metric extends the Levenshtein distance by also considering transpositions of adjacent characters, making it useful for measuring similarity in cases where adjacent character transpositions are common.
#'
#' @returns A numeric value representing the Damerau-Levenshtein distance between `target_col` and `response_col`. A higher value indicates a greater number of edits or transpositions needed to transform one string into the other.
#'
#' @examples
#' calculate_damerau_levenshtein("monkey", "monye")
#' calculate_damerau_levenshtein("article", "artim")
#'
#' @export
#'
calculate_damerau_levenshtein <- function(target_col, response_col) {
  return(stringdist::stringdist(target_col, response_col, method = "dl"))
}
