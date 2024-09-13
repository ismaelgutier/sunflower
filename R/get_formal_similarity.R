#' @name get_formal_similarity
#'
#' @title Compute Formal Indexes for Phoneme Data Analysis
#'
#' @description This function computes various formal indexes for analyzing phoneme data, providing insights into the similarity between target and response items. It calculates character counts, proportions of shared characters, differences in character counts, and several distance and similarity measures, which are valuable for evaluating phonological data.
#'
#' @param df A dataframe containing the data to analyze.
#' @param item_col The name of the column containing the target items. Default is `"item"`.
#' @param response_col The name of the column containing the response items. Default is `"Response"`.
#' @param attempt_col The name of the column indicating the attempt number or sequence. Used in conjunction with the `group_cols` parameter to handle repeated attempts (RAs) and to calculate the `"approach_diff"` metric. Default is `NULL`.
#' @param group_cols A character vector specifying the column names to group by before calculating indexes. Default is `NULL`.
#'
#' @details The function performs the following operations:
#' \itemize{
#'   \item \bold{targetL} and \bold{responseL}: Calculates the length of target and response strings, respectively.
#'   \item \bold{p_shared_char}: Computes the proportion of characters shared between the target and response strings.
#'   \item \bold{diff_char_num}: Calculates the difference in character counts between the target and response strings.
#'   \item \bold{Ld}: Computes the Levenshtein distance between the target and response strings, which measures the number of single-character edits required to transform one string into the other.
#'   \item \bold{DLd}: Computes the Damerau-Levenshtein distance between the target and response strings, an extension of Levenshtein distance accounting for transpositions of adjacent characters.
#'   \item \bold{JWd}: Computes the Jaro-Winkler similarity between the target and response strings, a metric that measures similarity based on character matches and transpositions.
#'   \item \bold{pcc}: Computes the proportion of correct characters (pcc), calculated as \(1 - (DLd / nchar(target))\).
#'   \item \bold{lcs}: Calculates the Longest Common Subsequence (LCS) between the target and response strings, using the `PTXQC::LCS` function and handling NA values.
#'   \item \bold{similarity_str}: Computes a similarity vector between the target and response strings (M = match, D = deletion, S = substitution, I = insertion).
#'   \item \bold{strict_match_pos}: Calculates positions where characters match exactly between the target and response strings.
#'   \item \bold{itemL_adj_strict_match_pos}: Adjusts the strict matching positions to the length of the target string, useful for computing positional data with other functions.
#'   \item \bold{comment_warning}: Adds a warning if the response contains spaces or commas, potentially indicating repeated attempts (RA) responses.
#'   \item \bold{approach_diff} (if `attempt_col` and `group_cols` are defined): Computes the difference in the proportion of correct characters (pcc) between consecutive attempts within each group defined by `group_cols`. This metric helps analyze changes in performance over multiple attempts.
#' }
#'
#' The function handles NA values appropriately, especially in character string operations like LCS and similarity measures. It prints the execution time of the function upon completion.
#'
#' If `attempt_col` is provided, it is mandatory to also specify `group_cols` for proper grouping. If `group_cols` is missing, the function will stop and display an error message requesting the `group_cols` specification. If `group_cols` is defined but `attempt_col` is not, the function will display a message suggesting that `attempt_col` could be useful for analyzing performance improvements across attempts.
#'
#' @returns A dataframe with the following additional columns:
#' \itemize{
#'   \item \bold{targetL}: Length of the target string.
#'   \item \bold{responseL}: Length of the response string.
#'   \item \bold{shared1char}: Indicator if the target and response start with the same letter.
#'   \item \bold{p_shared_char}: Proportion of shared characters between target and response.
#'   \item \bold{diff_char_num}: Difference in character counts between target and response.
#'   \item \bold{Ld}: Levenshtein distance between target and response.
#'   \item \bold{DLd}: Damerau-Levenshtein distance between target and response.
#'   \item \bold{JWd}: Jaro-Winkler similarity between target and response.
#'   \item \bold{pcc}: Proportion of correct characters.
#'   \item \bold{lcs}: Longest Common Subsequence between target and response.
#'   \item \bold{similarity_str}: Similarity vector between target and response (M, D, S, I).
#'   \item \bold{strict_match_pos}: String indicating exact matches between target and response positions.
#'   \item \bold{itemL_adj_strict_match_pos}: Adjusted match positions based on the length of the target.
#'   \item \bold{approach_diff}: Difference in the proportion of correct characters between attempts (if `attempt_col` is provided).
#'   \item \bold{comment_warning}: Warning for potential repeated attempt responses.
#' }
#'
#'
#' @export

get_formal_similarity <- function(df,
                              item_col = "item",
                              response_col = "Response",
                              attempt_col = NULL,  # attempt_col es NULL por defecto
                              group_cols = NULL) { # group_cols es NULL por defecto

  # Start timing for the total execution
  tictoc::tic()

  # Convert column names to symbols for use in group_by and arrange
  group_cols_syms <- if (!is.null(group_cols)) rlang::syms(group_cols) else NULL

  dataframe <- df %>%
    dplyr::mutate(
      targetL = nchar(.data[[item_col]]),
      responseL = nchar(.data[[response_col]]),
      shared1char = same_letter_start(.data[[item_col]], .data[[response_col]]),
      p_shared_char = mapply(shared_proportion, .data[[item_col]], .data[[response_col]]),
      diff_char_num = diff_char_count(.data[[item_col]], .data[[response_col]]),
      Ld = calculate_levenshtein(.data[[item_col]], .data[[response_col]]),
      DLd = calculate_damerau_levenshtein(.data[[item_col]], .data[[response_col]]),
      JWd = calculate_jaro_winkler(.data[[item_col]], .data[[response_col]]),
      pcc = 1 - (DLd / nchar(.data[[item_col]])) # pcc en Gutiérrez-Cordero et al.
    ) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      # Calculate LCS rowwise using PTXQC::LCS and handle NAs
      lcs = ifelse(is.na(.data[[item_col]]) | is.na(.data[[response_col]]),
                   NA_character_,
                   {
                     myLCS <- PTXQC::LCS(.data[[item_col]], .data[[response_col]])
                     paste(myLCS, collapse = "")  # Collapse LCS into a single string
                   }),

      # Skip calculations if NA in item_col or response_col
      similarity_str = ifelse(is.na(.data[[item_col]]) | is.na(.data[[response_col]]),
                              NA_character_,
                              similarity_vector(.data[[item_col]], .data[[response_col]])),

      # Calculate strict matching positions with NA handling
      strict_match_pos = ifelse(is.na(.data[[item_col]]) | is.na(.data[[response_col]]),
                                NA_character_,
                                {
                                  target <- as.character(.data[[item_col]])
                                  response <- as.character(.data[[response_col]])

                                  # Ensure both strings are of the same length
                                  max_length <- max(nchar(target), nchar(response))
                                  target <- sprintf(paste0("%-", max_length, "s"), target)
                                  response <- sprintf(paste0("%-", max_length, "s"), response)

                                  matching_positions <- sapply(seq_len(max_length), function(j) {
                                    if (substr(target, j, j) == substr(response, j, j)) "1" else "0"
                                  })

                                  paste(matching_positions, collapse = "")
                                }),

      # Adjust strict matching positions to the length of the item
      itemL_adj_strict_match_pos = ifelse(is.na(strict_match_pos),
                                          NA_character_,
                                          substr(strict_match_pos, 1, targetL)),

      # Add comment_warning if response_col contains a space or a comma
      comment_warning = ifelse(grepl("[ ,]", .data[[response_col]]),
                                "Could be a RA response.",
                                "")

    ) %>%
    dplyr::ungroup() # Ungroup after all rowwise operations are done

  # Si attempt_col is defined, verify whether group_cols is also defined
  if (!is.null(attempt_col) && attempt_col != "") {
    if (is.null(group_cols)) {
      # Mensaje de error personalizado
      stop("You must specify 'group_cols' when 'attempt_col' is provided in the get_formal_similarity() function.\nFor example: group_cols = c('ID', 'item_ID') if you are using two grouping variables or more,\nor group_cols = c('ID') if you are using just one.")
    }

    # Group and compute 'approach_diff'
    dataframe <- dataframe %>%
      dplyr::group_by(!!!group_cols_syms) %>%
      dplyr::mutate(
        approach_diff = pcc - lag(pcc, default = NA)
      ) %>%
      dplyr::ungroup()
  }

  # Si se define group_cols pero no attempt_col, mostrar un mensaje personalizado
  if (!is.null(group_cols) && is.null(attempt_col)) {
    # Convertir group_cols en un string con el formato c("col1", "col2", ...)
    group_cols_string <- paste0("c(", paste(shQuote(group_cols), collapse = ", "), ")")

    message(sprintf("You defined grouping columns using group_cols = %s. \nIt might be of your interest to also define 'attempt_col' to obtain a measure of approximation (approach_diff).", group_cols_string))
  }

  # End timing for the total execution and capture the elapsed time
  elapsed_time <- tictoc::toc(quiet = TRUE)

  # Print custom message with the elapsed time rounded to 2 decimal places
  message(sprintf("The function get_formal_similarity() took %.2f seconds to be executed", elapsed_time$toc - elapsed_time$tic))

  return(dataframe)
}


