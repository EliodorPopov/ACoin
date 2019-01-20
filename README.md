# acoin

A new Flutter Amdaris-UTM Project.

# Arhitectura bazei de date:

## Tabelul Expenses:

| Column   | Type   | Description                    |
|----------|--------|--------------------------------|
| id       | int    | Id of the tuple                |
| name     | String | Name of the expense            |
| value    | int    | Value of the expense(MDL)      |
| date     | int    | Date in millisecondsSinceEpoch |
| category | String | Category                       |

## Tabelul RecurrentIncome

| Column   | Type   | Description                    |
|----------|--------|--------------------------------|
| id       | int    | Id of the tuple                |
| name     | String | Name of the income             |
| value    | int    | Value of the income(MDL)       |
| source   | String | source of the income           |
| date     | int    | date                           |
| isEnable | bool   | is it recurrent?               |

## Tabelul Income

| Column   | Type   | Description                    |
|----------|--------|--------------------------------|
| id       | int    | Id of the tuple                |
| name     | String | Name of the income             |
| value    | int    | Value of the income(MDL)       |
| source   | String | source of the income           |
| date     | int    | date                           |

## Tabelul Goals

| Column   | Type   | Description                    |
|----------|--------|--------------------------------|
| id       | int    | Id of the tuple                |
| name     | String | Name of the goal               |
| value    | int    | Value of the goal(MDL)         |

## Tabelul Goals

| Column         | Type   | Description                    |
|----------------|--------|--------------------------------|
| id             | int    | Id of the tuple                |
| id_transaction | int    | id of the connected goal       |
| value          | int    | Value of the added money(MDL)  |
| details        | String | details of added money         |


## Tabelul Categories

| Column   | Type   | Description                    |
|----------|--------|--------------------------------|
| id       | int    | Id of the tuple                |
| name     | String | name of the category           |
| path     | String | path for the image             |