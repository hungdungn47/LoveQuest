class ConversationEntity {
  String? roomId;
  String? senderId;
  String? receiverId;
  DateTime? latestCreatedAt;

  ConversationEntity({
    this.roomId,
    this.senderId,
    this.receiverId,
    this.latestCreatedAt
  });

  factory ConversationEntity.fromJson(Map<String, dynamic> json) {
    return ConversationEntity(
      senderId: json['fromUser'],
      receiverId: json['toUser'],
      roomId: json['roomId'],
      latestCreatedAt: json['latestCreatedAt'] != null ? DateTime.parse(json['latestCreatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fromUser': senderId,
      'toUser': receiverId,
      'roomId': roomId,
      'latestCreatedAt': latestCreatedAt?.toIso8601String(),
    };
  }

  ConversationEntity copyWith({
    String? roomId,
    String? senderId,
    String? receiverId,
    DateTime? latestCreatedAt,
  }) {
    return ConversationEntity(
      roomId: roomId ?? this.roomId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      latestCreatedAt: latestCreatedAt ?? this.latestCreatedAt,
    );
  }

}