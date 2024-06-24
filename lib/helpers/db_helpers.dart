import 'package:pit/model/mUser.dart';
import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

class DbHelper {
  //membuat method singleton
  static final DbHelper _dbHelper = DbHelper._singleton();

  factory DbHelper() {
    return _dbHelper;
  }

  DbHelper._singleton();

  //baris terakhir singleton

  final tables = [
    UserQuery.CREATE_TABLE,
  ]; // membuat daftar table yang akan dibuat

  Future<Database> openDB() async {
    final dbPath = await sqlite.getDatabasesPath();
    return sqlite.openDatabase(path.join(dbPath, 'bengkelid.db'),
        onCreate: (db, version) async {
      tables.forEach((table) async {
        await db.execute(table).then((value) {}).catchError((err) {
          print("errornya ${err.toString()}");
        });
      });

      await getInitialData(db);

      print('Table Created');
    }, onUpgrade: (db, oldVersion, newVersion) async {
      var batch = db.batch();

      if (oldVersion == 1) {
        await db.execute("ALTER TABLE User ADD COLUMN area TEXT;");

        oldVersion++;
      }
      if (oldVersion == 2) {
        await db.execute("ALTER TABLE User ADD COLUMN kemampuan TEXT;");
        await db.execute("ALTER TABLE User ADD COLUMN status TEXT;");

        oldVersion++;
      }

      await batch.commit();
    }, version: 3);
  }

  Future<int> insert(String table, Map<String, Object> data) async {
    data['id'] = "";
    data.removeWhere((key, value) => key == "id");

    Database db = await openDB();
    int count = await db.insert(table, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return count;
  }

  Future<int> update(String table, Map<String, Object> data) async {
    Database db = await openDB();
    int count =
        await db.update(table, data, where: 'id=?', whereArgs: [data['id']]);
    return count;
  }

  Future<int> delete(String table, int id) async {
    Database db = await openDB();
    int count = await db.delete(table, where: 'id=?', whereArgs: [id]);
    return count;
  }

  Future<List> getData(
      {required String tableName,
      String? SortBy,
      String? strWhere,
      List<Object>? whereArgs,
      int? limit,
      int? offset}) async {
    final db = await openDB();

    var result = await db.query(tableName,
        orderBy: SortBy,
        where: strWhere,
        whereArgs: whereArgs,
        limit: limit,
        offset: offset);
    return result.toList();
  }

  Future<void> getInitialData(sqlite.Database db) async {
    await db.execute(
        "Insert Into User (name, email, phone, picture) values ('', '', '', '');");
  }
}
