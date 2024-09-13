#' @name check_lexicality
#'
#' @title Lexicality Classification of Responses Based on Frequency or Dictionary Presence
#'
#' @description This function classifies responses in a dataframe by comparing them to a predefined set of lexical items. Depending on the criterion selected, it either checks the frequency of the response words against a database or verifies the presence of the words in a dictionary list. The function adds a column to the dataframe indicating whether the response word is lexically appropriate based on the selected criterion.
#'
#' @param dataframe A data frame containing the response data to be classified.
#' @param criterion A string specifying the lexicality criterion to be used. Acceptable values are:
#'   - "database": Uses a frequency-based approach, comparing word frequencies.
#'   - "dictionary": Checks if the word exists in a predefined wordlist.
#'   The default is "database".
#' @param item_col A string specifying the name of the column containing the target word for frequency comparison (default is "item").
#' @param response_col A string specifying the name of the column containing the response word to be classified (default is "response").
#'
#' @details
#' The function processes the dataframe by comparing each row's response word to a reference list. Two methods are available:
#'
#' 1. **Database (Frequency-Based Approach)**:
#'    - The function compares the log-transformed frequency of the response word with that of the target word from a frequency database (`BPAL_freq`). If the response word has a frequency equal to or greater than the target word, the function classifies it as lexical.
#'
#' 2. **Dictionary (Presence-Based Approach)**:
#'    - The function checks if the response word exists in a predefined dictionary list (`RAE_wordlist`). If the response word is found, it is classified as lexical.
#'
#' A new column, `lexicality`, is added to the dataframe with binary values:
#' - `1` if the response is lexically appropriate (based on the selected criterion),
#' - `0` otherwise.
#'
#' If the word is not found in the frequency database or the dictionary, it is marked as non-lexical (0).
#'
#' @returns A data frame with an additional column `lexicality`, where:
#'   - `1`: The response is lexically valid (based on the criterion).
#'   - `0`: The response is non-lexical.
#'
#' @export
#'
#' @examples
#' # Example usage:
#' df <- data.frame(item = c("dog", "cat"), response = c("dog", "bat"))
#' check_lexicality(df, criterion = "database")
#'
#' # Using dictionary-based criterion
#' check_lexicality(df, criterion = "dictionary")
check_lexicality <- function(dataframe,
                             criterion = "database",
                             item_col = "item",
                             response_col = "response") {

  # Start timing for the total execution
  tictoc::tic()

  # Load the lexicality data based on the criterion
  if (criterion == "database") {
    lexical_list <- sunflower::BPAL_freq
    # Convert lexical_list to a named vector for frequency lookup
    freq_vector <- setNames(lexical_list$LOG10_FRQ, lexical_list$word)
  } else if (criterion == "dictionary") {
    # Load the dictionary wordlist
    lexical_list <- sunflower::RAE_wordlist
    # Convert lexical_list to a set for faster lookup
    lexical_set <- unique(lexical_list)
  } else {
    stop("Invalid criterion. Choose 'database' or 'dictionary'.")
  }

  # Function to get the frequency of a word from the frequency vector
  get_frequency <- function(word, freq_vector) {
    if (is.na(word) || !(word %in% names(freq_vector))) {
      return(NA)  # Word not found in frequency list
    } else {
      return(freq_vector[word])
    }
  }

  # Function to check if a word is present in the dictionary set
  is_word_present <- function(word, word_set) {
    return(word %in% word_set)
  }

  # Compare lexicality for each response
  lexicality <- mapply(function(target_word, response_word) {
    if (criterion == "dictionary") {
      response_present <- is_word_present(response_word, lexical_set)
      return(ifelse(response_present, 1, 0))  # 1 if present in dictionary, 0 otherwise
    } else {
      target_freq <- get_frequency(target_word, freq_vector)
      response_freq <- get_frequency(response_word, freq_vector)

      if (is.na(response_freq)) {
        return(0)  # Response not found in frequency list
      } else if (is.na(target_freq)) {
        return(0)  # Target word not found in frequency list
      } else if (response_freq >= target_freq) {
        return(1)  # Response frequency is equal or higher than target frequency
      } else {
        return(0)  # Response frequency is lower than target frequency
      }
    }
  }, dataframe[[item_col]], dataframe[[response_col]])

  # Add the lexicality results to the dataframe
  dataframe$lexicality <- lexicality

  # End timing for the total execution and capture the elapsed time
  elapsed_time <- tictoc::toc(quiet = TRUE)

  # Print custom message with the elapsed time rounded to 2 decimal places
  message(sprintf("The function check_lexicality() took %.2f seconds to be executed", elapsed_time$toc - elapsed_time$tic))

  return(dataframe)
}

