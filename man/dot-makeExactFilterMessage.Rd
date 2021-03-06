% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils_logging.R
\name{.makeExactFilterMessage}
\alias{.makeExactFilterMessage}
\title{Make a message about filtering based on fixed values}
\usage{
.makeExactFilterMessage(col_name, filter_symbols, behavior, fill_value)
}
\arguments{
\item{col_name}{chr, name of the column that will be the base for filtering}

\item{filter_symbols}{character vector of symbols that will be removed}

\item{behavior}{chr, if "remove", values below/above the threshold will be
removed, if "replace", they will be set to \code{fill_value}.}

\item{fill_value}{if \code{behavior} = "replace", values below/above the threshold
will be replaced with \code{fill_value}. Defaults to \code{NA}.}
}
\value{
character - message
}
\description{
Make a message about filtering based on fixed values
}
\keyword{internal}
