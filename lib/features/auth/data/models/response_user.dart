class ResponseUser {
  String userName;
  String avatar;

  ResponseUser(this.userName, this.avatar);

  factory ResponseUser.fromJson(Map<String, dynamic> json) {
    return ResponseUser(
      json['userName'] as String,
      json['avatar'] as String,
    );
  }
}
