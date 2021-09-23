#' dbPull - A wrapper for DBI's dbGetQuery
#'
#' @param conn
#' @param statement
#' @param track
#' @param reset_track
#'
#' @return
#' @export
#'
#' @examples
dbPull <- function(
  conn,
  statement,
  track = TRUE,
  reset_track = FALSE
){
  require(DBI)

  # If the timeTrack object does not exist
  if(!exists("timeTrack")){
    timeTrack <- data.frame(
      database = as.character("one"),
      minutes = as.numeric(1),
      run_time = Sys.time()
    )
    timeTrack <- timeTrack[-1,]
  }

  start_time <- Sys.time()
  dbGetQuery(conn = conn, statement = statement)
  end_time <- Sys.time()

  if(track){
    timeTrack <- rbind(timeTrack, data.frame(
      database = , # Needs to be parsed from the `conn` parameter
      minutes = end_time - start_time, # Needs to be converted to minutes
      run_time = start_time
    ))
  }
}
