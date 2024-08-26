#' @name is_target_nonword
#'
#' @title Check if the Item Type is a Nonword
#'
#' @description Determines whether a given item type represents a nonword by checking if it contains "nonword", "NW", "pseudoword", "pseudo-word", or "non-word".
#'
#' @param item_type A character string representing the type of the item.
#'
#' @details This function checks if `item_type` matches common variations of the term "nonword", including "nonword", "NW", "pseudoword", "pseudo-word", and "non-word".
#'
#' @returns A logical value (`TRUE` or `FALSE`). Returns `TRUE` if `item_type` matches any of the specified nonword variations, otherwise `FALSE`.
#'
#' @export
is_target_nonword <- function(item_type) {
  return(grepl("nonword|NW|pseudoword|pseudo-word|non-word", item_type, ignore.case = TRUE))
}
