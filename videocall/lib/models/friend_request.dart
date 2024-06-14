class FriendRequest {
  int? id;
  int fromUserId;
  int toUserId;
  String requestDate;
  int status;

  FriendRequest({
    this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.requestDate,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'from_user_id': fromUserId,
      'to_user_id': toUserId,
      'request_date': requestDate,
      'status': status,
    };
  }

  factory FriendRequest.fromMap(Map<String, dynamic> map) {
    return FriendRequest(
      id: map['id'],
      fromUserId: map['from_user_id'],
      toUserId: map['to_user_id'],
      requestDate: map['request_date'],
      status: map['status'],
    );
  }

  static String tableName = 'friend_request';
}
