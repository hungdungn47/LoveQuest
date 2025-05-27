class MessageEntity {
  String? id;
  String? senderId;     // maps from "fromUser"
  String? receiverId;   // maps from "toUser"
  String? message;
  String? roomId;
  DateTime? createdAt;
  DateTime? updatedAt;

  MessageEntity({
    this.id,
    this.senderId,
    this.receiverId,
    this.message,
    this.roomId,
    this.createdAt,
    this.updatedAt,
  });

  factory MessageEntity.fromJson(Map<String, dynamic> json) {
    return MessageEntity(
      id: json['_id'],
      senderId: json['fromUser'],
      receiverId: json['toUser'],
      message: json['message'],
      roomId: json['roomId'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fromUser': senderId,
      'toUser': receiverId,
      'message': message,
      'roomId': roomId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  MessageEntity copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? message,
    String? roomId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      roomId: roomId ?? this.roomId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

}
