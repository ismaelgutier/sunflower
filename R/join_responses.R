#' @name join_responses
#'
#' @title Join several columns in only one response column
#'
#' @description Joins several columns containing responses into a single column, with a specified separator between the responses.
#'
#' @inheritParams separate_responses
#' @param resp_start The starting column for responses to join. This can be specified by column name (e.g., "response") or column position (e.g., 9). All response columns must be contiguous.
#' @param resp_end The ending column for responses to join. By default, this is the last column in the data frame (i.e., `ncol(df)`).
#' @param separator A character string used to separate the joined responses. Default is ", ".
#' @param drop_merged_cols Logical indicating whether to drop the original columns after merging. If `TRUE`, the original columns will be removed. Default is `TRUE`.
#' @param remove_NA_values Logical indicating whether to exclude `NA` values from the joined responses. If `TRUE`, `NA` values will be removed as rows. Default is `TRUE`.
#' @param show_previous Logical indicating whether to include the columns not used in the merge (e.g., identifier columns) in the output. If `TRUE`, these columns will be included. Default is `TRUE`.
#'
#' @returns A data frame if `show_previous = TRUE`, or a tibble if `show_previous = FALSE`.
#'
#' @export
join_responses <- function(df,
                           resp_start = "response",
                           resp_end = ncol(df),
                           separator = ", ",
                           drop_merged_cols = TRUE,
                           remove_NA_values = TRUE,
                           show_previous = TRUE) {

  # clean prior dataframe to keep ID columns
  previous <- df %>% select(-c({{resp_start}}:{{resp_end}}))

  # get response columns to be merged
  new <- df %>% select({{resp_start}}:{{resp_end}}) %>%
    # Replace empty strings with NA
    mutate(across(everything(), ~ na_if(.x, ""))) %>%
    unite(
      col = responses,
      sep = separator,
      remove = drop_merged_cols,
      na.rm = remove_NA_values
    ) %>%
    # Convert empty responses to NA
    mutate(responses = na_if(responses, ""))

  # provide ID columns if requested
  if (show_previous == TRUE) {
    cbind(previous, new)
  } else {
    new
  }
}
