class UserEntity {
  String? id;
  String? fullName;
  String? nickName;
  String? userName;
  String? email;
  String? job;
  String? gender;
  String? country;
  String? avatar;
  String? address;
  int? limitMatch;
  List<String>? profileImages;
  List<String>? interests;

  UserEntity({
    this.id,
    this.fullName,
    this.nickName,
    this.userName,
    this.email,
    this.job,
    this.gender,
    this.country,
    this.avatar,
    this.address,
    this.limitMatch,
    this.profileImages,
    this.interests
  });

  // fromJson factory constructor
  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['_id'] as String?,
      fullName: json['fullName'] as String?,
      nickName: json['nickName'] as String?,
      userName: json['userName'] as String?,
      email: json['email'] as String?,
      job: json['job'] as String?,
      gender: json['gender'] as String?,
      country: json['country'] as String?,
      avatar: json['avatar'] as String?,
      address: json['address'] as String?,
      profileImages: json['profileImages'] as List<String>?,
      interests: json['interests'] as List<String>?,
      limitMatch: json['limitMatch'] is int ? json['limitMatch'] : int.tryParse(json['limitMatch']?.toString() ?? ''),
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      if (fullName != null) 'fullName': fullName,
      if (nickName != null) 'nickName': nickName,
      if (userName != null) 'userName': userName,
      if (email != null) 'email': email,
      if (job != null) 'job': job,
      if (gender != null) 'gender': gender,
      if (country != null) 'country': country,
      if (avatar != null) 'avatar': avatar,
      if (address != null) 'address': address,
      if (interests != null) 'interests': interests,
      if (profileImages != null) 'profileImages': profileImages,
      if (limitMatch != null) 'limitMatch': limitMatch,
    };
  }
}
