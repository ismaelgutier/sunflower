
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sunflower: A Package to Assess and Categorize Language Production Errors

<!-- badges start -->

![](https://img.shields.io/badge/sunflower-v._0.14.11-orange?style=flat&link=https%3A%2F%2Fgithub.com%2Fismaelgutier%2Fsunflower)
[![License: GPL
v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
![](https://img.shields.io/badge/Language-grey?style=flat&logo=R&color=grey&link=https%3A%2F%2Fwww.r-project.org%2F)

<!-- badges end -->
<div align="justify">

*sunflower* is a package designed to assist clinicians and researchers
in the fields of Speech Therapy and Neuropsychology of Language. Its
primary goal is to facilitate the management of multiple response data
and compute formal similarity indices to assess the quality of oral and
written productions in patients with aphasia and related disorders, such
as apraxia of speech, in Spanish. Additionally, the package allows for
the classification of these productions according to classical
typologies in the field, prior to computing formal and semantic
similarity measures. For the computation of the latter, *sunflower*
partially relies on natural language processing models such as word2vec.
The outputs provided by this package facilitate statistical analyses in
R, a widely-used tool in the field for data wrangling, visualization,
and analysis.

## Installation

*sunflower* can be installed as an R package with:

``` r
install.packages("devtools")
devtools::install_github("ismaelgutier/sunflower")
```

The *sunflower* package works using the pipe operator (`%>%`) from the
[*tidyverse* package](https://www.tidyverse.org/), allowing it to work
seamlessly with functions from other packages in the *tidyverse*, such
as *dplyr* for data wrangling, *readr* for data reading, and *ggplot2*
for data visualization. This can significantly enhance our workflow.

## How to use

### Loading the packages

Once installed, we only need to load the *sunflower* package. However,
as previously mentioned, the *tidyverse* package can also be valuable
for other complementary tasks.

``` r
require("sunflower")
require("tidyverse")
```

### Compute Formal Quality Indexes

``` r

load("data/mine/IGC_long_phon.RDA")

df_to_formal_metrics = IGC_long_phon

formal_metrics_computed = df_to_formal_metrics %>% 
    get_formal_similarity(item_col = "item_phon", 
                          response_col = "response_phon",
                          attempt_col = "Attempt",
                          group_cols = c("ID", "item_ID"))
#> The function get_formal_similarity() took 1.17 seconds to be executed

formal_metrics_computed %>% head(8) %>% knitr::kable()
```

|   ID | task                          | item_ID | item       | response   | item_phon  | response_phon |  RA | Attempt | accessed | targetL | responseL | shared1char | p_shared_char | diff_char_num |  Ld | DLd |       JWd |       pcc | lcs        | similarity_str | strict_match_pos | adj_strict_match_pos | comment_warning | approach_diff |
|-----:|:------------------------------|--------:|:-----------|:-----------|:-----------|:--------------|----:|--------:|---------:|--------:|----------:|:------------|--------------:|--------------:|----:|----:|----------:|----------:|:-----------|:---------------|:-----------------|:---------------------|:----------------|--------------:|
|  517 | Gutiérrez-Cordero_w_rep_task1 |       1 | vago       | vago       | baɡo       | baɡo          |   0 |       1 |        1 |       4 |         4 | TRUE        |     1.0000000 |             0 |   0 |   0 | 0.0000000 | 1.0000000 | baɡo       | MMMM           | 1111             | 1111                 |                 |            NA |
|  637 | Gutiérrez-Cordero_w_rep_task2 |       1 | rellano    | rellano    | reʎano     | reʎano        |   0 |       1 |        1 |       6 |         6 | TRUE        |     1.0000000 |             0 |   0 |   0 | 0.0000000 | 1.0000000 | reʎano     | MMMMMM         | 111111           | 111111               |                 |            NA |
|  797 | Gutiérrez-Cordero_w_rep_task3 |       1 | melancolía | melancolía | melankolia | melankolia    |   1 |       1 |        1 |      10 |        10 | TRUE        |     1.0000000 |             0 |   0 |   0 | 0.0000000 | 1.0000000 | melankolia | MMMMMMMMMM     | 1111111111       | 1111111111           |                 |            NA |
|  797 | Gutiérrez-Cordero_w_rep_task3 |       1 | melancolía | melancolía | melankolia | melankolia    |   1 |       2 |        1 |      10 |        10 | TRUE        |     1.0000000 |             0 |   0 |   0 | 0.0000000 | 1.0000000 | melankolia | MMMMMMMMMM     | 1111111111       | 1111111111           |                 |           0.0 |
|  797 | Gutiérrez-Cordero_w_rep_task3 |       1 | melancolía | melancolía | melankolia | melankolia    |   1 |       3 |        1 |      10 |        10 | TRUE        |     1.0000000 |             0 |   0 |   0 | 0.0000000 | 1.0000000 | melankolia | MMMMMMMMMM     | 1111111111       | 1111111111           |                 |           0.0 |
| 1014 | Gutiérrez-Cordero_w_rep_task1 |       1 | vago       | vagos      | baɡo       | baɡos         |   0 |       1 |        0 |       4 |         5 | TRUE        |     0.8888889 |             1 |   1 |   1 | 0.0400000 | 0.7500000 | baɡo       | MMMMI          | 11110            | 1111                 |                 |            NA |
| 1134 | Gutiérrez-Cordero_w_rep_task2 |       1 | rellano    | relago     | reʎano     | relaɡo        |   1 |       1 |        0 |       6 |         6 | TRUE        |     0.6666667 |             4 |   2 |   2 | 0.1777778 | 0.6666667 | re         | MMSMSM         | 110101           | 110101               |                 |            NA |
| 1134 | Gutiérrez-Cordero_w_rep_task2 |       1 | rellano    | me         | reʎano     | me            |   1 |       2 |        0 |       6 |         2 | FALSE       |     0.2500000 |             6 |   5 |   5 | 0.4444444 | 0.1666667 | e          | SMDDDD         | 010000           | 010000               |                 |          -0.5 |

***Note.*** Move the dataframe to the right to see all the columns and
metrics.

### Obtain Positional Accuracy Data

``` r

positions_accuracy = formal_metrics_computed %>% 
  positional_accuracy(item_col = "item_phon", response_col = "response_phon", 
                      match_col = "adj_strict_match_pos")
  

positions_accuracy %>% select(ID:response_phon, RA, Attempt, position:element_in_response) %>% head(8) %>% knitr::kable()
```

|  ID | task                          | item_ID | item    | response | item_phon | response_phon |  RA | Attempt | position | correct_pos | element_in_item | element_in_response |
|----:|:------------------------------|--------:|:--------|:---------|:----------|:--------------|----:|--------:|---------:|:------------|:----------------|:--------------------|
| 517 | Gutiérrez-Cordero_w_rep_task1 |       1 | vago    | vago     | baɡo      | baɡo          |   0 |       1 |        1 | 1           | b               | b                   |
| 517 | Gutiérrez-Cordero_w_rep_task1 |       1 | vago    | vago     | baɡo      | baɡo          |   0 |       1 |        2 | 1           | a               | a                   |
| 517 | Gutiérrez-Cordero_w_rep_task1 |       1 | vago    | vago     | baɡo      | baɡo          |   0 |       1 |        3 | 1           | ɡ               | ɡ                   |
| 517 | Gutiérrez-Cordero_w_rep_task1 |       1 | vago    | vago     | baɡo      | baɡo          |   0 |       1 |        4 | 1           | o               | o                   |
| 637 | Gutiérrez-Cordero_w_rep_task2 |       1 | rellano | rellano  | reʎano    | reʎano        |   0 |       1 |        1 | 1           | r               | r                   |
| 637 | Gutiérrez-Cordero_w_rep_task2 |       1 | rellano | rellano  | reʎano    | reʎano        |   0 |       1 |        2 | 1           | e               | e                   |
| 637 | Gutiérrez-Cordero_w_rep_task2 |       1 | rellano | rellano  | reʎano    | reʎano        |   0 |       1 |        3 | 1           | ʎ               | ʎ                   |
| 637 | Gutiérrez-Cordero_w_rep_task2 |       1 | rellano | rellano  | reʎano    | reʎano        |   0 |       1 |        4 | 1           | a               | a                   |

***Note.*** A plot depicting the positions’ accuracy of 28836
datapoints.

<img src="man/figures/README-plot_positions-1.png" width="75%" style="display: block; margin: auto;" />

### Classify Errors

``` r

errors_classified = df_to_classify %>% 
  check_lexicality(item_col = "item", response_col = "response", criterion = "database") %>%
  get_formal_similarity(item_col = "item", response_col = "response", 
                        attempt_col = "Attempt", group_cols = c("ID", "item_ID")) %>%
  get_semantic_similarity(item_col = "item", response_col = "response", model = m_w2v) %>%
  classify_errors(response_col = "response", item_col = "item",
                  access_col = "accessed", RA_col = "RA", also_classify_RAs = T)
#> The function check_lexicality() took 2.19 seconds to be executed
#> The function get_formal_similarity() took 2.91 seconds to be executed
#> The function get_semantic_similarity() took 3.31 seconds to be executed
#> The function classify_errors() took 3.36 seconds to be executed

errors_classified %>% 
  select(ID, item_ID, item, response, RA, Attempt, correct, nonword:comment) %>% 
  head(8) %>% knitr::kable()
```

|   ID | item_ID | item       | response   |  RA | Attempt | correct | nonword | neologism | formal | unrelated | mixed | semantic | no_response | comment |
|-----:|--------:|:-----------|:-----------|----:|--------:|--------:|--------:|----------:|-------:|----------:|------:|---------:|------------:|:--------|
|  517 |       1 | vago       | vago       |   0 |       1 |       1 |       0 |         0 |      0 |         0 |     0 |        0 |           0 |         |
|  637 |       1 | rellano    | rellano    |   0 |       1 |       1 |       0 |         0 |      0 |         0 |     0 |        0 |           0 |         |
|  797 |       1 | melancolía | melancolía |   1 |       1 |       1 |       0 |         0 |      0 |         0 |     0 |        0 |           0 |         |
|  797 |       1 | melancolía | melancolía |   1 |       2 |       1 |       0 |         0 |      0 |         0 |     0 |        0 |           0 |         |
|  797 |       1 | melancolía | melancolía |   1 |       3 |       1 |       0 |         0 |      0 |         0 |     0 |        0 |           0 |         |
| 1014 |       1 | vago       | vagos      |   0 |       1 |       0 |       1 |         0 |      0 |         0 |     0 |        0 |           0 |         |
| 1134 |       1 | rellano    | relago     |   1 |       1 |       0 |       1 |         0 |      0 |         0 |     0 |        0 |           0 |         |
| 1134 |       1 | rellano    | me         |   1 |       2 |       0 |       0 |         1 |      0 |         0 |     0 |        0 |           0 |         |

***Notes.*** Move the dataframe to the right to see all the columns and
errors.

*sunflower* allows for the classification of production errors once some
indexes related to responses to a stimulus have been obtained and
contextualized based on whether they come from repeated attempts or
single productions. This process involves three steps.

First, a lexicality check of the response is performed using the
`lexicality_check()` function, which involves determining whether the
response is a real word. To do this, the package searches for the
response in a database such as *BuscaPalabras*
([BPal](https://www.uv.es/~mperea/Davis_Perea_in_press.pdf)) and
compares its frequency with the target word to determine if it is a real
word based on whether it has a higher frequency or not when the
parameter `criterion = "database"` is set. Alternatively, the response
can be checked against a dictionary (*sunflower* searches for responses
among entries from the *Real Academia Española*,
[RAE](https://www.rae.es/)) when the parameter
`criterion = "dictionary"` is used.

Next, similarity measures between the targets and the responses are
obtained using various algorithms within the `get_formal_similarity()`
function. Finally, the cosine similarity between the two productions is
computed if possible using the `get_semantic_similarity()` function,
based on an NLP model. In our case, the parameter `model = m_w2v` refers
to a binary file containing a Spanish Billion Words embeddings corpus
created using the word2vec algorithm. This file is included in the zip
file (for more information, see the markdown in the vignettes) located
within the dependency-bundle zip, which can be found in our
supplementary [OSF repository mirror](https://osf.io/akuxv/).

------------------------------------------------------------------------

Thanks to Cristian Cardellino for making his work on the [Spanish
Billion Word Corpus and
Embeddings](https://crscardellino.github.io/SBWCE/) publicly available.

------------------------------------------------------------------------

Any suggestions, comments, or questions about the package’s
functionality are warmly welcomed. If you’d like to contribute to the
project, please feel free to get in touch. 🌻
