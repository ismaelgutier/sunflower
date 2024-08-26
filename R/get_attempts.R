#' @name get_attempts
#'
#' @title Obtain attempts and responses in long format
#'
#' @description Transform a range of columns in a data frame from wide to long format. It starts from a specified column, referred to as `first_production`, and includes all columns to its right, which represent subsequent attempts. The function creates two new columns: `Attempt`, indicating the attempt number, and `Response`, showing the response for each attempt. Depending on the `drop_blank_spaces` parameter, rows with empty responses can be removed.
#'
#' @inheritParams separate_responses
#' @param first_production The column from which attempts start. For example, if `first_production` is `Attempt_1`, it will include `Attempt_1` and all columns to its right as subsequent attempts. Default is `Attempt_1`.
#' @param drop_blank_spaces Logical. If `TRUE`, rows with empty responses are removed. If `FALSE`, these rows are kept in the output. Default is `FALSE`.
#' @returns A data frame in long format with columns `Attempt` and `Response`.
#'   - `Attempt`: Indicates the attempt number.
#'   - `Response`: Shows the response for the corresponding attempt, with `"#NONE"` replaced by `NA` if `drop_blank_spaces` is `TRUE`.
#' @examples
#' # Example usage:
#' require(tidyverse)
#' example_data = data.frame(ID = 1:4,
#'   item = c("article", "firefighter", "honey", "money"),
#'   Response = c("ar, arm, art, article", "fire, far, firt, fire, firefigo, firefighter", "honey", "money"),
#'   stringsAsFactors = FALSE
#' )
#'
#' df_attempts = get_attempts(df = example_data, first_production = resp_1, drop_blank_spaces = FALSE)
#'
#' @export
get_attempts <- function(df,
                         first_production = Attempt_1,
                         drop_blank_spaces = FALSE) {

  responses_attempts_long_format <- df %>%
    # Convert the DataFrame from wide format to long format
    tidyr::pivot_longer(
      cols = {{first_production}}:(rev(names(df))[1]),  # Select columns starting from `first_production` to the last column in the DataFrame
      names_to = "Attempt",  # Create a new column named `Attempt` for the names of the original columns
      values_to = "Response"  # Create a new column named `Response` for the values in the original columns
    ) %>%
    # Clean and transform data
    dplyr::mutate(
      # Remove the prefix "Attempt_" from the `Attempt` column
      Attempt = str_replace(Attempt, "Attempt_", ""),
      # Replace empty strings in `Response` with NA and ensure `Response` is of character type
      Response = ifelse(Response == "", NA, as.character(Response))
    )

  # Update Attempt and Response according to specific conditions
  responses_attempts_long_format <- responses_attempts_long_format %>%
    dplyr::mutate(
      # Set `Attempt` to "0" if it was "1" and `Response` is NA
      Attempt = ifelse(Attempt == "1" & is.na(Response), "0", Attempt),
      # Set `Response` to "#NONE" if `Attempt` is "0"
      Response = ifelse(Attempt == "0", "#NONE", Response)
    )

  # Provide NA responses if requested
  if (drop_blank_spaces == TRUE) {
    responses_attempts_long_format <- responses_attempts_long_format %>%
      tidyr::drop_na(Response) %>%
      tibble::as_tibble()
  } else {
    responses_attempts_long_format <- responses_attempts_long_format %>%
      tibble::as_tibble()
  }

  # Convert to data frame
  responses_attempts_long_format <- as.data.frame(responses_attempts_long_format) %>%
    # Replace "#NONE" with NA in Response for the final returned dataframe
    dplyr::mutate(Response = ifelse(Response == "#NONE", NA, Response))

  return(responses_attempts_long_format)
}

