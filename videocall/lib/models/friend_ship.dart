class Friendship {
  int? id;
  int user1Id;
  int user2Id;

  Friendship({
    this.id,
    required this.user1Id,
    required this.user2Id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user1_id': user1Id,
      'user2_id': user2Id,
    };
  }

  factory Friendship.fromMap(Map<String, dynamic> map) {
    return Friendship(
      id: map['id'],
      user1Id: map['user1_id'],
      user2Id: map['user2_id'],
    );
  }

  static String tableName = 'friend_ship';
}
