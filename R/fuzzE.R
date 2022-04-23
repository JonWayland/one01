#' fuzzE
#'
#' @param x First string
#' @param y Second string
#' @param caps Boolean for whether upper/lower case letters are treated the same
#' @param rm_spec Boolean to remove special characters
#' @param rm_numbers Boolean to remove numbers and suffixes (good for name matching)
#' @param bump_it Boolean to add rules for increasing score (in development)
#'
#' @return Score between 0 and 1 indicating strength of match
#'
#' @examples
#' fuzzE("John Wayland", "Jonathan Wayland")
#' # [1] 0.75
fuzzE <- function(x, # First string
                  y, # Second string
                  caps = TRUE, # Upper/lower case letters are treated the same
                  rm_spec = TRUE, # Remove special characters
                  rm_numbers = TRUE, # Remove numbers and suffixes (good for name matching)
                  bump_it = FALSE # In development; rules for increasing score
){
  if(length(x) != length(y)){
    stop("Incompatible vector lengths")
  }

  # Capitalize each string
  if(caps){
    x <- toupper(x)
    y <- toupper(y)
  }

  # Remove special characters
  if(rm_spec){
    x <- gsub("[[:punct:]]","",x)
    y <- gsub("[[:punct:]]","",y)
  }

  # Remove numbers
  if(rm_numbers){
    x <- gsub("[[:digit:]]","",x)
    y <- gsub("[[:digit:]]","",y)
  }

  # Remove leading and trailing whitespace
  x <- trimws(x, which = "both")
  y <- trimws(y, which = "both")

  # Convert multiple spaces into single space
  x <- gsub("\\s+"," ",x)
  y <- gsub("\\s+"," ",y)

  score <- function(x,y){
    bump <- 0
    score <- as.numeric(1 - adist(x = as.character(x), y = as.character(y)) / max(nchar(as.character(x)), nchar(as.character(y))))

    if(score >= 0.8){

    }
    ## If there are just a few non-matching characters and the first letter of the first name is a match, bump up score
    bump <- bump + ifelse(substr(x,1,1) == substr(y,1,1),.05,0)

    ## ^^ same for second letter of first name
    bump <- bump + ifelse(substr(x,2,2) == substr(y,2,2) & nchar(x) > 1,0.01,0)

    ## If last name matches exactly, bump up score
    bump <- bump + ifelse(gsub(".*\\s", "", x) == gsub(".*\\s", "", y),0.01,0)

    ## Conversely, if the first letter does not match then bump score down (e.g., Kayla and Ray)
    bump <- bump - ifelse(substr(x,1,1) != substr(y,1,1),.05,0)

    no_bumps <- 4
    the_bump <- bump #/ (no_bumps^2)
    if(!bump_it){
      the_bump <- 0
    }

    score <- as.numeric(1 - adist(x = as.character(x), y = as.character(y)) / max(nchar(as.character(x)), nchar(as.character(y)))) + the_bump
    score <- ifelse(score < 0, 0, score)
    score <- ifelse(score > 1, 1, score)
  }

  if(length(x) > 1){
    res <- c()
    for(i in 1:length(x)){
      res <- append(res, score(x[i], y[i]))
    }
  } else{
    res <- score(x,y)
  }
  return(res)
}
