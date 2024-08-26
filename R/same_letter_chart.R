#' @name same_letter_start
#'
#' @title Check if two words start with the same letter
#'
#' @description Determines whether two given words start with the same letter. It compares the first character of `target_col` and `response_col`.
#'
#' @param target_col A character string representing the first word.
#' @param response_col A character string representing the second word.
#'
#' @details This function extracts the first character of each string and checks if they are identical. It returns `TRUE` if both words start with the same letter, and `FALSE` otherwise.
#'
#' @returns A logical value (`TRUE` or `FALSE`). Returns `TRUE` if `target_col` and `response_col` start with the same letter, otherwise `FALSE`.
#'
#' @examples
#' same_letter_start("monkey", "monye")
#' same_letter_start("article", "artim")
#'
#' @export
#'
same_letter_start <- function(target_col, response_col) {
  chart1 = substr(target_col, 1, 1)
  charr1 = substr(response_col, 1, 1)
  return(chart1 == charr1)
}
