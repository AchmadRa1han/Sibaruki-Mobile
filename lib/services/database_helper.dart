import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sibaruki_mobile/core/app_constants.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), AppConstants.dbName);
    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 1. Table Referensi (Dropdowns)
    await db.execute('''
      CREATE TABLE referensi (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        kategori TEXT,
        label TEXT,
        value TEXT
      )
    ''');

    // 2. Table RTLH Penerima
    await db.execute('''
      CREATE TABLE rtlh_penerima (
        nik TEXT PRIMARY KEY,
        nama_kepala_keluarga TEXT,
        tempat_lahir TEXT,
        tanggal_lahir TEXT,
        jenis_kelamin TEXT,
        alamat TEXT,
        desa_id INTEGER,
        kecamatan_id INTEGER,
        pendidikan_id INTEGER,
        pekerjaan_id INTEGER,
        is_pending INTEGER DEFAULT 0,
        updated_at TEXT
      )
    ''');

    // 3. Table RTLH Rumah & Kondisi (Simplified for now)
    await db.execute('''
      CREATE TABLE rtlh_survei (
        id_survei INTEGER PRIMARY KEY AUTOINCREMENT,
        nik_penerima TEXT,
        lat REAL,
        lng REAL,
        luas_bangunan REAL,
        jumlah_penghuni INTEGER,
        st_tanah TEXT,
        st_pondasi TEXT,
        st_tiang TEXT,
        st_dinding TEXT,
        st_atap TEXT,
        st_lantai TEXT,
        st_air_minum TEXT,
        st_drainase TEXT,
        st_limbah TEXT,
        st_sampah TEXT,
        is_pending INTEGER DEFAULT 0,
        updated_at TEXT,
        FOREIGN KEY (nik_penerima) REFERENCES rtlh_penerima (nik)
      )
    ''');

    // 4. Table Media (Photos)
    await db.execute('''
      CREATE TABLE media_sync (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        local_path TEXT,
        nik_penerima TEXT,
        tipe_foto TEXT, -- e.g., 'rumah_depan', 'kondisi_atap'
        is_uploaded INTEGER DEFAULT 0,
        created_at TEXT
      )
    ''');

    // 5. Table Logs
    await db.execute('''
      CREATE TABLE sys_logs_mobile (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        action TEXT,
        nik_terkait TEXT,
        timestamp TEXT,
        details TEXT
      )
    ''');
    
    // 6. Table Local Trash (Soft Delete)
    await db.execute('''
      CREATE TABLE local_trash (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tabel_asal TEXT,
        data_json TEXT,
        deleted_at TEXT
      )
    ''');
  }

  // Generic Methods
  Future<int> insert(String table, Map<String, dynamic> data) async {
    Database db = await database;
    return await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    Database db = await database;
    return await db.query(table);
  }

  Future<int> delete(String table, String where, List<dynamic> whereArgs) async {
    Database db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }
}
