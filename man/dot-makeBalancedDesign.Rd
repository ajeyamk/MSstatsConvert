% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils_balanced_design.R
\name{.makeBalancedDesign}
\alias{.makeBalancedDesign}
\title{Fill missing rows to create balanced design}
\usage{
.makeBalancedDesign(input, fill_missing)
}
\arguments{
\item{input}{output of \code{MSstatsPreprocess}}

\item{fill_missing}{if TRUE, missing Intensities values will be added to data
and marked as NA}
}
\value{
data.table
}
\description{
Fill missing rows to create balanced design
}
\keyword{internal}
