#' @name get_formal_metrics
#'
#' @title Compute formal metrics for to allow their analysis
#'
#' @description This function computes various formal metrics to analyze phoneme data. It calculates character counts, shared proportions, differences in character counts, Levenshtein distance, Damerau-Levenshtein distance, Jaro-Winkler similarity, and other metrics for comparing target and response columns in a dataframe.
#'
#' @param df A dataframe containing the data to analyze.
#' @param item_col The name of the column containing the target items. Default is `"item"`.
#' @param response_col The name of the column containing the response items. Default is `"Response"`.
#' @param attempt_col The name of the column indicating the attempt number or sequence. Default is `"Attempt"`.
#' @param group_cols A character vector specifying the column names to group by before calculating metrics. Default is `c("ID", "item_ID")`.
#'
#' @details The function performs the following operations:
#' \itemize{
#'   \item Calculates the length of target and response strings.
#'   \item Computes proportions of shared characters and positions.
#'   \item Calculates differences in character counts, Levenshtein distance, Damerau-Levenshtein distance, and Jaro-Winkler similarity.
#'   \item Computes the proportion of correct characters (pcc) and approach difference.
#'   \item Determines if the target and response have the same length and are identical.
#'   \item Calculates the longest common subsequence (LCS) and similarity vector.
#'   \item Computes strict matching positions between target and response strings.
#'   \item Adjusts strict matching positions to the length of the target.
#' }
#'
#' The function uses the `PTXQC::LCS` function for LCS calculation and handles NA values appropriately. It also prints the execution time of the function.
#'
#' @returns A dataframe with additional columns for the calculated metrics.
#'
#' @examples
#' #require(tictoc); require(dplyr); require(rlang)
#'
#' data("IGC_long")
#'
#' result <- get_formal_metrics(df = IGC_long,
#'                                 item_col = "item",
#'                                 response_col = "Response",
#'                                 attempt_col = "Attempt",
#'                                 group_cols = c("ID", "item_ID"))
#'
#' head(result)
#'
#' @export
get_formal_metrics <- function(df,
                                   item_col = "item",
                                   response_col = "Response",
                                   attempt_col = "Attempt",
                                   group_cols = c("ID", "item_ID")) {

  # Start timing for the total execution
  tictoc::tic()

  # Convert column names to symbols for use in group_by and arrange
  group_cols_syms <- rlang::syms(group_cols)

  dataframe <- df %>%
    dplyr::mutate(
      targetL = nchar(.data[[item_col]]),
      responseL = nchar(.data[[response_col]]),
      p_shared_char = mapply(shared_proportion, .data[[item_col]], .data[[response_col]]),
      p_shared_char_in_pos = mapply(shared_proportion_pos_ok, .data[[item_col]], .data[[response_col]]),
      diff_char_num = diff_char_count(.data[[item_col]], .data[[response_col]]),
      Ld = calculate_levenshtein(.data[[item_col]], .data[[response_col]]),
      DLd = calculate_damerau_levenshtein(.data[[item_col]], .data[[response_col]]),
      JWd = calculate_jaro_winkler(.data[[item_col]], .data[[response_col]]),
      pcc = 1 - (DLd / nchar(.data[[item_col]])) #pcp in Gutiérrez-Cordero et al.
    ) %>%
    # Arrange by grouping columns and Attempt
    dplyr::arrange(!!!group_cols_syms, .data[[attempt_col]]) %>%
    dplyr::group_by(!!!group_cols_syms) %>%
    dplyr::mutate(
      approach_diff = pcc - lag(pcc, default = NA),
      accessed = ifelse(p_shared_char_in_pos == 1, 1, 0)
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
                                          substr(strict_match_pos, 1, targetL))

    ) %>%
    dplyr::ungroup() # Ungroup after all rowwise operations are done

  # End timing for the total execution and capture the elapsed time
  elapsed_time <- tictoc::toc(quiet = TRUE)

  # Print custom message with the elapsed time rounded to 2 decimal places
  message(sprintf("The function get_formal_metrics() took %.2f seconds to be executed", elapsed_time$toc - elapsed_time$tic))

  return(dataframe)
}
