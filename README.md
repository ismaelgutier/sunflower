
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sunflower: A Package to Assess and Categorize Language Production Errors

<!-- badges start -->

![](https://img.shields.io/badge/sunflower-v._0.22.11-orange?style=flat&link=https%3A%2F%2Fgithub.com%2Fismaelgutier%2Fsunflower)
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

We can load a pre-loaded dataframe from the package, which is available
for anyone interested in testing the functions. These dataframes
include: `IGC_sample`, `IGC_long_sample`, `IGC_long_phon_sample` and
`simulated_sample`.

``` r
df_to_formal_metrics = sunflower::IGC_long_phon_sample
```

However, in this example we are going to conduct the formal quality
analysis using phonological broad transcriptions from a larger dataset.

``` r
formal_metrics_computed = df_to_formal_metrics %>% 
    get_formal_similarity(item_col = "item", 
                          response_col = "response",
                          attempt_col = "attempt",
                          group_cols = c("ID", "item_ID"))
#> The function get_formal_similarity() took 3.44 seconds to be executed
```

Display some of the results from the formal quality analysis.

| ID_general | test | task_type       | task_modality |  ID | item_ID | item     | response |  RA | attempt | item_phon | response_phon | targetL | responseL | shared1char | p_shared_char | diff_char_num |  Ld | DLd |       JWd |       pcc | lcs      | similarity_str | strict_match_pos | adj_strict_match_pos | comment_warning | approach_diff |
|-----------:|:-----|:----------------|:--------------|----:|--------:|:---------|:---------|----:|--------:|:----------|:--------------|--------:|----------:|:------------|--------------:|--------------:|----:|----:|----------:|----------:|:---------|:---------------|:-----------------|:---------------------|:----------------|--------------:|
|          1 | BETA | word_repetition | repetition    |   1 |       1 | sorpresa | sorpresa |   0 |       1 | soɾpɾesa  | soɾpɾesa      |       8 |         8 | TRUE        |     1.0000000 |             0 |   0 |   0 | 0.0000000 | 1.0000000 | sorpresa | MMMMMMMM       | 11111111         | 11111111             |                 |            NA |
|          2 | BETA | word_repetition | repetition    |   2 |       2 | banco    | banco    |   0 |       1 | banko     | banko         |       5 |         5 | TRUE        |     1.0000000 |             0 |   0 |   0 | 0.0000000 | 1.0000000 | banco    | MMMMM          | 11111            | 11111                |                 |            NA |
|          3 | BETA | word_repetition | repetition    |   3 |       3 | reloj    | reloj    |   0 |       1 | relox     | relox         |       5 |         5 | TRUE        |     1.0000000 |             0 |   0 |   0 | 0.0000000 | 1.0000000 | reloj    | MMMMM          | 11111            | 11111                |                 |            NA |
|          4 | BETA | word_repetition | repetition    |   4 |       4 | arañazo  | arañazo  |   0 |       1 | aɾaɲaθo   | aɾaɲaθo       |       7 |         7 | TRUE        |     1.0000000 |             0 |   0 |   0 | 0.0000000 | 1.0000000 | arañazo  | MMMMMMM        | 1111111          | 1111111              |                 |            NA |
|          5 | BETA | word_repetition | repetition    |   5 |       5 | misterio | misterio |   0 |       1 | misteɾjo  | misteɾjo      |       8 |         8 | TRUE        |     1.0000000 |             0 |   0 |   0 | 0.0000000 | 1.0000000 | misterio | MMMMMMMM       | 11111111         | 11111111             |                 |            NA |
|          6 | BETA | word_repetition | repetition    |   6 |       6 | lima     | lima     |   0 |       1 | lima      | lima          |       4 |         4 | TRUE        |     1.0000000 |             0 |   0 |   0 | 0.0000000 | 1.0000000 | lima     | MMMM           | 1111             | 1111                 |                 |            NA |
|          7 | BETA | word_repetition | repetition    |   7 |       7 | pimienta | pimienta |   0 |       1 | pimjenta  | pimjenta      |       8 |         8 | TRUE        |     1.0000000 |             0 |   0 |   0 | 0.0000000 | 1.0000000 | pimienta | MMMMMMMM       | 11111111         | 11111111             |                 |            NA |
|          8 | BETA | word_repetition | repetition    |   8 |       8 | taladro  | talablo  |   1 |       1 | taladɾo   | talablo       |       7 |         7 | TRUE        |     0.7142857 |             4 |   2 |   2 | 0.1142857 | 0.7142857 | tala     | MMMMSSM        | 1111001          | 1111001              |                 |            NA |

***Note.*** Move the dataframe to the right to see all the columns and
metrics.

### Obtain Positional Accuracy Data

Apply the pertinent function to obtain positional accuracies…

``` r
positions_accuracy = formal_metrics_computed %>% 
  positional_accuracy(item_col = "item_phon", 
                      response_col = "response_phon", 
                      match_col = "adj_strict_match_pos")
```

Display the results of the positional accuracy analysis.

|  ID | item_ID | item     | response |  RA | attempt | item_phon | response_phon | position | correct_pos | element_in_item | element_in_response |
|----:|--------:|:---------|:---------|----:|--------:|:----------|:--------------|---------:|:------------|:----------------|:--------------------|
|   1 |       1 | sorpresa | sorpresa |   0 |       1 | soɾpɾesa  | soɾpɾesa      |        1 | 1           | s               | s                   |
|   1 |       1 | sorpresa | sorpresa |   0 |       1 | soɾpɾesa  | soɾpɾesa      |        2 | 1           | o               | o                   |
|   1 |       1 | sorpresa | sorpresa |   0 |       1 | soɾpɾesa  | soɾpɾesa      |        3 | 1           | ɾ               | ɾ                   |
|   1 |       1 | sorpresa | sorpresa |   0 |       1 | soɾpɾesa  | soɾpɾesa      |        4 | 1           | p               | p                   |
|   1 |       1 | sorpresa | sorpresa |   0 |       1 | soɾpɾesa  | soɾpɾesa      |        5 | 1           | ɾ               | ɾ                   |
|   1 |       1 | sorpresa | sorpresa |   0 |       1 | soɾpɾesa  | soɾpɾesa      |        6 | 1           | e               | e                   |
|   1 |       1 | sorpresa | sorpresa |   0 |       1 | soɾpɾesa  | soɾpɾesa      |        7 | 1           | s               | s                   |
|   1 |       1 | sorpresa | sorpresa |   0 |       1 | soɾpɾesa  | soɾpɾesa      |        8 | 1           | a               | a                   |

If we were to plot this dataframe, we would obtain…

<img src="man/figures/README-plot_positions-1.png" width="75%" style="display: block; margin: auto;" />

***Note.*** This plot depicts the positional accuracy of 58186
datapoints.

### Classify Errors

Following the necessary steps to classify the errors correctly.

``` r
errors_classified = df_to_classify %>% 
  check_lexicality(item_col = "item", response_col = "response", criterion = "database") %>%
  get_formal_similarity(item_col = "item", response_col = "response", 
                        attempt_col = "Attempt", group_cols = c("ID", "item_ID")) %>%
  get_semantic_similarity(item_col = "item", response_col = "response", model = m_w2v) %>%
  classify_errors(response_col = "response", item_col = "item",
                  access_col = "accessed", RA_col = "RA", also_classify_RAs = T)
#> The function check_lexicality() took 0.54 seconds to be executed
#> The function get_formal_similarity() took 0.68 seconds to be executed
#> The function get_semantic_similarity() took 0.73 seconds to be executed
#> The function classify_errors() took 0.80 seconds to be executed
```

Display the classification that was conducted.

|   ID | item_ID | item  | response |  RA | Attempt | correct | nonword | neologism | formal | unrelated | mixed | semantic | no_response | comment |
|-----:|--------:|:------|:---------|----:|--------:|--------:|--------:|----------:|-------:|----------:|------:|---------:|------------:|:--------|
|  517 |       1 | vago  | vago     |   0 |       1 |       1 |       0 |         0 |      0 |         0 |     0 |        0 |           0 |         |
| 1014 |       1 | vago  | vagos    |   0 |       1 |       0 |       1 |         0 |      0 |         0 |     0 |        0 |           0 |         |
|  518 |       2 | bario | bario    |   0 |       1 |       1 |       0 |         0 |      0 |         0 |     0 |        0 |           0 |         |
| 1015 |       2 | bario | barios   |   0 |       1 |       0 |       1 |         0 |      0 |         0 |     0 |        0 |           0 |         |
|  519 |       3 | tenia | tenia    |   0 |       1 |       1 |       0 |         0 |      0 |         0 |     0 |        0 |           0 |         |
| 1016 |       3 | tenia | tenias   |   0 |       1 |       0 |       1 |         0 |      0 |         0 |     0 |        0 |           0 |         |
|  520 |       4 | medio | medio    |   0 |       1 |       1 |       0 |         0 |      0 |         0 |     0 |        0 |           0 |         |
| 1017 |       4 | medio | medios   |   0 |       1 |       0 |       1 |         0 |      0 |         0 |     0 |        0 |           0 |         |

***Notes.*** Move the dataframe to the right to see all the columns and
errors.

*sunflower* allows for the classification of production errors once some
indexes related to responses to a stimulus have been obtained and
contextualized based on whether they come from repeated attempts or
single productions. This process involves three steps.

First, a lexicality check of the response is performed using the
`check_lexicality()` function, which involves determining whether the
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
within the
<a href="https://osf.io/mfcvb" style="color: purple;">dependency-bundle
zip</a>, which can be found in our supplementary [OSF repository
mirror](https://osf.io/akuxv/).

------------------------------------------------------------------------

Thanks to Cristian Cardellino for making his work on the [Spanish
Billion Word Corpus and
Embeddings](https://crscardellino.github.io/SBWCE/) publicly available.

------------------------------------------------------------------------

Any suggestions, comments, or questions about the package’s
functionality are warmly welcomed. If you’d like to contribute to the
project, please feel free to get in touch. 🌻
