
#' Fake Healthcare Data
#'
#' Health and income outcomes for 184 countries from 1960 to 2016. Also includes two character vectors, \code{oecd}
#' and \code{opec}, with the names of OECD and OPEC countries from 2016.
#'
#' \itemize{
#'  \item PatientID
#'  \item Age
#'  \item CC_Count Count of chronic conditions
#'  \item Risk_Count Number of self-reported risks
#'  \item HP_Paid Total dollar amount paid out by the health insurance company for the member in the past year
#'  \item Gender
#'  \item ER_Count Count of emergency room visits in past year
#'  \item CC_Arthritis Presence of having arthritis (0/1)
#' }
#'
#'
#' @docType data
#'
#' @usage data(fake_healthcare)
#'
#' @format An object of class \code{"data.frame"}.
#'
#' @keywords datasets
#'
#' @aliases oecd opec
#'
#' @examples
#' data(fake_healthcare)
#' head(fake_healthcare)
#' print(oecd)
#' print(opec)
"fake_healthcare"
