import 'package:sqflite/sqflite.dart'; // Import SQLite untuk menyimpan data lokal
import 'package:path/path.dart'; // Import path untuk mengatur lokasi file database
import 'package:intl/intl.dart'; // Import intl untuk format tanggal

class DatabaseHelper { // Class untuk mengatur semua urusan database

  // Membuat 1 object DatabaseHelper saja agar tidak berulang-ulang
  static final DatabaseHelper _instance = DatabaseHelper._internal(); 
  // Variabel untuk menyimpan database
  static Database? _database;

  // Factory agar setiap memanggil DatabaseHelper tetap memakai object yang sama
  factory DatabaseHelper() => _instance;

  // Constructor private
  DatabaseHelper._internal();

  // Getter untuk mengambil database
  Future<Database> get database async {
    // Kalau database sudah ada, langsung pakai
    if (_database != null) return _database!;
    // Kalau belum ada, buat database dulu
    _database = await _initDatabase();
    return _database!;
  }

  // Fungsi untuk membuat/membuka database
  Future<Database> _initDatabase() async {

    // Menentukan lokasi dan nama file database
    String path = join(await getDatabasesPath(), 'agenda_nusantara.db');

    // Membuka database
    return await openDatabase(
      path,
      version: 2,
      // Dipanggil kalau database baru dibuat
      onCreate: _onCreate,
      // Dipanggil kalau versi database berubah
      onUpgrade: _onUpgrade,
    );
  }

  // Fungsi update database jika versi naik
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Kalau versi lama di bawah 2, tambah kolom completed_date
    if (oldVersion < 2) { 
      await db.execute('ALTER TABLE tasks ADD COLUMN completed_date TEXT');
    }
  }

  // Fungsi membuat tabel pertama kali
  Future<void> _onCreate(Database db, int version) async {

    // Membuat tabel tasks untuk menyimpan tugas
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        due_date TEXT,
        category TEXT,
        is_completed INTEGER DEFAULT 0,
        completed_date TEXT
      )
    ''');

    // Membuat tabel users untuk menyimpan akun login
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    // Membuat akun default
    // Username: user
    // Password: user
    await db.insert('users', {
      'username': 'user',
      'password': 'user',
    });
  }

  // Fungsi untuk login
  Future<Map<String, dynamic>?> login(String username, String password) async {
    // Mengambil database
    Database db = await database;
     // Mencari user yang username dan password-nya cocok
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
     // Kalau data ditemukan, berarti login berhasil
    if (results.isNotEmpty) {
      return results.first;
    }
    // Kalau tidak ditemukan, login gagal
    return null;
  }

  // Fungsi untuk mengganti password user
  Future<int> updateUserPassword(String username, String newPassword) async {
    Database db = await database;
    // Update password berdasarkan username
    return await db.update(
      'users',
      {'password': newPassword},
      where: 'username = ?',
      whereArgs: [username],
    );
  }

  // CRUD Operations (Tasks) / Fungsi untuk menambah tugas
  Future<int> insertTask(Map<String, dynamic> row) async {
    Database db = await database;
    // Masukkan data ke tabel tasks
    return await db.insert('tasks', row);
  }

  // Fungsi untuk mengambil semua data tugas
  Future<List<Map<String, dynamic>>> queryAllTasks() async {
    Database db = await database;
    // Ambil semua tugas, urut berdasarkan tanggal jatuh tempo
    return await db.query('tasks', orderBy: 'due_date ASC');
  }

  // Fungsi untuk update data tugas
  Future<int> updateTask(Map<String, dynamic> row) async {
    Database db = await database;
    // Mengambil id tugas
    int id = row['id'];
    
    // Jika ditandai selesai (is_completed = 1), catat tanggal hari ini
    if (row['is_completed'] == 1) { 
      row = Map<String, dynamic>.from(row); // Copy data dulu agar aman
      row['completed_date'] = DateFormat('yyyy-MM-dd').format(DateTime.now()); // Simpan tanggal selesai hari ini
    } else {
      // Kalau tugas belum selesai, hapus tanggal selesai
      row = Map<String, dynamic>.from(row);
      row['completed_date'] = null;
    }
    // Update tugas berdasarkan id
    return await db.update('tasks', row, where: 'id = ?', whereArgs: [id]);
  }
  
  // Fungsi untuk menghapus tugas
  Future<int> deleteTask(int id) async {
    Database db = await database;
    // Hapus tugas berdasarkan id
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  // Fungsi untuk mengambil statistik tugas
  Future<Map<String, int>> getTaskStats() async {
    Database db = await database;

    // Hitung jumlah tugas penting
    var important = await db.rawQuery('SELECT COUNT(*) as count FROM tasks WHERE category = "Penting"');
    // Hitung jumlah tugas biasa
    var normal = await db.rawQuery('SELECT COUNT(*) as count FROM tasks WHERE category = "Biasa"');
    // Hitung jumlah tugas selesai
    var completed = await db.rawQuery('SELECT COUNT(*) as count FROM tasks WHERE is_completed = 1');
    // Hitung jumlah tugas belum selesai
    var pending = await db.rawQuery('SELECT COUNT(*) as count FROM tasks WHERE is_completed = 0');

  // Mengembalikan semua hasil hitungan
    return {
      'total_important': Sqflite.firstIntValue(important) ?? 0,
      'total_normal': Sqflite.firstIntValue(normal) ?? 0,
      'total_completed': Sqflite.firstIntValue(completed) ?? 0,
      'total_pending': Sqflite.firstIntValue(pending) ?? 0,
    };
  }

  // Fungsi untuk mengambil data grafik 7 hari terakhir
  Future<List<int>> getTasksPerDay() async {
    Database db = await database;

    // List untuk menyimpan jumlah tugas per hari
    List<int> counts = [];

    // Tanggal hari ini
    DateTime now = DateTime.now();

    // Loop 7 hari terakhir
    for (int i = 6; i >= 0; i--) {

      // Ambil tanggal dari 6 hari lalu sampai hari ini
      DateTime date = now.subtract(Duration(days: i));

      // Format tanggal jadi yyyy-MM-dd
      String dateStr = DateFormat('yyyy-MM-dd').format(date);
      
      // Hitung tugas selesai pada tanggal tersebut
      var result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM tasks WHERE completed_date = ? AND is_completed = 1',
        [dateStr]
      );

      // Masukkan hasil hitungan ke list
      counts.add(Sqflite.firstIntValue(result) ?? 0);
    }

    // Kembalikan data grafik
    return counts;
  }
}

