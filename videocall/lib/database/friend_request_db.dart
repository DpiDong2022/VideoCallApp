import 'database_service.dart';
import '../models/friend_request.dart';

class FriendRequestDB {
  Future<int?> create({required FriendRequest friendRequest}) async {
    final database = await DatabaseService().database;
    var result =
        await database.insert(FriendRequest.tableName, friendRequest.toMap());
    return result;
  }

  Future<bool> update({required FriendRequest friendRequest}) async {
    final database = await DatabaseService().database;
    var result = await database.update(
      FriendRequest.tableName,
      friendRequest.toMap(),
      where: "id = ?",
      whereArgs: [friendRequest.id],
    );
    return result > 0;
  }

  Future<List<FriendRequest>> fetchAll() async {
    final database = await DatabaseService().database;
    final List<Map<String, dynamic>> requests =
        await database.rawQuery('SELECT * FROM ${FriendRequest.tableName};');
    return requests.map((map) => FriendRequest.fromMap(map)).toList();
  }

  Future<FriendRequest?> fetchById(int id) async {
    final database = await DatabaseService().database;
    final List<Map<String, dynamic>> requestList = await database.rawQuery(
      'SELECT * FROM ${FriendRequest.tableName} WHERE id = ?;',
      [id],
    );
    if (requestList.isEmpty) {
      return null;
    } else {
      return FriendRequest.fromMap(requestList.first);
    }
  }

  Future<int> delete(int id) async {
    final database = await DatabaseService().database;
    return await database.rawDelete(
      'DELETE FROM ${FriendRequest.tableName} WHERE id = ?;',
      [id],
    );
  }

  Future<List<FriendRequest>> fetchRequestsToUser(int userId) async {
    final database = await DatabaseService().database;
    final List<Map<String, dynamic>> requests = await database.rawQuery(
      'SELECT * FROM ${FriendRequest.tableName} WHERE to_user_id = ?;',
      [userId],
    );
    return requests.map((map) => FriendRequest.fromMap(map)).toList();
  }

  Future<List<FriendRequest>> fetchRequestsFromUser(int userId) async {
    final database = await DatabaseService().database;
    final List<Map<String, dynamic>> requests = await database.rawQuery(
      'SELECT * FROM ${FriendRequest.tableName} WHERE from_user_id = ?;',
      [userId],
    );
    return requests.map((map) => FriendRequest.fromMap(map)).toList();
  }
}
