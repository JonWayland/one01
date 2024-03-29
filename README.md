# one01
The `one01` R package was originally built for training users on basic SQL coding in a real-world context. Though it still serves this purpose, it has since grown into a wrapper for the [DBI](https://dbi.r-dbi.org/) package. The databases this package uses are built with SQLite, and thus the SQL syntax it uses follows the [SQLite version of the language](https://www.sqlite.org/lang.html).

`devtools::install_github("JonWayland/one01")`

**Description** MooMy is a marketplace app that people can shop for local used goods. The business model is such that for every transaction that occurs on the app, MooMy takes 1%. For example, if a used bike is sold at $100 then MooMy makes $1 on the transaction. The transaction that occurs is similar to how Venmo does it (using APIs to speak to financial institutions). 

**Additional Notes:**
- If a transaction does not include the buyer ID then it is assumed to be a secondary transaction
- Secondary transactions are transactions that result from a primary transaction and are intended to record the 1% fee that MooMy takes
- Because there hasn't yet been a financial reconciliation, the 1% fees are not listed complete; however, the secondary transactions are automatic

## `createDB()`
This function generates the SQLite database, `moomy`, as well as a vector of business questions for users to practice their SQL skills called `questions`. There are currently 8 questions that test one's SQL skills with plans for more to be included. As of 8/14/2021, here are the 8 questions that are included:
- What is the average age of users who bought furniture?
- How many distinct males sold video games?
- How many distinct females bought jewelry?
- What is the MM_ID of the user who was apart of the most transactions (buy or sell)?
- What is the highest costing transaction ID?
- How many users apparently sold a product to themselves?
- How many transactions are in our database?
- What is the most expensive product category on average (not the product ID)?
- How many transactions are missing a buyer ID?

## `qa()`
This function maps to the `questions` vector and allows the user to input a SQL query to attempt to answer the specific business question. If the query is incorrect, the user will be given a message telling them so. Similarly, if the SQL query is correct then the user will be informed that they were successful.

## Practice Project Description
The `questions` vector provide the means for the user to gain comfortability with the database and practice their SQL skills; however, the higher-level goal of the MooMy project is to perform the financial reconciliation. In other words, the question that the MooMy leadership team is asking is **how much revenue did their firm earn from the transactions logged in the `moomy` database?**

Please refer to the **Description** and **Additional Notes** section in order to answer this question.

#### Helpful Hints
- This is a financial reconciliation to determine the amount MooMy makes, and is highly aduitable (meaning it can't be incorrect)
- The logged transactions with missing buyer IDs represent "blanket" transactions for these payments to be processed
- This project _should_ be completed with each step used documented clearly
- The project should only be considered for the `moomy` DB
