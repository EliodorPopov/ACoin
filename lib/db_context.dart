import 'package:acoin/GoalTransaction.dart';
import 'package:acoin/category.dart';
import 'package:acoin/goal.dart';
import 'package:acoin/debt.dart';
import 'package:acoin/recurrentIncome.dart';
import 'package:acoin/expense.dart';
import 'package:acoin/income.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbContext {
  Future<Database> _db;
  static final DbContext _instance = new DbContext._internal();
  factory DbContext() => _instance;
  DbContext._internal();
  int minPeriod;
  int maxPeriod;
  DateTime now;
  Future<Database> get db {
    if (_db == null) _db = initialize();
    return _db;
  }

  Future<Database> initialize() async {
    var directory = await getApplicationDocumentsDirectory();
    var databasePath = join(directory.path, 'acoin.db');
    var db =
        await openDatabase(databasePath, onCreate: this.onCreate, version: 1);
    return db;
  }

  final String recurrentIncomeTable = "RecurrentIncomeTable";
  final String expensesTable = "ExpensesTable";
  final String incomeTable = "IncomeTable";
  final String goalsTable = "GoalsTable";
  final String goalsTransactionTable = "GoalsTransactionTable";
  final String categoriesTable = "CategoriesTable";
  final String debtTable = "Debt";

  Future<void> onCreate(Database db, int version) async {
    //CHANGE VALUES TO FLOAT

    await db.execute('''
    CREATE TABLE $categoriesTable(id INTEGER PRIMARY KEY, name TEXT, path TEXT, categoryStatus INTEGER)
    ''');

    await db.execute('''
        CREATE TABLE $recurrentIncomeTable (
          id INTEGER PRIMARY KEY, 
          name TEXT, value INTEGER, 
          sourceId INTEGER, date INTEGER, 
          isEnabled BIT, 
          FOREIGN KEY(sourceId) REFERENCES $categoriesTable(id))
        ''');

    await db.execute('''
        CREATE TABLE $expensesTable (
          id INTEGER PRIMARY KEY, 
          name TEXT, 
          value INTEGER, 
          date INTEGER, 
          categoryId INTEGER,
          FOREIGN KEY(categoryId) REFERENCES $categoriesTable(id))
      ''');

    await db.execute('''
        CREATE TABLE $incomeTable (
          id INTEGER PRIMARY KEY, 
          name TEXT, 
          value INTEGER, 
          sourceId INTEGER, 
          date INTEGER,
          FOREIGN KEY(sourceId) REFERENCES $categoriesTable(id))
      ''');

    await db.execute('''
        CREATE TABLE $goalsTable (id INTEGER PRIMARY KEY, name TEXT, target INTEGER, value INTEGER)
    ''');

    await db.execute('''
        CREATE TABLE $goalsTransactionTable(id INTEGER PRIMARY KEY, id_transaction INTEGER, value INTEGER, details TEXT)
    ''');

    await db.insert(categoriesTable, {
      "name": "mock Category",
      "path": "images/power.png",
      "categoryStatus": "1"
    });

    await db.insert(categoriesTable, {
      "name": "mock Category2",
      "path": "images/power.png",
      "categoryStatus": "2"
    });

    await db.execute('''
        CREATE TABLE $debtTable (id INTEGER PRIMARY KEY, pname TEXT, debtvalue INTEGER, date INTEGER, deadlinedate INTEGER)
        ''');

    await db.insert(recurrentIncomeTable, {
      "name": "mock Recurrent Income",
      "value": 850,
      "sourceId": 2,
      "date": DateTime.now().millisecondsSinceEpoch,
      "isEnabled": true
    });

    await db.insert(incomeTable, {
      "name": "mock Income",
      "value": 1000,
      "sourceId": 2,
      "date": DateTime.now().millisecondsSinceEpoch,
    });

    await db.insert(expensesTable, {
      "name": "mock Expense",
      "value": 1000,
      "date": DateTime.now().millisecondsSinceEpoch,
      "categoryId": 1,
    });

    await db.insert(
        goalsTable, {"name": "mock goal", "value": 1000, "target": 5000});
  }

  Future<void> addExpense(
      String name, int value, DateTime date, int categoryId) async {
    var database = await db;
    await database.insert(expensesTable, {
      "name": name,
      "value": value,
      "date": date.millisecondsSinceEpoch,
      "categoryId": categoryId,
    });
  }

  Future<void> addIncome(String name, int value, int sourceId, DateTime date,
      bool isRecurrent) async {
    var database = await db;
    if (isRecurrent) {
      await database.insert(recurrentIncomeTable, {
        "name": name,
        "value": value,
        "sourceId": sourceId,
        "date": date.millisecondsSinceEpoch,
        "isEnabled": true
      });
    } else {
      await database.insert(incomeTable, {
        "name": name,
        "value": value,
        "sourceId": sourceId,
        "date": date.millisecondsSinceEpoch,
      });
    }
  }

  Future<void> addGoal(String name, int target) async {
    var database = await db;
    await database
        .insert(goalsTable, {"name": name, "target": target, "value": 0});
  }

  Future<void> addGoalTransaction(int id, int value, String details) async {
    var database = await db;
    await database.insert(goalsTransactionTable, {
      "id_transaction": id,
      "value": value,
      "details": details,
    });
  }

  Future<void> addCategory(String name, String path, int categoryStatus) async {
    var database = await db;
    await database.insert(categoriesTable, {
      "name": name,
      "path": path,
      "categoryStatus": categoryStatus,
    });
  }

  Future<void> addDebt(
      String pname, int debtvalue, DateTime date, DateTime deadlinedate) async {
    var database = await db;
    await database.insert(debtTable, {
      "pname": pname,
      "debtvalue": debtvalue,
      "date": date.millisecondsSinceEpoch,
      "deadlinedate": deadlinedate.millisecondsSinceEpoch,
    });
  }

  void setPeriod(String period) {
    maxPeriod = DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day + 1)
        .millisecondsSinceEpoch;
    now =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    switch (period) {
      case 'Today':
        minPeriod =
            DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
        break;
      case 'This week':
        minPeriod = DateTime(now.year, now.month, now.day - now.weekday + 1)
            .millisecondsSinceEpoch;
        break;
      case 'This month':
        minPeriod = DateTime(now.year, now.month, 1).millisecondsSinceEpoch;
        break;
      case 'Last month':
        minPeriod = DateTime(now.year, now.month - 1, 1).millisecondsSinceEpoch;
        maxPeriod =
            (DateTime(now.year, now.month - 1, 1).add(new Duration(days: 30)))
                .millisecondsSinceEpoch;
        //currently not possible to add 1 month, you have to do it manually for every month and take into consideration leap years
        break;
      case 'This year':
        minPeriod = DateTime(now.year, 1, 1).millisecondsSinceEpoch;
        break;
      default:
        minPeriod =
            DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    }
  }

  Future<List<RecurrentIncome>> readRecurrentIncome(String period) async {
    var database = await db;
    List<Map<String, dynamic>> recurrentIncomes;
    if (period == 'All time')
      recurrentIncomes = await database.rawQuery('''
          SELECT i.*, c.name as sourceName, c.path as sourcePath, c.categoryStatus as sourceStatus 
          FROM $recurrentIncomeTable i
          JOIN $categoriesTable c 
          ON i.sourceId = c.id''');
    else {
      setPeriod(period);
      recurrentIncomes = await database.rawQuery('''
          SELECT i.*, c.name as sourceName, c.path as sourcePath, c.categoryStatus as sourceStatus 
          FROM $recurrentIncomeTable i
          JOIN $categoriesTable c 
          ON i.sourceId = c.id
          where date >= $minPeriod and date < $maxPeriod''');
    }
    return recurrentIncomes.map((m) => RecurrentIncome.fromMap(m)).toList();
  }

  Future<List<Expense>> readExpense(String period) async {
    var database = await db;
    List<Map<String, dynamic>> expenses;
    if (period == 'All time')
      expenses = await database.rawQuery('''
          SELECT e.*, c.name as categoryName, c.path as categoryIconPath, c.categoryStatus as categoryStatus 
          FROM $expensesTable e
          JOIN $categoriesTable c 
          ON e.categoryId = c.id''');
    else {
      setPeriod(period);
      expenses = await database.rawQuery('''
          SELECT e.*, c.name as categoryName, c.path as categoryIconPath, c.categoryStatus as categoryStatus 
          FROM $expensesTable e
          JOIN $categoriesTable c 
          ON e.categoryId = c.id
          where e.date >= $minPeriod and e.date < $maxPeriod''');
    }
    return expenses.map((m) => Expense.fromMap(m)).toList();
  }

  Future<List<Income>> readIncome(String period) async {
    var database = await db;
    List<Map<String, dynamic>> incomes;
    if (period == 'All time')
      incomes = await database.rawQuery('''
          SELECT i.*, c.name as sourceName, c.path as sourcePath, c.categoryStatus as sourceStatus 
          FROM $incomeTable i
          JOIN $categoriesTable c 
          ON i.sourceId = c.id''');
    else {
      setPeriod(period);
      incomes = await database.rawQuery(
          '''SELECT i.*, c.name as sourceName, c.path as sourcePath, c.categoryStatus as sourceStatus 
          FROM $incomeTable i
          JOIN $categoriesTable c 
          ON i.sourceId = c.id where date >= $minPeriod and date < $maxPeriod''');
    }
    return incomes.map((m) => Income.fromMap(m)).toList();
  }

  Future<List<Category>> readCategories(int categoryStatus) async {
    var database = await db;
    List<Map<String, dynamic>> categories;
    categories = await database.rawQuery('''
          SELECT * 
          FROM $categoriesTable
          where categoryStatus = $categoryStatus''');
    return categories.map((m) => Category.fromMap(m)).toList();
  }

  Future<List<Goal>> readGoals() async {
    var database = await db;
    var goals = await database.query(goalsTable);
    return goals.map((m) => Goal.fromMap(m)).toList();
  }

  Future<List<GoalTransaction>> readGoalsTransaction() async {
    var database = await db;
    var goalsTransaction = await database.query(goalsTransactionTable);
    return goalsTransaction.map((m) => GoalTransaction.fromMap(m)).toList();
  }

  Future<List<Debt>> readDebts() async {
    var database = await db;
    List<Map<String, dynamic>> debts;
    debts = await database.rawQuery('SELECT * FROM $debtTable');
    return debts.map((m) => Debt.fromMap(m)).toList();
  }

  Future<dynamic> toggle(RecurrentIncome income) async {
    var database = await db;
    await database.update(recurrentIncomeTable, income.toMap(),
        where: 'id = ?', whereArgs: [income.id]);
  }

  Future<void> editExpense(
      int id, String name, int value, DateTime date, int categoryId) async {
    var database = await db;
    int date2 = date.millisecondsSinceEpoch;
    await database.execute('''
      update $expensesTable 
      set name = '$name',
          value = $value,
          date = $date2,
          categoryId = '$categoryId'
      where id = $id
    ''');
  }

  Future<void> editIncome(int id, String name, int value, DateTime date,
      int sourceId, bool isRecurrent) async {
    var database = await db;
    int date2 = date.millisecondsSinceEpoch;
    final String table = isRecurrent ? recurrentIncomeTable : incomeTable;
    await database.execute('''
      update $table 
      set name = '$name',
          value = $value,
          date = $date2,
          source = $sourceId
      where id = $id
    ''');
  }

  Future<void> editCategory(
      int id, String name, String path, int categoryStatus) async {
    var database = await db;
    await database.execute('''
      update $categoriesTable 
      set name = '$name',
          path = '$path',
          categoryStatus = $categoryStatus
    ''');
  }

  Future<void> editDebt(int id, String pname, int debtvalue, DateTime date,
      DateTime deadlinedate) async {
    var database = await db;
    await database.execute('''
    update $debtTable 
      set pname = '$pname',
          debtvalue = $debtvalue,
          date = $date,
          deadlinedate = $deadlinedate,
      where id = $id
    ''');
  }

  Future<void> editGoals(int id, String name, int value, int target) async {
    var database = await db;
    await database.execute('''
      update $goalsTable 
      set name = '$name',
          target = $target
      where id = $id
    ''');
  }

  Future<void> chageGoalsValue(int id, int value) async {
    var database = await db;
    await database.execute('''
      update $goalsTable 
      set value = $value
      where id = $id
    ''');
  }

  Future<void> deleteExpense(int id) async {
    var database = await db;
    await database.execute('''
      delete from $expensesTable
      where id = $id
    ''');
  }

  Future<void> deleteIncome(int id, bool isRecurrent) async {
    var database = await db;
    final String table = isRecurrent ? recurrentIncomeTable : incomeTable;
    await database.execute('''
      delete from $table
      where id = $id
    ''');
  }

  Future<void> deleteDebt(int id) async {
    var database = await db;
    await database.execute('''
      delete from $debtTable
      where id = $id
    ''');
  }

  Future<void> deleteCategory(int id) async {
    var database = await db;
    await database.execute('''
    update $categoriesTable 
      set categoryStatus = 0
      where id = $id
    ''');
  }

  Future<void> deleteGoal(int id) async {
    var database = await db;
    await database.execute('''
      delete from $goalsTable
      where id = $id
    ''');
  }
}
