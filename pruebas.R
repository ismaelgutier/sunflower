
m_w2v = word2vec::read.word2vec(file = file.choose(), normalize = TRUE)

require(tidyverse)

a = sunflower::IGC_long %>% dplyr::select(item:Response, accessed) %>%
  check_lexicality(item_col = "item", response_col = "Response", criterion = "dictionary") %>% #ok
  get_formal_similarity(item_col = "item", response_col = "Response") %>% #ok
  get_semantic_similarity(target_col = "item", response_col = "Response", model = m_w2v) %>% #ok
  classify_errors(access_col = "accessed", RA_col = "RA",
                           response_col = "Response", item_col = "item",
                           lexicality_criterion = "database", also_classify_RAs = T)
#%>%   dplyr::select(item, Response, nonword) %>% View()
View(a)



b = sunflower::IGC %>% dplyr::select(item:final_response, accessed) %>%
  formal_similarity(item_col = "item", response_col = "final_response")

View(b)

c = sunflower::IGC_long %>% dplyr::select(item:Response, accessed) %>% check_lexicality(item_col = "item", response_col = "Response")
View(c)



get_error_classification <- function(dataframe, access_col = "accessed", RA_col = "RA",
                                     lexicality_criterion = "database", cosine_limit_value = 0.46,
                                     item_col = "item", response_col = "response",
                                     also_classify_RAs = FALSE) {

  # Add the comparison results to the dataframe
  dataframe <- dataframe %>%
    dplyr::mutate(nonword = ifelse(
      .data[[access_col]] != 1 &
        lexicality == 0 &
        p_shared_char >= 0.50,
      1, 0
    ),
    neologism = ifelse(
      .data[[access_col]] != 1 &
        lexicality == 0 &
        p_shared_char < 0.50,
      1, 0
    ),
    formal = ifelse(
      .data[[access_col]] != 1 &
        lexicality == 1 &
        cosine_similarity < cosine_limit_value &
        (p_shared_char >= 0.50 | shared1char == 1),
      1, 0
    ),
    unrelated = ifelse(
      .data[[access_col]] != 1 &
        lexicality == 1 &
        cosine_similarity < cosine_limit_value &
        (p_shared_char < 0.50 & shared1char != 1),
      1, 0
    ),
    mixed = ifelse(
      .data[[access_col]] != 1 &
        lexicality == 1 &
        (p_shared_char >= 0.50 | shared1char == 1) &
        cosine_similarity >= cosine_limit_value,
      1, 0
    ),
    semantic = ifelse(
      .data[[access_col]] != 1 &
        mixed != 1 &
        formal != 1 &
        unrelated != 1 &
        lexicality == 1 &
        cosine_similarity >= cosine_limit_value,
      1, 0
    ),
    no_response = ifelse(
      is.na(get(response_col)) | get(response_col) == " ",
      1, 0
    ),
    # Set errors to NA if RA is 1 unless also_classify_RAs is TRUE
    dplyr::across(c(nonword, neologism, formal, unrelated, mixed, semantic, no_response),
                  ~ ifelse(!also_classify_RAs & .data[[RA_col]] == 1, NA, .)),
    # New column for human check
    human_check = dplyr::case_when(
      !also_classify_RAs & .data[[RA_col]] == 1 ~ "is only considered as RA",
      rowSums(dplyr::across(c(nonword, neologism, formal, unrelated, mixed, semantic, no_response)), na.rm = TRUE) + .data[[access_col]] >= 2 ~ "required",
      rowSums(dplyr::across(c(nonword, neologism, formal, unrelated, mixed, semantic, no_response)), na.rm = TRUE) + .data[[access_col]] == 0 ~ "required",
      TRUE ~ ""
    )
    )

  return(dataframe)
}
