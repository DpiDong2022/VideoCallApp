import 'package:sqflite/sqflite.dart';
import 'package:videocall/helpers/db_helper.dart';
import 'package:videocall/models/base_model.dart';

abstract class BaseController<T extends BaseModel> {
  late final DatabaseHelper _dbHelper;
  late final Database _database;

  BaseController() {
    _dbHelper = DatabaseHelper.instance;
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    _database = await _dbHelper.database;
  }

  Future<int> insert(T item) async {
    return await _database.insert(item.tableName, item.toMap());
  }

  Future<T?> get(int id, String tableName,
      T Function(Map<String, dynamic>) fromMap) async {
    final results =
        await _database.query(tableName, where: 'id = ?', whereArgs: [id]);
    return results.isNotEmpty ? fromMap(results.first) : null;
  }

  Future<int> update(T item) async {
    final id = (item as dynamic).id;
    return await _database
        .update(item.tableName, item.toMap(), where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(int id, String tableName) async {
    return await _database.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<T>> getList(
      T Function(Map<String, dynamic>) fromMap, String tableName) async {
    final results = await _database.query(tableName);
    return results.map<T>((row) => fromMap(row)).toList();
  }
}
