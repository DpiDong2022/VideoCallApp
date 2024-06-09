abstract class BaseModel<T> {
  Map<String, dynamic> toMap();
}

abstract class GenericThing {
  String get tableName;
  Map<String, dynamic> toMap();
}
