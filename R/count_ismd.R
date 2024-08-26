#' @name count_ismd
#'
#' @title Count character transformations
#'
#' @description Counts the number of specific character transformations in a given string. The transformations are identified as "insertion" (i), "substitution" (s), "match" (m), and "deletion" (d). This function processes the string to tally the occurrences of each transformation type.
#'
#' @param string A string representing the sequence of transformations, typically derived from the output of the `similarity_vector` function.
#'
#' @details The function converts the input string to lowercase for case-insensitive counting. It then iterates through each character in the string, counting occurrences of 'i', 's', 'm', and 'd', which represent insertion, substitution, match, and deletion transformations, respectively.
#'
#' @returns A data frame with counts of each transformation type: 'I' for insertions, 'S' for substitutions, 'M' for matches, and 'D' for deletions.
#'
#' @export
#'
count_ismd <- function(string) {
  # Convert the string to lowercase for case-insensitive search
  string <- tolower(string)

  # Initialize counters
  count_i <- 0
  count_s <- 0
  count_m <- 0
  count_d <- 0

  # Loop through each character in the string
  for (character in strsplit(string, NULL)[[1]]) {
    # Increment counters based on the current character
    if (character == "i") {
      count_i <- count_i + 1
    } else if (character == "s") {
      count_s <- count_s + 1
    } else if (character == "m") {
      count_m <- count_m + 1
    } else if (character == "d") {
      count_d <- count_d + 1
    }
  }

  # Return a data frame with the results
  results <- data.frame(I = count_i, S = count_s, M = count_m, D = count_d)
  return(results)
}
