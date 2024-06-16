import 'package:videocall/helpers/enum_helper.dart';
import 'package:videocall/models/base_model.dart';

class User extends BaseModel {
  int? id;
  String name;
  String phone;
  String password;
  String? image;
  bool isUsing;
  UserTypeEnum userType = UserTypeEnum.FRIEND;

  User({
    this.id,
    required this.name,
    required this.phone,
    required this.password,
    required this.image,
    required this.isUsing,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      password: map['password'],
      image: map['image'],
      isUsing: map['is_using'] == 1,
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

  User copyWith({
    int? id,
    String? name,
    String? phone,
    String? password,
    String? image,
    bool? isUsing,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      image: image ?? this.image,
      isUsing: isUsing ?? this.isUsing,
    );
  }

  static String tableName = 'user';
}
