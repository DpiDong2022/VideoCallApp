import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

class User {
  String phoneNumber;
  String password;

  User({required this.phoneNumber, required this.password});

  Map<String, dynamic> toJson() => {
        'phoneNumber': phoneNumber,
        'password': password,
      };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      phoneNumber: json['phoneNumber'],
      password: json['password'],
    );
  }
}

class DataCenter {
  static final DataCenter _instance = DataCenter._internal();

  factory DataCenter() {
    return _instance;
  }

  DataCenter._internal();

  List<User> _users = [];

  Future<String> _getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<io.File> _getLocalFile() async {
    final path = await _getLocalPath();
    return io.File('$path/users.json');
  }

  Future<void> loadUsers() async {
    try {
      final file = await _getLocalFile();
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonUsers = jsonDecode(contents);
        _users = jsonUsers.map((json) => User.fromJson(json)).toList();
      }
    } catch (e) {
      print("Error loading users: $e");
    }
  }

  Future<void> saveUsers() async {
    final file = await _getLocalFile();
    final jsonUsers = _users.map((user) => user.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonUsers));
  }

  List<User> get users => _users;

  void addUser(User user) {
    _users.add(user);
    saveUsers();
  }

  User? authenticate(String phoneNumber, String password) {
    try {
      return _users.firstWhere(
        (user) => user.phoneNumber == phoneNumber && user.password == password,
      );
    } catch (e) {
      return null;
    }
  }
}
