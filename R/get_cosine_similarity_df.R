#' @name get_cosine_similarity_df
#'
#' @title Calculate Cosine Similarity Between Words in a DataFrame
#'
#' @description This function calculates the cosine similarity between the words in two specified columns of a dataframe using a provided word embedding model. It adds a new column, `cosine_similarity`, to the dataframe with the calculated similarity scores.
#'
#' @param df A data frame containing the words to compare.
#' @param target_col A string specifying the name of the column in the dataframe that contains the target words.
#' @param response_col A string specifying the name of the column in the dataframe that contains the response words.
#' @param model A word embedding model used to generate word vectors. The model should have a `predict` method that can return word embeddings.
#'
#' @details The function checks if the specified columns exist in the dataframe. For each pair of words (one from the `target_col` and one from the `response_col`) in each row, it retrieves their word embeddings using the provided model and computes the cosine similarity between them. If either word is invalid (e.g., contains spaces or commas), or if there's an error in processing, it returns `NA` for that pair. The resulting cosine similarity values are added to a new column named `cosine_similarity`.
#'
#' @returns A data frame with an additional column named `cosine_similarity`. This column contains the cosine similarity scores between the words in `target_col` and `response_col`. If an error occurs or the words are invalid, the value will be `NA`.
#'
#' @export
get_cosine_similarity_df <- function(df, target_col, response_col, model) {

  # Start timing for the total execution
  tictoc::tic()

  # Verificar si las columnas existen en el data frame
  if (!(target_col %in% names(df)) || !(response_col %in% names(df))) {
    stop("Las columnas especificadas no existen en el data frame.")
  }

  # Función auxiliar para calcular la similitud coseno para una fila
  calculate_similarity <- function(word1, word2) {
    # Ignorar palabras no válidas
    if (grepl("[, ]", word1) || grepl("[, ]", word2)) {
      return(NA)
    }

    tryCatch({
      # Obtener los vectores de palabras
      vec_word1 <- stats::predict(model, word1, type = "embedding")
      vec_word2 <- stats::predict(model, word2, type = "embedding")

      # Calcular la similitud coseno
      word2vec::word2vec_similarity(vec_word1, vec_word2, type = "cosine")
    }, error = function(e) {
      warning(sprintf("Error al procesar '%s' y '%s': %s", word1, word2, e$message))
      return(NA)
    })
  }

  # Añadir la columna de similitud coseno al data frame
  df$cosine_similarity <- apply(df, 1, function(row) {
    calculate_similarity(row[target_col], row[response_col])
  })

  # End timing for the total execution and capture the elapsed time
  elapsed_time <- tictoc::toc(quiet = TRUE)

  # Print custom message with the elapsed time rounded to 2 decimal places
  message(sprintf("The function get_cosine_similarity_df() took %.2f seconds to be executed", elapsed_time$toc - elapsed_time$tic))


  return(df)
}

