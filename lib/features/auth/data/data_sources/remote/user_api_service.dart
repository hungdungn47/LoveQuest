import 'package:love_quest/core/network/dio_client.dart';

abstract class UserApiService {
  Future<Map<String, dynamic>> loginUser(
      {required String email, required String password});
  Future<Map<String, dynamic>> registerUser(
      {required String email, required String password});
  Future<String> getUserInfo();
}

class UserApiServiceImpl implements UserApiService {
  final DioClient _client;
  UserApiServiceImpl(this._client);
  @override
  Future<String> getUserInfo() {
    // TODO: implement getUserInfo
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> loginUser(
      {required String email, required String password}) async {
    // TODO: implement loginUser
    return {"success": "true", "message": "Login successfully"};
  }

  @override
  Future<Map<String, dynamic>> registerUser(
      {required String email, required String password}) {
    // TODO: implement registerUser
    throw UnimplementedError();
  }
}
