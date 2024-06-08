abstract class BaseModel<T> {
  Map<String, dynamic> toMap();
  // T fromMap(Map<String, dynamic> map);
  String get tableName;
}

abstract class GenericThing {
  String get tableName;
}
