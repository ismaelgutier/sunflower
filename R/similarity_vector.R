#' @name similarity_vector
#'
#' @title Calculate the similarity vector between two words
#'
#' @description Computes the similarity vector between the words located in `target_col` and `response_col`. This function uses the `adist` function from the `utils` package to calculate the similarity matrix and returns the vector of similarity scores by dropping transformation attributes.
#'
#' @inheritParams shared_proportion
#'
#' @details The function utilizes the `adist` function to calculate a similarity matrix between the `target_col` and `response_col`. It then drops the transformation attributes from the result to obtain the similarity vector, which reflects the degree of similarity based on character edits.
#'
#' @returns A numeric vector representing the similarity scores between characters in `target_col` and `response_col`. This vector reflects the degree of similarity based on character edits, with higher values indicating greater similarity.
#'
#' @examples
#' similarity_vector("monkey", "monye")
#' similarity_vector("article", "artim")
#'
#' @export
#'
similarity_vector <- function(target_col, response_col) {
  # Calculate the similarity vector by dropping transformation attributes
  similarity_vec <- drop(attr(utils::adist(target_col, response_col, counts = TRUE), "trafos"))
  return(similarity_vec)
}
