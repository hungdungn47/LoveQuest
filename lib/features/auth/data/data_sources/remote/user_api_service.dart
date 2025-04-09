import 'package:love_quest/core/network/dio_client.dart';

abstract class UserApiService {
  Future<Map<String, dynamic>> loginUser(
      {required String email, required String password});
  Future<Map<String, dynamic>> registerUser(
      {required String userName,
      required String email,
      required String password});
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
      {required String userName,
      required String email,
      required String password}) async {
    print('Making signup request with data:');
    print('Username: $userName');
    print('Email: $email');
    print('Password: ${password.length} characters');

    try {
      final response = await _client.post('/auth/sign-up', data: {
        'userName': userName,
        'email': email,
        'password': password,
      });
      print('Signup response status: ${response.statusCode}');
      print('Signup response data: ${response.data}');
      return response.data;
    } catch (e) {
      print('Signup error: $e');
      rethrow;
    }
  }
}
