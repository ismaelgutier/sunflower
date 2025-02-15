
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sunflower: A Package to Assess and Categorize Language Production Errors

<!-- badges start -->

![](https://img.shields.io/badge/sunflower-v._1.02-orange?style=flat&link=https%3A%2F%2Fgithub.com%2Fismaelgutier%2Fsunflower)
[![License: GPL
v3](https://img.shields.io/badge/License-GPLv3-%233493ad.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Language](https://img.shields.io/badge/Language-grey?style=flat&logo=R)](https://www.r-project.org/)
[![Paper](https://img.shields.io/badge/Paper-Frontiers%20in%20Psychology-brightgreen)](https://doi.org/10.3389/fpsyg.2025.1538196)

<!-- badges end -->
<div align="justify">

*sunflower* is a package designed to assist clinicians and researchers
in the fields of Speech Therapy and (Neuro)psychology of Language. Its
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
#> The function get_formal_similarity() took 2.01 seconds to be executed
```

Display some of the results from the formal quality analysis.

| ID_general | task_type       |  ID | item_ID | item     | response |  RA | attempt | item_phon | response_phon | targetL | responseL | shared1char | p_shared_char | diff_char_num |  Ld | DLd |   JWd |   pcc | lcs      | similarity_str | strict_match_pos | adj_strict_match_pos | approach_diff |
|-----------:|:----------------|----:|--------:|:---------|:---------|----:|--------:|:----------|:--------------|--------:|----------:|:------------|--------------:|--------------:|----:|----:|------:|------:|:---------|:---------------|:-----------------|:---------------------|--------------:|
|          1 | word_repetition |   1 |       1 | sorpresa | sorpresa |   0 |       1 | soɾpɾesa  | soɾpɾesa      |       8 |         8 | TRUE        |         1.000 |             0 |   0 |   0 | 0.000 | 1.000 | sorpresa | MMMMMMMM       | 11111111         | 11111111             |            NA |
|          2 | word_repetition |   2 |       2 | banco    | banco    |   0 |       1 | banko     | banko         |       5 |         5 | TRUE        |         1.000 |             0 |   0 |   0 | 0.000 | 1.000 | banco    | MMMMM          | 11111            | 11111                |            NA |
|          3 | word_repetition |   3 |       3 | reloj    | reloj    |   0 |       1 | relox     | relox         |       5 |         5 | TRUE        |         1.000 |             0 |   0 |   0 | 0.000 | 1.000 | reloj    | MMMMM          | 11111            | 11111                |            NA |
|          4 | word_repetition |   4 |       4 | arañazo  | arañazo  |   0 |       1 | aɾaɲaθo   | aɾaɲaθo       |       7 |         7 | TRUE        |         1.000 |             0 |   0 |   0 | 0.000 | 1.000 | arañazo  | MMMMMMM        | 1111111          | 1111111              |            NA |
|          5 | word_repetition |   5 |       5 | misterio | misterio |   0 |       1 | misteɾjo  | misteɾjo      |       8 |         8 | TRUE        |         1.000 |             0 |   0 |   0 | 0.000 | 1.000 | misterio | MMMMMMMM       | 11111111         | 11111111             |            NA |
|          6 | word_repetition |   6 |       6 | lima     | lima     |   0 |       1 | lima      | lima          |       4 |         4 | TRUE        |         1.000 |             0 |   0 |   0 | 0.000 | 1.000 | lima     | MMMM           | 1111             | 1111                 |            NA |
|          7 | word_repetition |   7 |       7 | pimienta | pimienta |   0 |       1 | pimjenta  | pimjenta      |       8 |         8 | TRUE        |         1.000 |             0 |   0 |   0 | 0.000 | 1.000 | pimienta | MMMMMMMM       | 11111111         | 11111111             |            NA |
|          8 | word_repetition |   8 |       8 | taladro  | talablo  |   1 |       1 | taladɾo   | talablo       |       7 |         7 | TRUE        |         0.714 |             4 |   2 |   2 | 0.114 | 0.714 | tala     | MMMMSSM        | 1111001          | 1111001              |            NA |
|          9 | word_repetition |   8 |       8 | taladro  | talabro  |   1 |       2 | taladɾo   | talabɾo       |       7 |         7 | TRUE        |         0.857 |             2 |   1 |   1 | 0.057 | 0.857 | tala     | MMMMSMM        | 1111011          | 1111011              |         0.143 |

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

|  ID | item_ID | item    | response |  RA | attempt | item_phon | response_phon | position | correct_pos | element_in_item | element_in_response |
|----:|--------:|:--------|:---------|----:|--------:|:----------|:--------------|---------:|:------------|:----------------|:--------------------|
|  75 |      13 | lingote | lintro   |   1 |       2 | linɡote   | lintɾo        |        1 | 1           | l               | l                   |
|  75 |      13 | lingote | lintro   |   1 |       2 | linɡote   | lintɾo        |        2 | 1           | i               | i                   |
|  75 |      13 | lingote | lintro   |   1 |       2 | linɡote   | lintɾo        |        3 | 1           | n               | n                   |
|  75 |      13 | lingote | lintro   |   1 |       2 | linɡote   | lintɾo        |        4 | 0           | ɡ               | t                   |
|  75 |      13 | lingote | lintro   |   1 |       2 | linɡote   | lintɾo        |        5 | 0           | o               | ɾ                   |
|  75 |      13 | lingote | lintro   |   1 |       2 | linɡote   | lintɾo        |        6 | 0           | t               | o                   |
|  75 |      13 | lingote | lintro   |   1 |       2 | linɡote   | lintɾo        |        7 | 0           | e               | NA                  |

If we were to plot this dataframe, we would obtain…

<img src="man/figures/README-plot_positions-1.png" width="75%" style="display: block; margin: auto;" />

***Note.*** This plot depicts the positional accuracy of 58186
datapoints.

### Classify Errors

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
created using the *word2vec* algorithm. This file is included in the zip
file (for more information, see the markdown in the vignettes) located
within the
<a href="https://osf.io/mfcvb" style="color: purple;">dependency-bundle
zip</a>, which can be found in our supplementary [OSF mirror
repository](https://osf.io/akuxv/).

``` r
errors_classified = df_to_classify %>% 
  check_lexicality(item_col = "item", response_col = "response", criterion = "database") %>%
  get_formal_similarity(item_col = "item", response_col = "response", 
                        attempt_col = "attempt", group_cols = c("ID", "item_ID")) %>%
  get_semantic_similarity(item_col = "item", response_col = "response", model = m_w2v) %>%
  classify_errors(response_col = "response", item_col = "item",
                  access_col = "accessed", RA_col = "RA", also_classify_RAs = T)
#> The function check_lexicality() took 0.65 seconds to be executed
#> The function get_formal_similarity() took 0.89 seconds to be executed
#> The function get_semantic_similarity() took 1.01 seconds to be executed
#> The function classify_errors() took 1.03 seconds to be executed
```

Display the classification that was conducted.

|  ID | item_ID | item        | response |  RA | attempt | correct | nonword | neologism | formal | unrelated | mixed | semantic | no_response | check_comment |
|----:|--------:|:------------|:---------|----:|--------:|--------:|--------:|----------:|-------:|----------:|------:|---------:|------------:|:--------------|
|   8 |       8 | taladro     | talablo  |   1 |       1 |       0 |       1 |         0 |      0 |         0 |     0 |        0 |           0 |               |
|   9 |       9 | cana        | cala     |   0 |       1 |       0 |       0 |         0 |      1 |         0 |     0 |        0 |           0 |               |
|  17 |      17 | calamar     | malacar  |   1 |       1 |       0 |       1 |         0 |      0 |         0 |     0 |        0 |           0 |               |
|  32 |      32 | raspa       | rasca    |   1 |       4 |       0 |       0 |         0 |      0 |         0 |     1 |        0 |           0 |               |
| 134 |      10 | mariposa    | sisi     |   1 |       7 |       0 |       0 |         1 |      0 |         0 |     0 |        0 |           0 |               |
| 140 |      16 | silbato     | pito     |   1 |       1 |       0 |       0 |         0 |      0 |         0 |     1 |        0 |           0 |               |
| 148 |      24 | rinoceronte | are      |   1 |       1 |       0 |       0 |         1 |      0 |         0 |     0 |        0 |           0 |               |
| 272 |       3 | caballo     | caballo  |   1 |       3 |       1 |       0 |         0 |      0 |         0 |     0 |        0 |           0 |               |

***Notes.*** Move the dataframe to the right to see all the columns and
errors.

## Making it faster - A guided usage tutorial

A file that allows executing all the functions relatively quickly as a
sample can be downloaded from <a href="https://osf.io/urz4y">its link in
our OSF</a>. This can be helpful for both novice users and those who
want to explore the package’s functionalities in a more straightforward
and/or faster way. Users would only need to run the code presented in
the script in the link and would require the <em>word2vec</em> model
made available in the
<a href="https://osf.io/mfcvb" style="color: purple;">dependency-bundle
zip</a>.</span>

## The published work

This work has been published and can be accessed by clicking
[here](https://doi.org/10.3389/fpsyg.2025.1538196). It can be cited as
follows:

Gutiérrez-Cordero. I, & García-Orza, J. (2025). sunflower: an R package
for handling multiple response attempts and conducting error analysis in
aphasia and related disorders. *Frontiers in Psychology*, *16*, 1538196.
<https://doi.org/10.3389/fpsyg.2025.1538196>

## Acknowledgments

Thanks to Cristian Cardellino for making his work on the [Spanish
Billion Word Corpus and
Embeddings](https://crscardellino.github.io/SBWCE/) publicly available.

## Hello!

Any suggestions, comments, or questions about the package’s
functionality are warmly welcomed. If you’d like to contribute to the
project, please feel free to get in touch. 🌻
