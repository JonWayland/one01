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
  if(!exists(deparse(substitute(conn)))){
    stop(simpleError(paste0("The database connection `",deparse(substitute(conn)),"` isn't specified. Please be sure to connect to your respective database.")))
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
      pass_fail = as.character("Pass"),
      minutes = as.numeric(1),
      run_time = Sys.time(),
      run_time_desc = as.character("now"),
      rows = as.numeric(1),
      columns = as.numeric(1)
    )
    timeTrack <- timeTrack[-1,]
  }

  start_time <- Sys.time()
  dfr <- tryCatch(
    expr = {
      dbGetQuery(conn = conn, statement = statement)
    },
    error = function(e){
      message(e)
      print(e)
    }
  )
  end_time <- Sys.time()

  if(track){
    timeTrack <- rbind(timeTrack, data.frame(
      database = deparse(substitute(conn)),
      pass_fail = "Pass", # This needs to be the result of a tryCatch
      minutes = to_mins(end_time - start_time),
      run_time = start_time,
      run_time_desc = strftime(start_time, format="%I:%M %P", tz = "America/New_York"),
      rows = ifelse(!exists("dfr"),0,nrow(dfr)),
      columns = ifelse(!exists("dfr"),0,ncol(dfr))
    ))
    assign("timeTrack", timeTrack, envir = .GlobalEnv)
  }
}
