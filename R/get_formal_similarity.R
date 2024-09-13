#' @name get_formal_similarity
#'
#' @title Compute Formal Indexes for Phoneme Data Analysis
#'
#' @description This function computes various formal indexes for analyzing phoneme data, providing insights into the similarity between target and response items. It includes character counts, shared proportions, differences in character counts, and several distance and similarity measures.
#'
#' @param df A dataframe containing the data to analyze.
#' @param item_col The name of the column containing the target items. Default is `"item"`.
#' @param response_col The name of the column containing the response items. Default is `"Response"`.
#' @param attempt_col The name of the column indicating the attempt number or sequence. It is defined to work along with the `group_cols` parameter, allowing to handle repeated attempts (RAs) responses and obtain `"approach_diff"`. Default is `NULL`.
#' @param group_cols A character vector specifying the column names to group by before calculating indexes. Default is `NULL`.
#'
#' @details The function performs the following operations:
#' \itemize{
#'   \item \bold{targetL} and \bold{responseL}: Calculates the length of target and response strings, respectively.
#'   \item \bold{p_shared_char}: Computes the proportion of characters shared between the target and response strings.
#'   \item \bold{diff_char_num}: Calculates the difference in character counts between the target and response strings.
#'   \item \bold{Ld}: Computes the Levenshtein distance between the target and response strings, which measures the number of single-character edits required to transform one string into the other.
#'   \item \bold{DLd}: Computes the Damerau-Levenshtein distance between the target and response strings, which is an extension of the Levenshtein distance that also accounts for transpositions of adjacent characters.
#'   \item \bold{JWd}: Computes the Jaro-Winkler similarity between the target and response strings, a metric that measures the similarity between two strings based on character matches and transpositions.
#'   \item \bold{pcc}: Computes the proportion of correct characters (pcc), calculated as \(1 - (DLd / nchar(target))\).
#'   \item \bold{lcs}: Calculates the Longest Common Subsequence (LCS) between the target and response strings, handling NA values appropriately if one is missing. The LCS is the longest sequence that can be derived from both strings without changing the order of characters.
#'   \item \bold{similarity_str}: Computes a similarity vector between the target and response strings (M = match, D = deletion, S = substitution; I = insertion).
#'   \item \bold{strict_match_pos}: Calculates strict matching positions between the target and response strings, indicating where characters match exactly per position between target and response.
#'   \item \bold{itemL_adj_strict_match_pos}: Adjusts the strict matching positions to the length of the target string. Useful to compute positional data with `position_scores()` function.
#'   \item \bold{approach_diff} (if `attempt_col` and `group_cols` are both defined): Computes the difference in the proportion of correct characters (pcc) between consecutive attempts within each group defined by `group_cols`. This metric helps analyze changes in performance over multiple attempts.
#' }
#'
#' The function uses the `PTXQC::LCS` function for LCS calculation and handles NA values appropriately. It also prints the execution time of the function.
#'
#' If `attempt_col` is provided, it is necessary to specify `group_cols` for proper grouping. If `group_cols` is not defined while `attempt_col` is provided, the function will stop with an error message requesting the `group_cols` specification. Conversely, if `group_cols` is defined but `attempt_col` is not, the function will display a message suggesting the possible interest in defining `attempt_col` for computing `approach_diff`.
#'
#' @returns A dataframe with additional columns for the calculated indexes.
#'
#' @examples
#' #require(tictoc); require(dplyr); require(rlang)
#'
#' bb = midflong %>% get_formal_similarity(item_col = "item", response_col = "Response")
#' print(bb)
#'
#' aa = midflong %>% get_formal_similarity(item_col = "item", response_col = "Response", group_cols = c("ID", "item_ID"))
#' print(aa)
#'
#' cc = midflong %>% get_formal_similarity(item_col = "item", response_col = "Response", attempt_col = "Attempt", group_cols = c("ID"))
#' View(cc)
#'
#' dd = midflong %>% get_formal_similarity(item_col = "item", response_col = "Response", attempt_col = "Attempt")
#' print(dd)
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

      # Add comment_get_formal_similarity if response_col contains a space or a comma
      comment_get_formal_similarity = ifelse(grepl("[ ,]", .data[[response_col]]),
                                         "Could be a RA response.",
                                         NA_character_)

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


