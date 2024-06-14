import 'database_service.dart';
import '../models/user.dart';

class UserDB {
  // final tableName = 'user';

  Future<int?> create({required User user}) async {
    final database = await DatabaseService().database;
    var d = await database.insert(User.tableName, user.toMap());
    return d;
  }

  Future<bool> update({required User user}) async {
    final database = await DatabaseService().database;
    var d = await database.update(User.tableName, user.toMap(),
        where: "id = ?", whereArgs: [user.id]);
    return d > 0;
  }

  Future<List<User>> fetchAll({String? phoneNumber}) async {
    final database = await DatabaseService().database;
    final users = phoneNumber == null || phoneNumber.isEmpty
        ? await database.rawQuery('''SELECT * FROM user;''')
        : await database
            .rawQuery('''SELECT * FROM user WHERE phone = ?;''', [phoneNumber]);
    return users.map((user) => User.fromMap(user)).toList();
  }

  Future<User> fetchById(int id) async {
    final database = await DatabaseService().database;
    final user =
        await database.rawQuery('''SELECT * FROM user WHERE id = ?''', [id]);
    return User.fromMap(user.first);
  }

  Future<int> delete(int id) async {
    final db = await DatabaseService().database;
    return await db.rawDelete('''DELETE FROM user WHERE id = ? ''', [id]);
  }

  Future<User?> fetchByPhoneAndPassword(String phone, String password) async {
    final db = await DatabaseService().database;
    var user = await db.rawQuery(
        '''SELECT * FROM user WHERE phone = ? AND password = ?''',
        [phone, password]);
    if (user.isEmpty) {
      return Future(() => null);
    } else {
      return User.fromMap(user.first);
    }
  }

  Future<User?> fetchByPhone(String phone) async {
    final db = await DatabaseService().database;
    await db.execute('PRAGMA cache_size = 10000000'); // Set to 10MB
    var user =
        await db.rawQuery('''SELECT * FROM user WHERE phone = ?;''', [phone]);
    if (user.isEmpty) {
      return Future(() => null);
    } else {
      return User.fromMap(user.first);
    }
  }
}
