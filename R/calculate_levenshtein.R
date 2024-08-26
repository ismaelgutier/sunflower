#' @name calculate_levenshtein
#'
#' @title Calculate the Levenshtein distance
#'
#' @description Computes the Levenshtein distance between two strings located in `target_col` and `response_col`. The Levenshtein distance measures the number of single-character edits (insertions, deletions, or substitutions) required to change one string into the other.
#'
#' @inheritParams shared_proportion
#'
#' @details This function utilizes the `stringdist` package's implementation of the Levenshtein distance. The distance is a common metric for evaluating the similarity between two strings, where a higher distance indicates more differences between the strings.
#'
#' @returns A numeric value representing the Levenshtein distance between `target_col` and `response_col`. A higher value indicates a greater number of edits needed to transform one string into the other.
#'
#' @examples
#' calculate_levenshtein("monkey", "monye")
#' calculate_levenshtein("article", "artim")
#'
#' @export
#'
calculate_levenshtein <- function(target_col, response_col) {
  return(stringdist::stringdist(target_col, response_col, method = "lv"))
}
