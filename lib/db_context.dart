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

  Future<void> updateExpenseTable(
      String name, int value, DateTime date, String category) async {
    var database = await db;
    await database.insert(expensesTable, {
      "name": name,
      "value": value,
      "date": date.millisecondsSinceEpoch,
      "category": category,
    });
  }

  Future<void> updateIncomeTable(String name, int value, String source,
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
