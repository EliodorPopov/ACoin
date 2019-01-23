# acoin

A new Flutter Amdaris-UTM Project.

# Database in SQFlite architecture:

## Expenses Table:

| Column     | Type   | Description                    |
|------------|--------|--------------------------------|
| id         | int    | Id of the tuple                |
| name       | String | Name of the expense            |
| value      | int    | Value of the expense(MDL)      |
| date       | int    | Date in millisecondsSinceEpoch |
| categoryID | int    | FK in categoriesTable          |

## RecurrentIncome Table

| Column   | Type   | Description                    |
|----------|--------|--------------------------------|
| id       | int    | Id of the tuple                |
| name     | String | Name of the income             |
| value    | int    | Value of the income(MDL)       |
| sourceId | int    | FK to categoriesTable          |
| date     | int    | date                           |
| isEnable | bool   | is it recurrent?               |

## Income Table

| Column   | Type   | Description                    |
|----------|--------|--------------------------------|
| id       | int    | Id of the tuple                |
| name     | String | Name of the income             |
| value    | int    | Value of the income(MDL)       |
| sourceId | int    | FK to categoriesTable          |
| date     | int    | date                           |

## Goals Table

| Column   | Type   | Description                    |
|----------|--------|--------------------------------|
| id       | int    | Id of the tuple                |
| name     | String | Name of the goal               |
| value    | int    | Value of the goal(MDL)         |

## GoalsTransactions Table

| Column         | Type   | Description                    |
|----------------|--------|--------------------------------|
| id             | int    | Id of the tuple                |
| id_transaction | int    | id of the connected goal       |
| value          | int    | Value of the added money(MDL)  |
| details        | String | details of added money         |


## Categories Table

| Column   | Type   | Description                    |
|----------|--------|--------------------------------|
| id       | int    | Id of the tuple                |
| name     | String | name of the category           |
| path     | String | path for the image             |