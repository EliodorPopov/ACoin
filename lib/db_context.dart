import 'package:acoin/GoalTransaction.dart';
import 'package:acoin/goal.dart';
import 'package:acoin/recurrentIncome.dart';
import 'package:acoin/expense.dart';
import 'package:acoin/income.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbContext {
  Future<Database> _db;
  static final DbContext _instance = new DbContext._internal();
  factory DbContext() => _instance;
  DbContext._internal();

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

  Future<void> onCreate(Database db, int version) async {
    //CHANGE VALUES TO FLOAT
    await db.execute('''
        CREATE TABLE $recurrentIncomeTable (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, source TEXT, date INTEGER, isEnabled BIT);
        ''');

    await db.execute('''
        CREATE TABLE $expensesTable (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, date INTEGER, category TEXT)
      ''');

    await db.execute('''
        CREATE TABLE $incomeTable (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, source TEXT, date INTEGER)
      ''');

    await db.execute('''
        CREATE TABLE $goalsTable (id INTEGER PRIMARY KEY, name TEXT, value INTEGER)
    ''');

    await db.execute('''
        CREATE TABLE $goalsTransactionTable(id INTEGER PRIMARY KEY, id_transaction INTEGER, value INTEGER, details TEXT)
    ''');


    await db.insert(recurrentIncomeTable, {
      "name": "mock Recurrent Income",
      "value": 850,
      "source": "mock Source",
      "date": DateTime.now().millisecondsSinceEpoch,
      "isEnabled": true
    });

    await db.insert(incomeTable, {
      "name": "mock Income",
      "value": 1000,
      "source": "mock Source",
      "date": DateTime.now().millisecondsSinceEpoch,
    });

    await db.insert(expensesTable, {
      "name": "mock Expense",
      "value": 1000,
      "date": DateTime.now().millisecondsSinceEpoch,
      "category": "mock Category",
    });
  }

  Future<void> addExpense(
      String name, int value, DateTime date, String category) async {
    var database = await db;
    await database.insert(expensesTable, {
      "name": name,
      "value": value,
      "date": date.millisecondsSinceEpoch,
      "category": category,
    });
  }

  Future<void> addIncome(String name, int value, String source,
      DateTime date, bool isRecurrent) async {
    var database = await db;
    if (isRecurrent) {
      await database.insert(recurrentIncomeTable, {
        "name": name,
        "value": value,
        "source": source,
        "date": date.millisecondsSinceEpoch,
        "isEnabled": true
      });
    } else {
      await database.insert(incomeTable, {
        "name": name,
        "value": value,
        "source": source,
        "date": date.millisecondsSinceEpoch,
      });
    }
  }

  Future<void> addGoal(
      String name,int value) async {
    var database = await db;
    await database.insert(goalsTable, {
      "name": name,
      "value": value,
    });
  }

  Future<void> addGoalTransaction(
      int id, int value, String details) async {
    var database = await db;
    await database.insert(goalsTransactionTable, {
      "id_transaction": id,
      "value": value,
      "details": details,
    });
  }

  Future<List<RecurrentIncome>> readRecurrentIncome() async {
    var database = await db;
    var recurrentIncomes = await database.query(recurrentIncomeTable);
    return recurrentIncomes.map((m) => RecurrentIncome.fromMap(m)).toList();
  }

  Future<List<RecurrentIncome>> readRecurrentIncome2(String period) async {
    var database = await db;
    int minPeriod;
    int maxPeriod = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day+1).millisecondsSinceEpoch;
    var now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    switch(period){
      case 'Today': minPeriod = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
        break;
      case 'This week': minPeriod = DateTime(now.year, now.month, now.day-now.weekday+1).millisecondsSinceEpoch;
        break;
      case 'This month': minPeriod = DateTime(now.year, now.month, 1).millisecondsSinceEpoch;
        break;
      case 'Last month': minPeriod = DateTime(now.year, now.month-1, 1).millisecondsSinceEpoch;
        maxPeriod = (DateTime(now.year, now.month-1, 1).add(new Duration(days: 30))).millisecondsSinceEpoch;
        //currently not possible to add 1 month, you have to do it manually for every month and take into consideration leap years
        break;
      case 'This year': minPeriod = DateTime(now.year, 1,1).millisecondsSinceEpoch;
        break;
      default: minPeriod = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    }
    
    var recurrentIncomes = await database.rawQuery('SELECT * FROM $recurrentIncomeTable where date >= $minPeriod and date < $maxPeriod');
    if (period == 'All time') recurrentIncomes = await database.query(recurrentIncomeTable);
    return recurrentIncomes.map((m) => RecurrentIncome.fromMap(m)).toList();
  }

  Future<List<Expense>> readExpense() async {
    var database = await db;
    var standard = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    print(standard.millisecondsSinceEpoch);
    var expenses = await database.query(expensesTable);
    return expenses.map((m) => Expense.fromMap(m)).toList();
  }

  Future<List<Expense>> readExpense2(String period) async {
    var database = await db;
    int minPeriod;
    int maxPeriod = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day+1).millisecondsSinceEpoch;
    var now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    switch(period){
      case 'Today': minPeriod = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
        break;
      case 'This week': minPeriod = DateTime(now.year, now.month, now.day-now.weekday+1).millisecondsSinceEpoch;
        break;
      case 'This month': minPeriod = DateTime(now.year, now.month, 1).millisecondsSinceEpoch;
        break;
      case 'Last month': minPeriod = DateTime(now.year, now.month-1, 1).millisecondsSinceEpoch;
        maxPeriod = (DateTime(now.year, now.month-1, 1).add(new Duration(days: 30))).millisecondsSinceEpoch;
        //currently not possible to add 1 month, you have to do it manually for every month and take into consideration leap years
        break;
      case 'This year': minPeriod = DateTime(now.year, 1,1).millisecondsSinceEpoch;
        break;
      default: minPeriod = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    }
    var expenses = await database.rawQuery('SELECT * FROM $expensesTable where date >= $minPeriod and date < $maxPeriod');
    if (period == 'All time') expenses = await database.query(expensesTable);
    return expenses.map((m) => Expense.fromMap(m)).toList();
  }

  Future<List<Income>> readIncome() async {
    var database = await db;
    var incomes = await database.query(incomeTable);
    return incomes.map((m) => Income.fromMap(m)).toList();
  }

  Future<List<Income>> readIncome2(String period) async {
    var database = await db;
    int minPeriod;
    int maxPeriod = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day+1).millisecondsSinceEpoch;
    var now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    switch(period){
      case 'Today': minPeriod = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
        break;
      case 'This week': minPeriod = DateTime(now.year, now.month, now.day-now.weekday+1).millisecondsSinceEpoch;
        break;
      case 'This month': minPeriod = DateTime(now.year, now.month, 1).millisecondsSinceEpoch;
        break;
      case 'Last month': minPeriod = DateTime(now.year, now.month-1, 1).millisecondsSinceEpoch;
        maxPeriod = (DateTime(now.year, now.month-1, 1).add(new Duration(days: 30))).millisecondsSinceEpoch;
        //currently not possible to add 1 month, you have to do it manually for every month and take into consideration leap years
        break;
      case 'This year': minPeriod = DateTime(now.year, 1,1).millisecondsSinceEpoch;
        break;
      default: minPeriod = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    }
    var incomes = await database.rawQuery('SELECT * FROM $incomeTable where date >= $minPeriod and date < $maxPeriod');
    if (period == 'All time') incomes = await database.query(incomeTable);
    return incomes.map((m) => Income.fromMap(m)).toList();
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

  Future<dynamic> toggle(RecurrentIncome income) async {
    var database = await db;
    await database.update(recurrentIncomeTable, income.toMap(),
        where: 'id = ?', whereArgs: [income.id]);
  }

  Future<void> editExpense(
      int id, String name, int value, DateTime date, String category) async {
    var database = await db;
    int date2 = date.millisecondsSinceEpoch;
    await database.execute('''
      update $expensesTable 
      set name = '$name',
          value = $value,
          date = $date2,
          category = '$category'
      where id = $id
    ''');
  }

  Future<void> editIncome(int id, String name, int value, DateTime date,
      String source, bool isRecurrent) async {
    var database = await db;
    int date2 = date.millisecondsSinceEpoch;
    final String table = isRecurrent ? recurrentIncomeTable : incomeTable;
    await database.execute('''
      update $table 
      set name = '$name',
          value = $value,
          date = $date2,
          source = '$source'
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
}
