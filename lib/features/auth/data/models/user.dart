import 'package:love_quest/features/auth/domain/entities/user.dart';

class UserModel extends UserEntity {
  const UserModel({
    String? id,
    String? fullName,
    String? nickName,
    String? email,
    String? job,
    String? gender,
    String? country,
    String? avatar,
    String? address,
    int? limitMatch,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? "",
      fullName: json['fullName'] ?? "",
      nickName: json['nickName'] ?? "",
      email: json['email'] ?? "",
      job: json['job'] ?? "",
      gender: json['gender'] ?? "",
      country: json['country'] ?? "",
      avatar: json['avatar'] ?? "",
      address: json['address'] ?? "",
      limitMatch: json['limitMatch'] ?? 10,
    );
  }
}
