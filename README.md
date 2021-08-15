# one01
The `one01` R package is built for 101 trainings. Current trainings include:
* SQL (using SQLite)

`devtools::install_github("JonWayland/one01")`

**Description** MooMy is a marketplace app that people can shop for local used goods. The business model is such that for every transaction that occurs on the app, MooMy takes 1%. For example, if a used bike is sold at $100 then MooMy makes $1 on the transaction. The transaction that occurs is similar to how Venmo does it (using APIs to speak to financial institutions).

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

## `qa()`
This function maps to the `questions` vector and allows the user to input a SQL query to attempt to answer the specific business question. If the query is incorrect, the user will be given a message telling them so. Similarly, if the SQL query is correct then the user will be informed that they were successful.


