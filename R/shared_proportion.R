#' @name shared_proportion
#'
#' @title Calculate proportion of shared characters between two words
#'
#' @description Calculate the proportion of shared characters (letters/phonemes) between two words. The function converts both words to lowercase and then counts the number of unique characters in the `target_col` that also appear in the `response_col`. The proportion is determined based on the total number of characters in both words combined.
#'
#' @param target_col A string representing the target word to compare.
#' @param response_col A string representing the response word to compare against the target.
#'
#' @returns A numeric value representing the proportion of shared letters between the two input words. This proportion is computed as the ratio of the number of shared letters to the total number of letters in both words combined.
#'
#' @examples
#' shared_proportion("article", "artim")
#'
#' @export
#'
shared_proportion <- function(target_col, response_col) {
  # Convert words to lowercase
  target_col <- tolower(target_col)
  response_col <- tolower(response_col)

  # Convert words into character vectors
  target_col_chars <- unlist(strsplit(target_col, ""))
  response_col_chars <- unlist(strsplit(response_col, ""))

  # Count shared letters
  shared_letters <- 0

  # Count each shared letter only once per occurrence in response_col
  for (letter in target_col_chars) {
    if (letter %in% response_col_chars) {
      shared_letters <- shared_letters + 1
      # Remove the first occurrence of the letter in response_col
      response_col_chars <- response_col_chars[-which(response_col_chars == letter)[1]]
    }
  }

  # Calculate the total number of letters in both words
  total_letters <- nchar(target_col) + nchar(response_col)

  # Calculate the percentage of shared letters
  shared_percentage <- (shared_letters * 2) / total_letters

  return(shared_percentage)
}
