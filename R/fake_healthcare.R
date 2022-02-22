
#' Fake Healthcare Data
#'
#' Fictional healthcare dataset containing patient demographics, conditions, costs, and health insurance policy information.
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
#'  \item CC_Asthma Presence of having asthma (0/1)
#'  \item CC_Atrial_Fibrillation Presence of having atrial fibrillation (0/1)
#'  \item CC_Austism Presence of having autism (0/1)
#'  \item CC_Cancer Presence of having cancer (0/1)
#'  \item CC_COPD Presence of having chronic obstructive pulmonary disease (0/1)
#'  \item CC_Dementia Presence of having dementia (0/1)
#'  \item CC_Depression Presence of having depression (0/1)
#'  \item CC_Diabetes Presence of having diabetes (0/1)
#'  \item CC_Heart_Failure Presence of having heart failure (0/1)
#'  \item CC_Hepatitis Presence of having hepatitis (0/1)
#'  \item CC_HIV_AIDS Presence of having HIV and/or AIDs (0/1)
#'  \item CC_Hyperlipidemia Presence of having hyperlipidemia (0/1)
#'  \item CC_Hypertension Presence of having hypertension (0/1)
#'  \item CC_Ischemic_Heart_Disease Presence of having ischemic heart disease (0/1)
#'  \item CC_Kidney_Disease Presence of having chronic kidney disease (0/1)
#'  \item CC_Osteoporosis Presence of having osteoporosis (0/1)
#'  \item CC_Schizophrenia Presence of having schizophrenia (0/1)
#'  \item CC_Stroke Presence of having had a stroke (0/1)
#'  \item ER_Copay Cost share for emergency room visits
#'  \item PCP_Copay Cost share for primary care visits
#'  \item IP_Visits Number of inpatient admissions over the past year
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
