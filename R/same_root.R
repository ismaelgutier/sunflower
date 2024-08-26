#' @name same_root
#'
#' @title Check if Two Words Share the Same Root
#'
#' @description Determines whether two words share the same root in Spanish using stemming. If the words contain a comma or space, the function returns `NA` to avoid processing multiple productions or concatenated words.
#'
#' @param target_col A character string representing the first word.
#' @param response_col A character string representing the second word.
#'
#' @details This function uses the `SnowballC` package to perform stemming on the `target_col` and `response_col` words. If either word contains a comma or space, the function skips the stemming process and returns `NA`. Otherwise, it compares the roots of the two words and returns `TRUE` if they match, or `FALSE` otherwise.
#'
#' @returns A logical value (`TRUE` or `FALSE`). Returns `TRUE` if `target_col` and `response_col` share the same root. Returns `NA` if either word contains a comma or space.
#'
#' @examples
#' same_root("hablando", "hablar")
#' same_root("corriendo", "correr")
#'
#' @export
#'
same_root <- function(target_col, response_col) {

  # if CdA or multiple productions are made, avoid this procedure by returning NA
  root_item <- ifelse(stringr::str_detect(target_col, "[,\\s]"), NA, SnowballC::wordStem(target_col, language = "spanish"))
  root_response <- ifelse(stringr::str_detect(response_col, "[,\\s]"), NA, SnowballC::wordStem(response_col, language = "spanish"))

  same_root <- dplyr::case_when(
    is.na(root_item) | is.na(root_response) ~ NA,
    root_item == root_response ~ TRUE,
    TRUE ~ FALSE
  )

  return(same_root)
}
