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
#' createDB('healthcon')
#' dbPull(healthcon, "select GEO_LAT, GEO_LONG, DATA_VALUE from CDC_LOCAL where SHORT_QUESTION_TEXT = 'Binge Drinking' limit 5")
#' # Your query took approximately 0 minutes to execute and it returned 5 rows and 3 columns.
#' #       GEO_LAT     GEO_LONG DATA_VALUE
#' # 1 42.35277567  -72.1410545       17.7
#' # 2 41.85977566  -71.1572745       21.7
#' # 3 45.47428716 -69.69582113       16.0
#' # 4 41.50871097 -72.44747892       18.8
#' # 5 39.94903266 -74.07454626       17.3
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
  tryCatch(
    expr = {
      dfr <- dbGetQuery(conn = conn, statement = statement)
    },
    error = function(e){
      message(paste0("Query failed ... ",e))
    }
  )
  end_time <- Sys.time()

  if(track){
    timeTrack <- rbind(timeTrack, data.frame(
      database = deparse(substitute(conn)),
      pass_fail = ifelse(exists("dfr"), "Pass", "Fail"), # This needs to be the result of a tryCatch
      minutes = to_mins(end_time - start_time),
      run_time = start_time,
      run_time_desc = strftime(start_time, format="%I:%M %P", tz = "America/New_York"),
      rows = ifelse(!exists("dfr"),0,nrow(dfr)),
      columns = ifelse(!exists("dfr"),0,ncol(dfr))
    ))
    assign("timeTrack", timeTrack, envir = .GlobalEnv)
  }
  # Share performance of query
  writeLines(
    paste0("Your query took approximately ", round(to_mins(end_time - start_time)), " minutes to execute and it returned ", ifelse(!exists("dfr"),0,nrow(dfr)), " rows and ", ifelse(!exists("dfr"),0,ncol(dfr))," columns.")
  )
  # Return data
  if(exists("dfr")){
    return(dfr)
  }
}
