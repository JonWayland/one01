#' showAnswer Show the appropriate query to answer the specified question
#'
#' @param Q The number of the question corresponding to the `questions` vector
#'
#' @return The correct query to return the desired output.
#' @export
#'
#' @examples
showAnswer <- function(Q = 0){
  if(Q == 0){
    stop("Please specify a question you are wanting to see the answer query for. For example, to see the answer query for Q1, use `showAnswer(Q=1)`.")
  }

  if(Q == 1){
    return_query <- "

   Select avg(age)
   from transaction_details TD
   left join transaction_demog dm
   on td.buyer_mm_ID = dm.MM_id
   left join transaction_products tp
   on td.TRANSACTION_ID = tp.TRANSACTION_ID
   left join product_Map pm
   on tp.PRODUCT_ID = pm.PID
   where category = 'Furniture'

   "
  }

  if(Q == 2){
    return_query <- "

   Select COUNT(DISTINCT MM_ID)
   from transaction_details TD
   left join transaction_demog dm
   on td.seller_mm_ID = dm.MM_id
   left join transaction_products tp
   on td.TRANSACTION_ID = tp.TRANSACTION_ID
   left join product_Map pm
   on tp.PRODUCT_ID = pm.PID
   where category = 'Video Games'
   and dm.gender = 'M'

   "
  }

  if(Q == 3){
    return_query <- "

   Select COUNT(DISTINCT MM_ID)
   from transaction_details TD
   left join transaction_demog dm
   on td.buyer_mm_ID = dm.MM_id
   left join transaction_products tp
   on td.TRANSACTION_ID = tp.TRANSACTION_ID
   left join product_Map pm
   on tp.PRODUCT_ID = pm.PID
   where category = 'Jewelry'
   and dm.gender = 'F'

   "
  }

  if(Q == 4){
    return_query <- "

   WITH TRAN AS (
      Select transaction_ID, seller_mm_id as MM_ID
   from transaction_details TD
   union
   Select transaction_ID, buyer_mm_id as MM_ID
   from transaction_details TD
   ) ,
   CNT AS (
   Select MM_ID, COUNT(DISTINCT TRANSACTION_ID) AS TRAN_CNT
   FROM TRAN GROUP BY MM_ID
   )
   select MM_ID from CNT
   where MM_ID is not null
   order by TRAN_CNT desc limit 1

   "
  }

  if(Q == 5){
    return_query <- "

   Select distinct TRANID from transaction_costs order by COST desc limit 1

   "
  }

  if(Q == 6){
    return_query <- "

   select count(*) from transaction_details where SELLER_MM_ID = BUYER_MM_ID

   "
  }

  if(Q == 7){
    return_query <- "

   select count(distinct transaction_ID) from transaction_details

   "
  }


  return(writeLines(return_query))
}
