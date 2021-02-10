#' qa
#'
#' @param sql_code
#' @param Q
#'
#' @return
#' @export
#'
#' @examples
#' qa(Q = 1, "Select * from PRODUCT_MAP")
qa <- function(sql_code, Q = 0){
  if(!exists("moomy")){
    stop("The `moomy` database does not exist. Please create this database connection with the `createDB` function.")
  }
  if(Q == 0){
    stop("Please specify a question from the `moomyQs` question list. Example: Q = 1")
  }
  # Execute the provided query
  output <- DBI::dbGetQuery(moomy, sql_code)

  # Formatting output object based on the question
  if(Q %in% c(1,2,3)){
    output <- round(output[[1]],5)
  }

  # Answer vector
  answers <- c(30.10526, 17, 165, "MM-134")

  if(exists("output")){
    suppressWarnings(
      if(output == answers[Q]){
        writeLines("Great job! Your query returned the expected result.")
      } else{
        stop("Your query executed; however, it was WRONG! Try again.")
      }
    )
  }
}
