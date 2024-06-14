import 'package:videocall/models/friend_ship.dart';
import 'package:videocall/models/user.dart';
import 'database_service.dart';

class FriendShipDB {
  Future<int?> create({required FriendShip friendShip}) async {
    final database = await DatabaseService().database;
    var result =
        await database.insert(FriendShip.tableName, friendShip.toMap());
    return result;
  }

  Future<bool> update({required FriendShip friendShip}) async {
    final database = await DatabaseService().database;
    var result = await database.update(
      FriendShip.tableName,
      friendShip.toMap(),
      where: "id = ?",
      whereArgs: [friendShip.id],
    );
    return result > 0;
  }

  // Future<List<FriendShip>> fetchAll() async {
  //   final database = await DatabaseService().database;
  //   final List<Map<String, dynamic>> friends =
  //       await database.rawQuery('SELECT * FROM ${FriendShip.tableName};');
  //   return friends.map((map) => FriendShip.fromMap(map)).toList();
  // }

  Future<FriendShip?> fetchById(int id) async {
    final database = await DatabaseService().database;
    final List<Map<String, dynamic>> friendList = await database.rawQuery(
      'SELECT * FROM ${FriendShip.tableName} WHERE id = ?;',
      [id],
    );
    if (friendList.isEmpty) {
      return null;
    } else {
      return FriendShip.fromMap(friendList.first);
    }
  }

  Future<int> delete(int id) async {
    final database = await DatabaseService().database;
    return await database.rawDelete(
      'DELETE FROM ${FriendShip.tableName} WHERE id = ?;',
      [id],
    );
  }

  Future<List<User>> fetchFriendsOfUser(int userId, String key) async {
    final database = await DatabaseService().database;
    final friends = await database.rawQuery(
      '''with ids as (SELECT CASE
        WHEN user1_id = ? THEN user2_id
        WHEN user2_id = ? THEN user1_id
        END AS id
        from friend_ship
        where user1_id = ? OR user2_id = ?)
        select u.id, name, phone, password, image, is_using from ids, user as u
        where u.id = ids.id AND u.name LIKE ?''',
      [userId, userId, userId, userId, '%$key%'],
    );
    return friends.map((map) => User.fromMap(map)).toList();
  }
}
