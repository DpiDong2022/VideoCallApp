import 'database_service.dart';
import '../models/user.dart';

class UserDB {
  final tableName = 'user';

  Future<int> create({required User user}) async {
    final database = await DatabaseService().database;
    var d = await database.insert(tableName, user.toMap());
    return d;
  }

  Future<List<User>> fetchAll() async {
    final database = await DatabaseService().database;
    final users = await database.rawQuery('''SELECT * FROM $tableName;''');
    return users.map((user) => User.fromMap(user)).toList();
  }

  Future<User> fetchById(int id) async {
    final database = await DatabaseService().database;
    final user = await database
        .rawQuery('''SELECT * FROM $tableName WHERE id = ?''', [id]);
    return User.fromMap(user.first);
  }

  Future<int> delete(int id) async {
    final db = await DatabaseService().database;
    return await db.rawDelete('''DELETE FROM $tableName WHERE id = ? ''', [id]);
  }

  Future<User?> fetchByPhoneAndPassword(String phone, String password) async {
    final db = await DatabaseService().database;
    var user = await db.rawQuery(
        '''SELECT * FROM $tableName WHERE phone = ? AND password = ?''',
        [phone, password]);
    if (user.isEmpty) {
      return Future(() => null);
    } else {
      return User.fromMap(user.first);
    }
  }
}
