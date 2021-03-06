% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/qa.R
\name{qa}
\alias{qa}
\title{qa Function for practicing SQL code using the `questions` vector produced with the `moomy` database using `createDB`}
\usage{
qa(sql_code, Q = 0)
}
\arguments{
\item{sql_code}{SQL code to pull what is being asked in the question pertaining to the `Q` paramater}

\item{Q}{The question that corresponds to the `questions` vector}
}
\value{
Whether or not the `sql_code` provided returns the expected result
}
\description{
qa Function for practicing SQL code using the `questions` vector produced with the `moomy` database using `createDB`
}
\examples{
qa(Q = 1, "Select * from PRODUCT_MAP")
}
