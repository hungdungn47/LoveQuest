class GameSchedule {
  final String id;
  final String userId;
  final String partnerId;
  final String partnerName;
  final String? partnerAvatar;
  final DateTime scheduledTime;
  final String gameType;
  final String status; // pending, accepted, rejected, completed, cancelled
  final DateTime createdAt;
  final DateTime? updatedAt;

  GameSchedule({
    required this.id,
    required this.userId,
    required this.partnerId,
    required this.partnerName,
    this.partnerAvatar,
    required this.scheduledTime,
    required this.gameType,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory GameSchedule.fromJson(Map<String, dynamic> json) {
    return GameSchedule(
      id: json['id'],
      userId: json['userId'],
      partnerId: json['partnerId'],
      partnerName: json['partnerName'],
      partnerAvatar: json['partnerAvatar'],
      scheduledTime: DateTime.parse(json['scheduledTime']),
      gameType: json['gameType'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'partnerId': partnerId,
      'partnerName': partnerName,
      'partnerAvatar': partnerAvatar,
      'scheduledTime': scheduledTime.toIso8601String(),
      'gameType': gameType,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
