#' @name calculate_jaro_winkler
#'
#' @title Calculate the Jaro-Winkler distance
#'
#' @description Computes the Jaro-Winkler distance between two strings located in `target_col` and `response_col`. The Jaro-Winkler distance measures the similarity between two strings by considering the number of matching characters and transpositions, with a prefix scale that gives more weight to strings that match from the beginning.
#'
#' @inheritParams shared_proportion
#'
#' @details This function uses the `stringdist` package's implementation of the Jaro-Winkler distance. This metric extends the Jaro distance by giving more importance to matches at the beginning of the strings, which is useful for matching names and other short strings where early matches are often more significant.
#'
#' @returns A numeric value representing the Jaro-Winkler distance between `target_col` and `response_col`. The distance ranges from 0 to 1, where a value closer to 1 indicates a higher similarity between the strings.
#'
#' @examples
#' calculate_jaro_winkler("monkey", "monye")
#' calculate_jaro_winkler("article", "artim")
#'
#' @export
#'
calculate_jaro_winkler <- function(target_col, response_col) {
  return(stringdist::stringdist(target_col, response_col, method = 'jw', p = 0.1))
}
