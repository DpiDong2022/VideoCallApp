class CallHistory {
  int? id;
  int? callerId;
  int? calleeId;
  String? callStartDate;
  int? duration;
  int? callStatus;

  CallHistory({
    this.id,
    this.callerId,
    this.calleeId,
    this.callStartDate,
    this.duration,
    this.callStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'caller_id': callerId,
      'callee_id': calleeId,
      'call_start_date': callStartDate,
      'duration': duration,
      'call_status': callStatus,
    };
  }

  factory CallHistory.fromMap(Map<String, dynamic> map) {
    return CallHistory(
      id: map['id'],
      callerId: map['caller_id'],
      calleeId: map['callee_id'],
      callStartDate: map['call_start_date'],
      duration: map['duration'],
      callStatus: map['call_status'],
    );
  }

  static String tableName = 'call_history';
}
