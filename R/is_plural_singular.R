#' @name is_plural_singular
#'
#' @title Check if Two Words are Singular and Plural Forms of Each Other
#'
#' @description Determines whether two given Spanish words are singular and plural forms of each other. The function evaluates common singular-plural transformations and handles special cases, including words ending in "s" or "x" and irregular plurals.
#'
#' @param target_col A character string representing the first word.
#' @param response_col A character string representing the second word.
#'
#' @details This function checks if the words are related by common singular-plural transformations. It handles various suffix changes and some irregular pluralization cases:
#' - Words ending in "s" or "x" are considered to not change their plural form.
#' - Handles irregular plurals, such as "luz" becoming "luces".
#'
#' @returns A logical value (`TRUE` or `FALSE`). Returns `TRUE` if `target_col` and `response_col` are singular and plural forms of each other, otherwise `FALSE`.
#'
#' @examples
#' is_plural_singular("canción", "canciones")  # TRUE
#' is_plural_singular("luz", "luces")          # TRUE
#' is_plural_singular("mono", "mona")          # FALSE
#'
#' @export
is_plural_singular <- function(target_col, response_col) {
  # Helper function to determine if a word is plural
  is_plural <- function(word) {
    return(grepl("s$", word) && nchar(word) > 1) # Ensure it's plural and not a single character
  }

  # Helper function to convert a singular word to plural
  convert_to_plural <- function(word) {
    # Define a list of singular-plural transformations
    transformations <- list(
      "ón" = "ones",
      "án" = "anes",
      "én" = "enes",
      "ín" = "ines",
      "ún" = "unes",
      "és" = "eses",
      "z"  = "ces",
      "í"  = "íes",
      "ú"  = "úes"
    )

    # Handle special cases for words ending in "s" or "x"
    if (grepl("[sx]$", word)) {
      return(word)
    }

    # Loop through the transformations to check for a match
    for (singular_suffix in names(transformations)) {
      plural_suffix <- transformations[[singular_suffix]]

      # Check if word is the singular form and needs to be converted to plural
      if (grepl(paste0(singular_suffix, "$"), word)) {
        return(gsub(paste0(singular_suffix, "$"), plural_suffix, word))
      }
    }

    # Handle irregular plurals like "luz" -> "luces"
    if (grepl("z$", word)) {
      return(gsub("z$", "ces", word))
    }

    # Fallback: Regular plural by adding -s
    return(paste0(word, "s"))
  }

  # Check if either word is NA
  if (is.na(target_col) || is.na(response_col)) {
    return(FALSE)
  }

  # Determine if each word is plural
  target_is_plural <- is_plural(target_col)
  response_is_plural <- is_plural(response_col)

  # Convert each word to its plural form
  target_plural <- convert_to_plural(target_col)
  response_plural <- convert_to_plural(response_col)

  # Check if only one word is plural and the other matches after conversion
  return((target_is_plural != response_is_plural) &&
           (tolower(target_plural) == tolower(response_col) ||
              tolower(response_plural) == tolower(target_col)))
}

