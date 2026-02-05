import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/expense_model.dart';

class ExpenseDB {
  ExpenseDB._private();
  static final ExpenseDB instance = ExpenseDB._private();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'expenses.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE expenses(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount INTEGER NOT NULL,
            reason TEXT
          )
        ''');
      },
    );
  }

  // ================= CRUD =================

  Future<int> insertExpense(ExpenseModel expense) async {
    final db = await database;
    return await db.insert('expenses', expense.toMap());
  }

  Future<List<ExpenseModel>> getAllExpenses() async {
    final db = await database;
    final maps = await db.query('expenses');

    return maps.map((e) => ExpenseModel.fromMap(e)).toList();
  }

  Future<int> updateExpense(ExpenseModel expense) async {
    final db = await database;
    return await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> deleteExpense(int id) async {
    final db = await database;
    return await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
