import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expense_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // ===== BUAT TABEL =====
  Future _createDB(Database db, int version) async {
    // Tabel Users — untuk Register & Login
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    // Tabel Transactions — untuk Tambah, Riwayat, Saldo
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL,
        is_income INTEGER NOT NULL
      )
    ''');
  }

  // ===================================================
  // ===== OPERASI USERS =====
  // ===================================================

  // Simpan user baru (Register)
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user,
        conflictAlgorithm: ConflictAlgorithm.abort);
  }

  // Cek login: cari user dengan email & password cocok
  Future<Map<String, dynamic>?> getUser(
      String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }

  // Cek apakah email sudah terdaftar (untuk validasi register)
  Future<bool> emailExists(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  // ===================================================
  // ===== OPERASI TRANSAKSI =====
  // ===================================================

  // Simpan transaksi baru
  Future<int> insertTransaction(Map<String, dynamic> transaction) async {
    final db = await database;
    return await db.insert('transactions', transaction);
  }

  // Ambil semua transaksi (diurutkan terbaru dulu)
  Future<List<Map<String, dynamic>>> getAllTransactions() async {
    final db = await database;
    return await db.query('transactions', orderBy: 'id DESC');
  }

  // Ambil N transaksi terakhir untuk Dashboard
  Future<List<Map<String, dynamic>>> getRecentTransactions(int limit) async {
    final db = await database;
    return await db.query('transactions', orderBy: 'id DESC', limit: limit);
  }

  // Hitung total saldo (pemasukan - pengeluaran)
  Future<double> getTotalBalance() async {
    final db = await database;

    final incomeResult = await db.rawQuery(
        'SELECT COALESCE(SUM(amount), 0) as total FROM transactions WHERE is_income = 1');
    final expenseResult = await db.rawQuery(
        'SELECT COALESCE(SUM(amount), 0) as total FROM transactions WHERE is_income = 0');

    final income =
        (incomeResult.first['total'] as num?)?.toDouble() ?? 0.0;
    final expense =
        (expenseResult.first['total'] as num?)?.toDouble() ?? 0.0;

    return income - expense;
  }

  // Hapus transaksi berdasarkan ID
  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db
        .delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  // Tutup database
  Future close() async {
    final db = await database;
    db.close();
  }
}
