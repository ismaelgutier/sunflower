
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sunflower: A Package to Assess and Categorize Language Production Errors

<!-- badges start -->

![](https://img.shields.io/badge/sunflower-v._0.2.0-orange?style=flat&link=https%3A%2F%2Fgithub.com%2Fismaelgutier%2Fsunflower)
[![License: GPL
v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
![](https://img.shields.io/badge/Language-grey?style=flat&logo=R&color=grey&link=https%3A%2F%2Fwww.r-project.org%2F)

<!-- badges end -->
<div align="justify">

The goal of *sunflower* is to help to manage multiple response data,
compute formal similarity indices to assess the quality of oral and
written productions in patients with aphasia and other related disorders
such as apraxia of speech in Spanish, and classify these productions
according to classical typological in the field of Speech Therapy and
Neuropsychology of Language.

*sunflower* partially relies on natural language processing models, such
as word2vec, to compute semantic similarity measures. The outputs
provided by this package facilitate statistical analyses in
[R](https://www.r-project.org/), a common tool in our field used for
data wrangling, visualization and analysis.

## Installation

*sunflower* can be installed as an R package with:

``` r
install.packages("devtools")
devtools::install_github("ismaelgutier/sunflower")
```

While *sunflower* can work by simply relying on R native pipes (`|>`),
it is recommended to install the [*tidyverse*
package](https://www.tidyverse.org/) as it allow to use *tidyverse*
pipes (`%>%`) and functions from packages like *dplyr*, *readr*, and
*ggplot2* to support the work.

``` r
install.packages("tidyverse")
```

## How to use

### Loading the packages

We only need to load two packages: *sunflower* and *tidyverse* for
support.

``` r
require("sunflower")
require("tidyverse")
```

### Compute Formal Quality Indexes

``` r
df_to_formal_metrics = sunflower::IGC_long_phon %>% select(-c(modality, task_modality,task_type, test, task))


formal_metrics_computed = df_to_formal_metrics %>% 
                                  get_formal_indexes(item_col = "item_phon",
                                       response_col = "response_phon",
                                       attempt_col = "Attempt",
                                       group_cols = c("ID", "item_ID"))
#> The function get_formal_indexes() took 1.21 seconds to be executed

formal_metrics_computed %>% head(8) %>% knitr::kable()
```

|  ID | item_ID | item  | item_phon |  RA | Attempt | response | response_phon | targetL | responseL | p_shared_char | p_shared_char_in_pos | diff_char_num |  Ld | DLd |       JWd | pcc | approach_diff | accessed | lcs   | similarity_str | strict_match_pos | itemL_adj_strict_match_pos |
|----:|--------:|:------|:----------|----:|--------:|:---------|:--------------|--------:|----------:|--------------:|---------------------:|--------------:|----:|----:|----------:|----:|--------------:|---------:|:------|:---------------|:-----------------|:---------------------------|
| 517 |       1 | vago  | baɡo      |   0 |       1 | vago     | baɡo          |       4 |         4 |     1.0000000 |                  1.0 |             0 |   0 |   0 | 0.0000000 | 1.0 |            NA |        1 | baɡo  | MMMM           | 1111             | 1111                       |
| 518 |       2 | bario | baɾjo     |   0 |       1 | bario    | baɾjo         |       5 |         5 |     1.0000000 |                  1.0 |             0 |   0 |   0 | 0.0000000 | 1.0 |            NA |        1 | baɾjo | MMMMM          | 11111            | 11111                      |
| 519 |       3 | tenia | tenja     |   0 |       1 | tenia    | tenja         |       5 |         5 |     1.0000000 |                  1.0 |             0 |   0 |   0 | 0.0000000 | 1.0 |            NA |        1 | tenja | MMMMM          | 11111            | 11111                      |
| 520 |       4 | medio | medjo     |   0 |       1 | medio    | medjo         |       5 |         5 |     1.0000000 |                  1.0 |             0 |   0 |   0 | 0.0000000 | 1.0 |            NA |        1 | medjo | MMMMM          | 11111            | 11111                      |
| 521 |       5 | patio | patjo     |   0 |       1 | patio    | patjo         |       5 |         5 |     1.0000000 |                  1.0 |             0 |   0 |   0 | 0.0000000 | 1.0 |            NA |        1 | patjo | MMMMM          | 11111            | 11111                      |
| 522 |       6 | veloz | beloθ     |   1 |       1 | ver      | beɾ           |       5 |         3 |     0.5000000 |                  0.4 |             4 |   3 |   3 | 0.2488889 | 0.4 |            NA |        0 | be    | MMSDD          | 11000            | 11000                      |
| 522 |       6 | veloz | beloθ     |   1 |       2 | lo       | lo            |       5 |         2 |     0.5714286 |                  0.0 |             3 |   3 |   3 | 1.0000000 | 0.4 |           0.0 |        0 | lo    | DDMMD          | 00000            | 00000                      |
| 522 |       6 | veloz | beloθ     |   1 |       3 | feloz    | feloθ         |       5 |         5 |     0.8000000 |                  0.8 |             2 |   1 |   1 | 0.1333333 | 0.8 |           0.4 |        0 | eloθ  | SMMMM          | 01111            | 01111                      |

`Note`: Move the dataframe to the right to see all the columns and
metrics.

### Obtain Positional Accuracy Data

``` r
positions_accuracy = formal_metrics_computed %>% 
  position_scores(match_col = "itemL_adj_strict_match_pos", last_ID_col = "targetL")

positions_accuracy %>% head(8) %>% knitr::kable()
```

|  ID | item_ID | item  | item_phon |  RA | Attempt | response | response_phon | targetL | Position | correct_pos |
|----:|--------:|:------|:----------|----:|--------:|:---------|:--------------|--------:|:---------|:------------|
| 517 |       1 | vago  | baɡo      |   0 |       1 | vago     | baɡo          |       4 | 1        | 1           |
| 517 |       1 | vago  | baɡo      |   0 |       1 | vago     | baɡo          |       4 | 2        | 1           |
| 517 |       1 | vago  | baɡo      |   0 |       1 | vago     | baɡo          |       4 | 3        | 1           |
| 517 |       1 | vago  | baɡo      |   0 |       1 | vago     | baɡo          |       4 | 4        | 1           |
| 518 |       2 | bario | baɾjo     |   0 |       1 | bario    | baɾjo         |       5 | 1        | 1           |
| 518 |       2 | bario | baɾjo     |   0 |       1 | bario    | baɾjo         |       5 | 2        | 1           |
| 518 |       2 | bario | baɾjo     |   0 |       1 | bario    | baɾjo         |       5 | 3        | 1           |
| 518 |       2 | bario | baɾjo     |   0 |       1 | bario    | baɾjo         |       5 | 4        | 1           |

***Note.*** A plot depicting the positions’ accuracy of 14,418
datapoints.

<img src="man/figures/README-plot_positions-1.png" width="75%" style="display: block; margin: auto;" />

### Classify Errors

``` r
errors_classified = df_to_classify %>% 
  get_formal_similarity(target_col = "item", response_col = "Response", 
                            item_type = "task_type", source1 = wordlist) %>%
  get_semantic_similarity(target_col = "item", response_col = "Response", model = m_w2v) %>%
  classify_errors(access_col = "accessed", RA_col = "RA", response_col = "Response", classify_RAs = T)
#> The function get_formal_similarity() took 3.62 seconds to be executed
#> The function get_semantic_similarity() took 4.28 seconds to be executed

errors_classified %>% head(8) %>% knitr::kable()
```

|  ID | item_ID | item  |  RA | Attempt | Response | targetL | responseL | p_shared_char | p_shared_char_in_pos | diff_char_num |  Ld | DLd |       JWd | pcc | approach_diff | correct | lcs   | similarity_str | strict_match_pos | itemL_adj_strict_match_pos | shared_proportion | shared1char | is_plural | is_target_nonword | same_root | is_response_word | cosine_similarity | lexicalization | nonword | neologism | formal | unrelated | mixed | semantic | no_response | human_check |
|----:|--------:|:------|----:|--------:|:---------|--------:|----------:|--------------:|---------------------:|--------------:|----:|----:|----------:|----:|--------------:|--------:|:------|:---------------|:-----------------|:---------------------------|------------------:|------------:|----------:|------------------:|----------:|-----------------:|------------------:|---------------:|--------:|----------:|-------:|----------:|------:|---------:|------------:|:------------|
| 517 |       1 | vago  |   0 |       1 | vago     |       4 |         4 |     1.0000000 |                  1.0 |             0 |   0 |   0 | 0.0000000 | 1.0 |            NA |       1 | vago  | MMMM           | 1111             | 1111                       |         1.0000000 |           1 |         0 |                 0 |         1 |                1 |         1.0000000 |              0 |       0 |         0 |      0 |         0 |     0 |        0 |           0 |             |
| 518 |       2 | bario |   0 |       1 | bario    |       5 |         5 |     1.0000000 |                  1.0 |             0 |   0 |   0 | 0.0000000 | 1.0 |            NA |       1 | bario | MMMMM          | 11111            | 11111                      |         1.0000000 |           1 |         0 |                 0 |         1 |                1 |         1.0000000 |              0 |       0 |         0 |      0 |         0 |     0 |        0 |           0 |             |
| 519 |       3 | tenia |   0 |       1 | tenia    |       5 |         5 |     1.0000000 |                  1.0 |             0 |   0 |   0 | 0.0000000 | 1.0 |            NA |       1 | tenia | MMMMM          | 11111            | 11111                      |         1.0000000 |           1 |         0 |                 0 |         1 |                1 |         1.0000000 |              0 |       0 |         0 |      0 |         0 |     0 |        0 |           0 |             |
| 520 |       4 | medio |   0 |       1 | medio    |       5 |         5 |     1.0000000 |                  1.0 |             0 |   0 |   0 | 0.0000000 | 1.0 |            NA |       1 | medio | MMMMM          | 11111            | 11111                      |         1.0000000 |           1 |         0 |                 0 |         1 |                1 |         1.0000000 |              0 |       0 |         0 |      0 |         0 |     0 |        0 |           0 |             |
| 521 |       5 | patio |   0 |       1 | patio    |       5 |         5 |     1.0000000 |                  1.0 |             0 |   0 |   0 | 0.0000000 | 1.0 |            NA |       1 | patio | MMMMM          | 11111            | 11111                      |         1.0000000 |           1 |         0 |                 0 |         1 |                1 |         1.0000000 |              0 |       0 |         0 |      0 |         0 |     0 |        0 |           0 |             |
| 522 |       6 | veloz |   1 |       1 | ver      |       5 |         3 |     0.5000000 |                  0.4 |             4 |   3 |   3 | 0.2488889 | 0.4 |            NA |       0 | ve    | MMSDD          | 11000            | 11000                      |         0.5000000 |           1 |         0 |                 0 |         0 |                1 |         0.2804400 |              0 |       0 |         0 |      0 |         1 |     0 |        0 |           0 |             |
| 522 |       6 | veloz |   1 |       2 | lo       |       5 |         2 |     0.5714286 |                  0.0 |             3 |   3 |   3 | 1.0000000 | 0.4 |           0.0 |       0 | lo    | DDMMD          | 00000            | 00000                      |         0.5714286 |           0 |         0 |                 0 |         0 |                1 |         0.3502317 |              0 |       0 |         0 |      0 |         1 |     0 |        0 |           0 |             |
| 522 |       6 | veloz |   1 |       3 | feloz    |       5 |         5 |     0.8000000 |                  0.8 |             2 |   1 |   1 | 0.1333333 | 0.8 |           0.4 |       0 | eloz  | SMMMM          | 01111            | 01111                      |         0.8000000 |           0 |         0 |                 0 |         0 |                0 |                NA |              0 |       1 |         0 |      0 |        NA |     0 |        0 |           0 |             |

***Notes.*** Move the dataframe to the right to see all the columns and
errors.

To enable *sunflower* to classify errors, it requires good “nutrients”.
These are (1) word list sources, such as `source1 = wordlist`, a .txt
file located in the dependency-bundle zip, which can be found in our
supplementary [OSF repository mirror](https://osf.io/akuxv/); users can
set up to 3 sources. And (2) a NLP model, in our case this is
`model = m_w2v`, a binary file containing a Spanish Billion Word
embeddings corpus created using the word2vec algorithm, also located in
the same zip file (see the markdown in the vignettes for further
information).

The quality of the classification performed directly depends on the
quality of the source files. Some words might not be available in the
`wordlist`, which comes from a prestigious Spanish dictionary (RAE). We
cannot solve this issue except by using double-checking and human
supervision.

------------------------------------------------------------------------

Any suggestions, comments, or questions about the functionality of the
package are warmly welcomed. If you are interested in contributing to
the project, please feel free to contact us.

Thank you 🌻
