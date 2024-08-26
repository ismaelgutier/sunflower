#' @name diff_char_count
#'
#' @title Calculate the difference in amount of characters
#'
#' @description Computes the difference in phoneme count between the two words words located in `target_col` and `response_col`.
#'
#' @inheritParams shared_proportion
#'
#' @details The function uses the LCS method from the `stringdist` package to calculate the difference between the two strings. The LCS method determines how similar the two strings are by finding the length of their longest common subsequence and then calculates the difference based on this measure.
#'
#' @returns A numeric value representing the difference in phoneme count between `target_col` and `response_col`, as measured by the LCS method. A higher value indicates a greater difference in phoneme count.
#'
#' @examples
#' diff_char_count("monkey", "monye")
#' diff_char_count("article", "artim")
#'
#' @export
#'
diff_char_count <- function(target_col, response_col) {
  # Calculate the difference in phoneme count using LCS method
  diff_char <- stringdist::stringdist(target_col, response_col, method = "lcs")
  return(diff_char)
}
