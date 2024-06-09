import 'package:videocall/database/user_db.dart';
import 'package:videocall/helpers/shared_preferences_helper.dart';
import 'package:videocall/models/user.dart';

import 'database_service.dart';

class AuthDB {
  final _userDB = UserDB();
  Future<bool> changePassword(String phone, String password) async {
    final db = await DatabaseService().database;
    var count = await db.rawUpdate(
        '''UPDATE user SET password = ? WHERE phone = ?;''', [password, phone]);
    return count == 1 ? true : false;
  }

  Future<bool> logIn(String phone, String password) async {
    var user = await _userDB.fetchByPhoneAndPassword(phone, password);
    if (user != null) {
      await SharedPreferencesHelper.saveInt('userId', user.id!);
      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    await SharedPreferencesHelper.remove('userId');
  }
}
