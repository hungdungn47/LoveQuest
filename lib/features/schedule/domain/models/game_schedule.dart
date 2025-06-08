import 'package:intl/intl.dart';

class GameSchedule {
  final String id;
  final List<String> users; // Danh sách userId
  final String status; // active, inactive, etc.
  final int level;
  final DateTime? scheduleAt;
  final DateTime createdAt;
  final DateTime? updatedAt;

  GameSchedule({
    required this.id,
    required this.users,
    required this.status,
    required this.level,
    this.scheduleAt,
    required this.createdAt,
    this.updatedAt,
  });

  factory GameSchedule.fromJson(Map<String, dynamic> json) {
    return GameSchedule(
      id: json['_id'],
      users: List<String>.from(json['users']),
      status: json['status'],
      level: json['level'],
      scheduleAt: json['scheduleAt'] != null
          ? DateTime.parse(json['scheduleAt']) // ✅ dùng đúng parser cho ISO 8601
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'users': users,
      'status': status,
      'level': level,
      // Nếu bạn muốn gửi về server với format hh:mm dd/MM/yyyy thì cần convert:
      'scheduleAt': scheduleAt != null
          ? DateFormat('HH:mm dd/MM/yyyy').format(scheduleAt!) // ✅ dùng custom format khi xuất
          : null,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
