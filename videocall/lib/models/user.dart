import 'package:videocall/models/base_model.dart';

class User extends BaseModel {
  final int? id;
  final String name;
  final String phone;
  final String password;
  final String image;
  final bool isUsing;

  User({
    this.id,
    required this.name,
    required this.phone,
    required this.password,
    required this.image,
    required this.isUsing,
  });

  // Convert a User object into a Map. The keys must correspond to the column names in the database.

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      password: map['password'],
      image: map['image'],
      isUsing: map['is_using'] == 1, // Convert int to bool
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'password': password,
      'image': image,
      'is_using': isUsing ? 1 : 0,
    };
  }

  static String tableName = 'user';
}
