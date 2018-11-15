import 'package:firstflut/RecurrentIncome.dart';
import 'package:firstflut/Expense.dart';
import 'package:firstflut/Income.dart';
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

  Future<void> onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $recurrentIncomeTable (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, source TEXT, date INTEGER, isEnabled BIT);
        ''');

    await db.execute('''
        CREATE TABLE $expensesTable (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, date INTEGER)
      ''');

    await db.execute('''
        CREATE TABLE $incomeTable (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, source TEXT, date INTEGER)
      ''');

    await db.insert(recurrentIncomeTable, {
      "name": "bursa1",
      "value": 850,
      "source": "utm2",
      "date": DateTime.now().millisecondsSinceEpoch,
      "isEnabled": true
    });

    await db.insert(expensesTable, {
      "name": "drinks",
      "value": 1000,
      "date": DateTime.now().millisecondsSinceEpoch,
    });
  }


  Future<void> updateExpenseTable(String name, int value, DateTime date) async {
    var database = await db;
    await database.insert(expensesTable, {
      "name": name,
      "value": value,
      "date": date.millisecondsSinceEpoch,
    });
  }

  Future<void> updateRecurrentIncomeTable(String name, int value, String source,
      DateTime date, bool isEnabled) async {
    var database = await db;
    await database.insert(recurrentIncomeTable, {
      "name": name,
      "value": value,
      "source": source,
      "date": date.millisecondsSinceEpoch,
      "isEnabled": isEnabled
    });
  }

  Future<void> updateIncomeTable(String name, int value, String source,
      DateTime date) async {
    var database = await db;
    await database.insert(incomeTable, {
      "name": name,
      "value": value,
      "source": source,
      "date": date.millisecondsSinceEpoch,
    });
  }

  Future<List<RecurrentIncome>> readRecurrentIncome() async {
    var database = await db;
    var recurrentIncomes = await database.query(recurrentIncomeTable);
    return recurrentIncomes.map((m) => RecurrentIncome.fromMap(m)).toList();
  }


  Future<List<Expense>> readExpense() async {
    var database = await db;
    var expenses = await database.query(expensesTable);
    return expenses.map((m) => Expense.fromMap(m)).toList();
  }

  Future<List<Income>> readIncome() async { 
    var database = await db;
    var incomes = await database.query(incomeTable);
    return incomes.map((m) => Income.fromMap(m)).toList();
  }

  Future<dynamic> toggle(RecurrentIncome income) async {
    var database = await db;
    await database.update(recurrentIncomeTable, income.toMap(),
        where: 'id = ?', whereArgs: [income.id]);
  }
}
