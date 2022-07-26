#' createDB Creates the `moomy` database in the Global Environment
#'
#' @return
#' @export
#'
#' @examples
#' createDB()
#'
#' Loading required package: DBI
#' Loading required package: RSQLite
#' The `moomy` database connection is now set.
#' Use the function `dbListTables` from the DBI package to see what tables are available in MooMy. Ex: DBI::dbListTables(moomy)
#' Warning message:
#'   package ‘RSQLite’ was built under R version 4.0.3
#'
#'
#'
createDB <- function(db = "moomy"){
  # If `db` is not specified then MooMy is the resulting database
  if(!db %in% c('moomy','healthcon')){
    stop('The specified `db` does not exist. Please use one of the following: moomy, healthcon')
  }

  require(DBI)
  require(RSQLite)

  if(db == 'moomy'){
    # Number Generation
    set.seed(9)
    set1 <- runif(5000,0,9)
    set1 <- round(set1)

    set.seed(8)
    set2 <- runif(5000,0,9)
    set2 <- round(set2)

    set.seed(7)
    set3 <- runif(5000,0,9)
    set3 <- round(set3)

    # Creating the MM-IDs
    my_keys <- paste0("MM-",set1, set2, set3)

    # Vector of Unique MM-IDs
    unique_keys <- unique(my_keys)

    # Creating the product categories
    set.seed(2)
    product_ids <- sample(1:10, round(length(my_keys)/2), replace = TRUE, prob = c(0.01, 0.15, 0.6, 0.02, 0.02, 0.1, 0.05, 0.01, 0.01, 0.01))

    product_map <- data.frame(
      PID = 1:10,
      CATEGORY = c(
        'Video Games',
        'Yard Tools',
        'Pet Supplies',
        'Baby Items',
        'Televisions',
        'Jewelry',
        'Laptops',
        'Vehicles',
        'Sporting Goods',
        'Furniture'
      )
    )

    product_cost_dist <- data.frame(
      PID = 1:10,
      p_mu = c(11,24,16,48,52,36,287,6045,77,145),
      p_sd = c(2.5,4.25,3.16,6.45,1.1,10.18,35.32,108.9,5.5,22.45)
    )

    product_age_dist <- data.frame(
      PID = 1:10,
      p_mu_age_buy = c(16,31,23,29,42,33,18,25,14,31),
      p_mu_age_sell = c(18,39,29,38,36,33,22,34,19,52),
      p_sd_age_buy = c(1.2,3.3,2.1,4.1,2.1,8.1,3.5,2.1,1,4.5),
      p_sd_age_sell = c(1.4,3.1,2.2,4.5,2.2,8.7,3.1,1.5,1,4.6)
    )

    product_gender_dist <- data.frame(
      PID = 1:10,
      p_male <- c(0.9,0.85,0.25,0.1,0.55,0.01,0.65,0.48,0.91,0.44)
    )

    # Cost
    costs <- c()
    set.seed(12)
    for(i in 1:length(product_ids)){
      product_cat <- product_ids[i]
      cost_next <- rnorm(1,mean = product_cost_dist$p_mu[product_cost_dist$PID == product_cat],
                         sd = product_cost_dist$p_sd[product_cost_dist$PID == product_cat])
      cost_next <- round(cost_next)
      costs <- append(costs,cost_next)
    }

    # Buyer Demographics
    buy_gender <- c()
    buy_age <- c()
    set.seed(15)
    for(i in 1:length(product_ids)){
      product_cat <- product_ids[i]
      buy_age_next <- rnorm(1, mean = product_age_dist$p_mu_age_buy[product_age_dist$PID == product_cat],
                            sd = product_age_dist$p_sd_age_buy[product_age_dist$PID == product_cat])
      buy_age_next <- round(buy_age_next)
      buy_age <- append(buy_age,buy_age_next)

      buy_gender_next <- sample(c('M','F'),1,prob=c(product_gender_dist$p_male[product_gender_dist$PID == product_cat],
                                                    1-product_gender_dist$p_male[product_gender_dist$PID == product_cat]))

      buy_gender <- append(buy_gender, buy_gender_next)
    }

    # Seller Demographics
    sell_gender <- c()
    sell_age <- c()
    set.seed(21)
    for(i in 1:length(product_ids)){
      product_cat <- product_ids[i]
      sell_age_next <- rnorm(1, mean = product_age_dist$p_mu_age_sell[product_age_dist$PID == product_cat],
                             sd = product_age_dist$p_sd_age_sell[product_age_dist$PID == product_cat])
      sell_age_next <- round(sell_age_next)
      sell_age <- append(sell_age,sell_age_next)

      sell_gender_next <- sample(c('M','F'),1,prob=c(product_gender_dist$p_male[product_gender_dist$PID == product_cat],
                                                     1-product_gender_dist$p_male[product_gender_dist$PID == product_cat]))

      sell_gender <- append(sell_gender, sell_gender_next)
    }


    transaction_details <- data.frame(
      TRANSACTION_ID = paste0("TC-","1001",1:round(length(my_keys))),
      SELLER_MM_ID = my_keys[1:round(length(my_keys)/2)],
      BUYER_MM_ID = my_keys[round(length(my_keys)/2)+1:length(my_keys)]
    )

    transaction_products <- data.frame(
      TRANSACTION_ID = transaction_details$TRANSACTION_ID,
      PRODUCT_ID = product_ids
    )

    transaction_costs <- data.frame(
      TRANID = transaction_details$TRANSACTION_ID[1:round(nrow(transaction_details)/2)],
      COST = costs
    )

    transaction_demog <- data.frame(
      TRANSACTION_ID = transaction_details$TRANSACTION_ID[1:round(nrow(transaction_details)/2)],
      SELL_AGE = sell_age,
      BUY_AGE = buy_age,
      SELL_GENDER = sell_gender,
      BUY_GENDER = buy_gender
    )

    transaction_demog <- merge(transaction_demog, transaction_details, by = "TRANSACTION_ID")

    transaction_demog <- data.frame(
      MM_ID = c(transaction_demog$SELLER_MM_ID,transaction_demog$BUYER_MM_ID),
      AGE = c(transaction_demog$SELL_AGE, transaction_demog$BUY_AGE),
      GENDER = c(transaction_demog$SELL_GENDER, transaction_demog$BUY_GENDER)
    )

    transaction_demog <- transaction_demog[!duplicated(transaction_demog$MM_ID),]
    transaction_demog <- transaction_demog[-c(123, 440, 512, 616),]

    # In-memory database in R
    moomy <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
    assign("moomy", moomy, env = .GlobalEnv)
    message("The `moomy` database connection is now set.")

    # Inserting data into the DB
    DBI::dbWriteTable(moomy, "PRODUCT_MAP", product_map)
    DBI::dbWriteTable(moomy, "TRANSACTION_DETAILS", transaction_details)
    DBI::dbWriteTable(moomy, "TRANSACTION_PRODUCTS", transaction_products)
    DBI::dbWriteTable(moomy, "TRANSACTION_COSTS", transaction_costs)
    DBI::dbWriteTable(moomy, "TRANSACTION_DEMOG", transaction_demog)

    message("Use the function `dbListTables` from the DBI package to see what tables are available in MooMy. Ex: DBI::dbListTables(moomy)")

    questions <- c(
      "What is the average age of users who bought furniture?",
      "How many distinct males sold video games?",
      "How many distinct females bought jewelry?",
      "What is the MM_ID of the user who was apart of the most transactions (buy or sell)?",
      "What is the highest costing transaction ID?",
      "How many users apparently sold a product to themselves?",
      "How many transactions are in our database?",
      "What is the most expensive product category on average (not the product ID)?",
      "How many transactions are missing a buyer ID?"
    )
    assign("questions",questions,env = .GlobalEnv)
  }
  ######################################
  ### Setting the healthcon database ###
  ######################################
  if(db == 'healthcon'){

    message("The `healthcon` database gathers data from publicly available sources on the internet.")

    # Reading in the fake healthcare data generated for tutorials
    # fake_healthcare <- read.csv("https://raw.githubusercontent.com/JonWayland/Fake-Healthcare/master/HP-Universal_DF.csv")
    # save(fake_healthcare, file = "data\\fake_healthcare.rda")
    load("data\\fake_healthcare.rda")

    # Placeholder to read in the ICD-10 specific data generated in open health
    icd10 <- readRDS("data\\icd10.rds")
    colnames(icd10) <- toupper(colnames(icd10))
    icd10 <- data.frame(icd10)

    # Placeholder to read in the ADI data

    # Placeholder for poverty index (state of FL only)

    # Chronic Disease and Health Promotion Data (2020)
    # cdc <- read.csv("https://chronicdata.cdc.gov/api/views/qnzd-25i4/rows.csv?accessType=DOWNLOAD&bom=true&format=true")
    # cdc$GEO_LONG <- as.numeric(gsub(" .*","",gsub("POINT \\(","",cdc$Geolocation)))
    # cdc$GEO_LAT <- as.numeric(gsub(".* ","",gsub("POINT \\(|)","",cdc$Geolocation)))
    # colnames(cdc) <- toupper(c("Year", colnames(cdc)[-1]))
    # saveRDS(cdc,file="data\\cdc.rds")
    cdc <- readRDS("data\\cdc.rds")

    # Smoking Data (2011)
    # https://data.cdc.gov/Smoking-Tobacco-Use/BRFSS-Prevalence-and-Trends-Data-Tobacco-Use-Four-/ya9m-pyut
    # smoking <- smoking %>% mutate(State_Parse = gsub("\n.*","",Location.1),
    #                               GEO_LAT_PARSE = as.numeric(gsub(".*\n\\(|,.*","",Location.1)),
    #                               GEO_LONG_PARSE = as.numeric(gsub(".* |)","",Location.1)))
    smoking <- readRDS("data\\smoking.rds")

    # In-memory database in R
    healthcon <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
    assign("healthcon", healthcon, env = .GlobalEnv)

    DBI::dbWriteTable(healthcon, "FAKE_HEALTHCARE", fake_healthcare)
    DBI::dbWriteTable(healthcon, "CDC_LOCAL", cdc)
    DBI::dbWriteTable(healthcon, "ICD10_MAP", icd10)
    DBI::dbWriteTable(healthcon, "SMOKING", smoking)

    message("The `healthcon` database connection is now set.")

    message("Use the function `dbListTables` from the DBI package to see what tables are available in healthcon Ex: DBI::dbListTables(healthcon)")
    message("\nThe data residing in the FAKE_HEALTHCARE table is entirely fictional data.")
    message("\nThe data residing in the CDC_LOCAL table was sourced from the following website on 9/18/2021:\n https://chronicdata.cdc.gov/500-Cities-Places/PLACES-Local-Data-for-Better-Health-ZCTA-Data-2020/qnzd-25i4/data")
    message("\nThe data residing in the ICD10_MAP table comes from a variety of sources. Please contact Jon Wayland (jonwayland47@gmail.com) for proper citation and source code.")
  }
}
