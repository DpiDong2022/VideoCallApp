import 'database_service.dart';
import '../models/call_history.dart';

class CallHistoryDB {
  Future<int?> create({required CallHistory callHistory}) async {
    final database = await DatabaseService().database;
    var result =
        await database.insert(CallHistory.tableName, callHistory.toMap());
    return result;
  }

  Future<bool> update({required CallHistory callHistory}) async {
    final database = await DatabaseService().database;
    var result = await database.update(
      CallHistory.tableName,
      callHistory.toMap(),
      where: "id = ?",
      whereArgs: [callHistory.id],
    );
    return result > 0;
  }

  Future<List<CallHistory>> fetchAll() async {
    final database = await DatabaseService().database;
    final List<Map<String, dynamic>> calls =
        await database.rawQuery('SELECT * FROM ${CallHistory.tableName};');
    return calls.map((map) => CallHistory.fromMap(map)).toList();
  }

  Future<CallHistory?> fetchById(int id) async {
    final database = await DatabaseService().database;
    final List<Map<String, dynamic>> callList = await database.rawQuery(
      'SELECT * FROM ${CallHistory.tableName} WHERE id = ?;',
      [id],
    );
    if (callList.isEmpty) {
      return null;
    } else {
      return CallHistory.fromMap(callList.first);
    }
  }

  Future<int> delete(int id) async {
    final database = await DatabaseService().database;
    return await database.rawDelete(
      'DELETE FROM ${CallHistory.tableName} WHERE id = ?;',
      [id],
    );
  }

  Future<List<CallHistory>> fetchCallHistoryForUser(int userId) async {
    final database = await DatabaseService().database;
    final List<Map<String, dynamic>> calls = await database.rawQuery(
      'SELECT * FROM ${CallHistory.tableName} WHERE caller_id = ? OR callee_id = ?;',
      [userId, userId],
    );
    return calls.map((map) => CallHistory.fromMap(map)).toList();
  }
}
