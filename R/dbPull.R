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
  # Database Exists Exception
  if(!exists(deparse(substitute(DB)))){
    stop(simpleError(paste0("The database connection `",deparse(substitute(DB)),"` isn't specified. Please be sure to connect to your respective database.")))
  }
  # Converting other units of time into minutes
  to_mins <- function(difftime){
    if(units(difftime) == "secs"){mins <- as.numeric(difftime)/60}
    if(units(difftime) == "hours"){mins <- as.numeric(difftime)*60}
    if(units(difftime) == "mins"){mins <- as.numeric(difftime)}
    if(units(difftime) == "days"){mins <- as.numeric(difftime)*60*24}
    return(mins)
  }

  # If the timeTrack object does not exist
  if(!exists("timeTrack")){
    timeTrack <- data.frame(
      database = as.character("one"),
      minutes = as.numeric(1),
      run_time = Sys.time(),
      run_time_desc = as.character("now"),
      rows = as.numeric(1),
      columns = as.numeric(1)
    )
    timeTrack <- timeTrack[-1,]
  }

  start_time <- Sys.time()
  dfr <- dbGetQuery(conn = conn, statement = statement)
  end_time <- Sys.time()

  if(track){
    timeTrack <- rbind(timeTrack, data.frame(
      database = deparse(substitute(conn)),
      minutes = to_mins(end_time - start_time),
      run_time = start_time,
      run_time_desc = strftime(start_time, format="%I:%M %P", tz = "America/New_York"),
      rows = nrow(dfr),
      columns = ncol(dfr)
    ))
  }
}
