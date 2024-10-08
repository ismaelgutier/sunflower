% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/is_target_nonword.R
\name{is_target_nonword}
\alias{is_target_nonword}
\title{Check if the Item Type is a Nonword}
\usage{
is_target_nonword(
  item_type,
  patterns = c("nonword", "nonwords", "NW", "pseudoword", "pseudowords", "pseudo-word",
    "pseudo-words", "non-word", "non-words", "pseudopalabra", "pseudopalabras")
)
}
\arguments{
\item{item_type}{A character string representing the type of the item to be checked.}
}
\value{
An integer value (`1` or `0`). Returns `1` if the `item_type` matches any of the specified nonword patterns, otherwise `0`.
}
\description{
This function determines whether a given item type represents a nonword. It does so by checking if the item type contains any of the specified patterns: "nonword", "nonwords", "NW", "pseudoword", "pseudowords", "pseudo-word", "pseudo-words", "non-word", "non-words", "pseudopalabra", or "pseudopalabras".
}
\details{
The function searches for common variations of the term "nonword" within the `item_type` string. If any of the specified patterns are found, the function will return `1`.
}
