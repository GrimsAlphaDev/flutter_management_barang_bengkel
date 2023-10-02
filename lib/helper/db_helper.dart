import 'package:management_barang_bengkel/models/barang.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';

// ignore: camel_case_types
class DBHelper {
  static Database? _db;
  static const String id = 'id';
  static const String namaBarang = 'nama_barang';
  static const String jmlBarang = 'jml_barang';
  static const String hargaBarang = 'harga_barang';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';

  static const String dbName = 'managementBarang.db';

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + dbName;
    try {
      var db = await openDatabase(path, version: 1, onCreate: _onCreate);
      return db;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  _onCreate(Database db, int version) async {
    // await db.execute("DROP TABLE IF EXISTS barang");
    try {
      await db.execute(
          "CREATE TABLE barang (id STRING PRIMARY KEY, nama_barang TEXT, jml_barang INTEGER, harga_barang INTEGER, created_at TEXT, updated_at TEXT)");
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Barang> save(Barang barang) async {
    var dbClient = await db;

    // Convert DateTime objects to String before insertion
    String createdAtString = barang.createdAt.toString();
    String updatedAtString = barang.updatedAt.toString();

    //

    // Insert the data into the database
    barang.id = (await dbClient!.insert('barang', {
      'id': barang.id,
      'nama_barang': barang.namaBarang,
      'jml_barang': barang.jmlBarang,
      'harga_barang': barang.hargaBarang,
      'created_at': createdAtString, // Use the converted String value
      'updated_at': updatedAtString, // Use the converted String value
    }))
        .toString();

    return barang;
  }

  Future<List<Barang>> getBarang() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient?.query('barang',
            columns: [
              id,
              namaBarang,
              jmlBarang,
              hargaBarang,
              createdAt,
              updatedAt
            ],
            orderBy: '$id DESC') ??
        [];
    List<Barang> barangs = [];
    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        barangs.add(Barang.fromJson(maps[i]));
      }
    }
    return barangs;
  }

  Future<int> delete(String id) async {
    var dbClient = await db;
    return await dbClient!.delete(
      'barang',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(Barang barang) async {
    var dbClient = await db;

    // Convert DateTime objects to String before updating
    String updatedAtString = barang.updatedAt.toString();

    // Update the correct data
    List<Map<String, dynamic>> maps = await dbClient!.query('barang',
        columns: [id, namaBarang, jmlBarang, hargaBarang, updatedAt],
        where: 'id = ?',
        whereArgs: [barang.id]);
    if (maps.isNotEmpty) {
      return await dbClient.update(
        'barang',
        {
          'id': barang.id,
          'nama_barang': barang.namaBarang,
          'jml_barang': barang.jmlBarang,
          'harga_barang': barang.hargaBarang,
          'updated_at': updatedAtString, // Use the converted String value
        },
        where: 'id = ?',
        whereArgs: [barang.id],
      );
    }
    return 0;
  }

  Future<List<Barang>> searchBarang(String query) async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient!.query('barang',
        columns: [id, namaBarang, jmlBarang, hargaBarang, createdAt, updatedAt],
        where: 'nama_barang LIKE ?',
        whereArgs: ['%$query%'],
        orderBy: '$id DESC');
    List<Barang> barangs = [];
    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        barangs.add(Barang.fromJson(maps[i]));
      }
    }
    return barangs;
  }
}
