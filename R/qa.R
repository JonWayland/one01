#' qa Function for practicing SQL code using the `questions` vector produced with the `moomy` database using `createDB`
#'
#' @param sql_code SQL code to pull what is being asked in the question pertaining to the `Q` paramater
#' @param Q The question that corresponds to the `questions` vector
#'
#' @return Whether or not the `sql_code` provided returns the expected result
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
  if(Q %in% c(1,2,3,6,7)){
    output <- round(output[[1]],5)
  }

  # Answer vector
  answers <- c(30.10526, 17, 150, "MM-134", "TC-10011821", 3, 5000, "Vehicles",2500)

  if(exists("output")){
    # Show output
    print(output)

    suppressWarnings(
      if(output == answers[Q]){
        writeLines("Great job! Your query returned the expected result.")
      } else{
        stop("Your query executed; however, it was WRONG! Try again.")
      }
    )
  }
}
