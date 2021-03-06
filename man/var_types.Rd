% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/var_types.R
\name{var_types}
\alias{var_types}
\title{Attach the variable type information with the dataset}
\usage{
var_types(tbl, types)
}
\arguments{
\item{tbl}{A data.frame}

\item{types}{Character vector of length equal to the number of variables in
the dataset. Use "q" and "c" to denote quantitative and categorical variables.}
}
\description{
In order to analyze variables in the most appropriate way using
this \code{ezsummary} package, you'd better let the computer know what types
of data (quantitative or categorical) you are asking it to compute. This
function will attach a list of types you entered with the datasets so
functions down the stream line can read these information and analyze based
on that. The information is stored in the attributes of the dataset
}

