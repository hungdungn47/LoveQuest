import 'package:love_quest/features/auth/domain/entities/user.dart';

class ConversationEntity {
  String? roomId;
  UserEntity? sender;
  UserEntity? receiver;
  DateTime? latestCreatedAt;

  ConversationEntity({
    this.roomId,
    this.sender,
    this.receiver,
    this.latestCreatedAt
  });

  factory ConversationEntity.fromJson(Map<String, dynamic> json) {
    return ConversationEntity(
      sender: json['fromUser'] != null ? UserEntity.fromJson(json['fromUser']) : null,
      receiver: json['toUser'] != null ? UserEntity.fromJson(json['toUser']) : null,
      roomId: json['roomId'],
      latestCreatedAt: json['latestCreatedAt'] != null ? DateTime.parse(json['latestCreatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fromUser': sender?.toJson(),
      'toUser': receiver?.toJson(),
      'roomId': roomId,
      'latestCreatedAt': latestCreatedAt?.toIso8601String(),
    };
  }

  ConversationEntity copyWith({
    String? roomId,
    UserEntity? sender,
    UserEntity? receiver,
    DateTime? latestCreatedAt,
  }) {
    return ConversationEntity(
      roomId: roomId ?? this.roomId,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      latestCreatedAt: latestCreatedAt ?? this.latestCreatedAt,
    );
  }

}