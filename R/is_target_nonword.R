#' @name is_target_nonword
#'
#' @title Check if the Item Type is a Nonword
#'
#' @description This function determines whether a given item type represents a nonword. It does so by checking if the item type contains any of the specified patterns: "nonword", "nonwords", "NW", "pseudoword", "pseudowords", "pseudo-word", "pseudo-words", "non-word", "non-words", "pseudopalabra", or "pseudopalabras".
#'
#' @param item_type A character string representing the type of the item to be checked.
#'
#' @details The function searches for common variations of the term "nonword" within the `item_type` string. If any of the specified patterns are found, the function will return `1`.
#'
#' @return An integer value (`1` or `0`). Returns `1` if the `item_type` matches any of the specified nonword patterns, otherwise `0`.
#'
#' @export
is_target_nonword <- function(item_type, patterns = c("nonword", "nonwords", "NW",
                                                      "pseudoword", "pseudowords",
                                                      "pseudo-word", "pseudo-words",
                                                      "non-word", "non-words",
                                                      "pseudopalabra", "pseudopalabras")) {
  pattern <- paste(patterns, collapse = "|")
  if (grepl(pattern, item_type, ignore.case = TRUE)) {
    return(1)
  } else {
    return(0)
  }
}
