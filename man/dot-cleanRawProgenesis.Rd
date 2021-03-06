% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/clean_Progenesis.R
\name{.cleanRawProgenesis}
\alias{.cleanRawProgenesis}
\title{Clean raw Progenesis output}
\usage{
.cleanRawProgenesis(msstats_object, runs, fix_colnames = TRUE)
}
\arguments{
\item{msstats_object}{an object of class \code{MSstatsSpectroMineFiles}.}

\item{runs}{chr, vector of Run labels.}

\item{fix_colnames}{lgl, if TRUE, one of the rows will be used as colnames.}
}
\value{
data.table
}
\description{
Clean raw Progenesis output
}
\keyword{internal}
