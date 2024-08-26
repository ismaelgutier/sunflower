#' @name shared_proportion_pos_ok
#'
#' @title Calculate proportion of shared characters between two words in their correct position
#'
#' @description Compute the proportion of matching characters (letters/phonemes) between the words in `target_col` and `response_col`, where characters must be in the correct position. Specifically, this function compares each character in the target string to the corresponding character in the response string and calculates the proportion characters produced in the correct position.
#'
#' @inheritParams shared_proportion
#'
#' @returns A numeric value representing the ratio of characters shared by the two strings as they are produced in the same position.
#'
#' @examples
#' shared_proportion_pos_ok("monkey", "monye")
#' shared_proportion_pos_ok("article", "artim")
#'
#' @export

# Function to calculate the proportion of shared phonemes in the correct position
shared_proportion_pos_ok <- function(target_col, response_col) {
  if (is.na(target_col) || is.na(response_col) || target_col == "" || response_col == "") {
    return(NA)
  }

  matching_positions <- numeric(nchar(target_col))

  for (j in 1:nchar(target_col)) {
    if (substr(target_col, j, j) == substr(response_col, j, j)) {
      matching_positions[j] <- 1
    } else {
      matching_positions[j] <- 0
    }
  }

  correct_proportion <- sum(matching_positions) / nchar(target_col)
  return(correct_proportion)
}
