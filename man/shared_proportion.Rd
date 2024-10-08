% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/shared_proportion.R
\name{shared_proportion}
\alias{shared_proportion}
\title{Calculate proportion of shared characters between two words}
\usage{
shared_proportion(target_col, response_col)
}
\arguments{
\item{target_col}{A string representing the target word to compare.}

\item{response_col}{A string representing the response word to compare against the target.}
}
\value{
A numeric value representing the proportion of shared letters between the two input words. This proportion is computed as the ratio of the number of shared letters to the total number of letters in both words combined.
}
\description{
Calculate the proportion of shared characters (letters/phonemes) between two words. The function converts both words to lowercase and then counts the number of unique characters in the `target_col` that also appear in the `response_col`. The proportion is determined based on the total number of characters in both words combined.
}
\examples{
shared_proportion("article", "artim")

}
