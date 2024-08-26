shared_proportion_df <- function(df, target_col_name, response_col_name) {
  # Extract columns from the dataframe
  target_col <- df[[target_col_name]]
  response_col <- df[[response_col_name]]

  # Initialize a vector to store the shared proportion for each row
  shared_proportions <- numeric(nrow(df))

  for (i in 1:nrow(df)) {
    # Convert words to lowercase
    target_word <- tolower(target_col[i])
    response_word <- tolower(response_col[i])

    # Convert words into character vectors
    target_word_chars <- unlist(strsplit(target_word, ""))
    response_word_chars <- unlist(strsplit(response_word, ""))

    # Count shared letters
    shared_letters <- 0

    # Count each shared letter only once per occurrence in response_col
    for (letter in target_word_chars) {
      if (letter %in% response_word_chars) {
        shared_letters <- shared_letters + 1
        # Remove the first occurrence of the letter in response_col
        response_word_chars <- response_word_chars[-which(response_word_chars == letter)[1]]
      }
    }

    # Calculate the total number of letters in both words
    total_letters <- nchar(target_word) + nchar(response_word)

    # Calculate the percentage of shared letters
    shared_proportions[i] <- (shared_letters * 2) / total_letters
  }

  # Add the result as a new column to the dataframe
  df$shared_proportion <- shared_proportions

  return(df)
}
