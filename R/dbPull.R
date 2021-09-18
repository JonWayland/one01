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

  dbGetQuery(conn = conn, statement = statement)

}
