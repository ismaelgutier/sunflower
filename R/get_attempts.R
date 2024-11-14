#' @name get_attempts
#'
#' @title Obtain attempts and responses in long format
#'
#' @description Transform a range of columns in a data frame from wide to long format. It starts from a specified column, referred to as `first_production`, and includes all columns to its right, which represent subsequent attempts. The function creates two new columns: `attempt`, indicating the attempt number, and `response`, showing the response for each attempt. Depending on the `drop_blank_spaces` parameter, rows with empty responses can be removed.
#'
#' @inheritParams separate_responses
#' @param first_production The column from which attempts start. For example, if `first_production` is `attempt_1`, it will include `attempt_1` and all columns to its right as subsequent attempts. Default is `attempt_1`.
#' @param drop_blank_spaces Logical. If `TRUE`, rows with empty responses are removed. If `FALSE`, these rows are kept in the output. Default is `FALSE`.
#' @returns A data frame in long format with columns `attempt` and `response`.
#'   - `attempt`: Indicates the attempt number.
#'   - `response`: Shows the response for the corresponding attempt, with `"#NONE"` replaced by `NA` if `drop_blank_spaces` is `TRUE`.
#' @examples
#' # Example usage:
#' require(tidyverse)
#' example_data = data.frame(ID = 1:4,
#'   item = c("article", "firefighter", "honey", "money"),
#'   response = c("ar, arm, art, article", "fire, far, firt, fire, firefigo, firefighter", "honey", "money"),
#'   stringsAsFactors = FALSE
#' )
#'
#' df_attempts = get_attempts(df = example_data, first_production = resp_1, drop_blank_spaces = FALSE)
#'
#' @export
get_attempts <- function(df,
                         first_production = attempt_1,
                         drop_blank_spaces = FALSE) {

  responses_attempts_long_format <- df %>%
    # Convert the DataFrame from wide format to long format
    tidyr::pivot_longer(
      cols = {{first_production}}:(rev(names(df))[1]),  # Select columns starting from `first_production` to the last column in the DataFrame
      names_to = "attempt",  # Create a new column named `attempt` for the names of the original columns
      values_to = "response"  # Create a new column named `response` for the values in the original columns
    ) %>%
    # Clean and transform data
    dplyr::mutate(
      # Remove the prefix "attempt_" from the `attempt` column
      attempt = stringr::str_replace(attempt, "attempt_", ""),
      # Replace empty strings in `response` with NA and ensure `response` is of character type
      response = ifelse(response == "", NA, as.character(response))
    )

  # Update attempt and response according to specific conditions
  responses_attempts_long_format <- responses_attempts_long_format %>%
    dplyr::mutate(
      # Set `attempt` to "0" if it was "1" and `response` is NA
      attempt = ifelse(attempt == "1" & is.na(response), "0", attempt),
      # Set `response` to "#NONE" if `attempt` is "0"
      response = ifelse(attempt == "0", "#NONE", response)
    )

  # Provide NA responses if requested
  if (drop_blank_spaces == TRUE) {
    responses_attempts_long_format <- responses_attempts_long_format %>%
      tidyr::drop_na(response) %>%
      tibble::as_tibble()
  } else {
    responses_attempts_long_format <- responses_attempts_long_format %>%
      tibble::as_tibble()
  }

  # Convert to data frame
  responses_attempts_long_format <- as.data.frame(responses_attempts_long_format) %>%
    # Replace "#NONE" with NA in response for the final returned dataframe
    dplyr::mutate(response = ifelse(response == "#NONE", NA, response))

  return(responses_attempts_long_format)
}

