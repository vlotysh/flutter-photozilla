import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    final dbName = path.basename(dbPath);
    return sql.openDatabase(dbName, onCreate: (db, version) {
      print('INIT DB');
      return db.execute('CREATE TABLE  user_places ('
          'id TEXT PRIMARY KEY, '
          'title TEXT,'
          'image TEXT, '
          'loc_lat REAL,'
          'loc_lng REAL, '
          'address TEXT'
          ')');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, dynamic> data) async {
    final sql.Database sqlDB = await DBHelper.database();

    await sqlDB.insert(table, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final sql.Database sqlDB = await DBHelper.database();
    return sqlDB.query(table, orderBy: 'id DESC');
  }

  static Future<int> delete(String table, String id) async {
    final sql.Database sqlDB = await DBHelper.database();
    return sqlDB.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
