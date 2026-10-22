import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/media_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'koleksi_media.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE koleksi_media (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            judul TEXT NOT NULL,
            rating REAL NOT NULL,
            kategori TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // CREATE
  Future<int> insertMedia(MediaModel media) async {
    final db = await database;
    return await db.insert('koleksi_media', media.toMap());
  }

  // READ (Semua data)
  Future<List<MediaModel>> getAllMedia() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'koleksi_media',
      orderBy: 'id DESC',
    );
    return List.generate(maps.length, (i) => MediaModel.fromMap(maps[i]));
  }

  // UPDATE
  Future<int> updateMedia(MediaModel media) async {
    final db = await database;
    return await db.update(
      'koleksi_media',
      media.toMap(),
      where: 'id = ?',
      whereArgs: [media.id],
    );
  }

  // DELETE
  Future<int> deleteMedia(int id) async {
    final db = await database;
    return await db.delete('koleksi_media', where: 'id = ?', whereArgs: [id]);
  }

  // KHUSUS UNTUK IMPORT: Hapus semua data agar tidak duplikat saat import
  Future<void> clearAllMedia() async {
    final db = await database;
    await db.delete('koleksi_media');
  }
}
