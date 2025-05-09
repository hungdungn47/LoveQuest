import 'package:love_quest/core/network/dio_client.dart';
import 'package:logger/logger.dart';

abstract class UserApiService {
  Future<Map<String, dynamic>> loginUser(
      {required String email, required String password});
  Future<Map<String, dynamic>> registerUser(
      {required String userName,
      required String email,
      required String password});
  Future<Map<String, dynamic>> getUserInfo();
}

class UserApiServiceImpl implements UserApiService {
  final DioClient _client;
  UserApiServiceImpl(this._client);
  final logger = Logger();
  @override
  Future<Map<String, dynamic>> getUserInfo() async {
    try {
      final response = await _client.get('/users/me');
      logger.i('Get user profile response status: ${response.statusCode}');
      logger.i('Get user profile response data: ${response.data}');
      return response.data;
    } catch (e) {
      logger.e('Get user profile error: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> loginUser(
      {required String email, required String password}) async {
    try {
      final response = await _client.post('/auth/sign-in', data: {
        'email': email,
        'password': password,
      });
      logger.i('Sign in response status: ${response.statusCode}');
      logger.i('Sign in response data: ${response.data}');
      return response.data;
    } catch (e) {
      logger.i('Signup error: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> registerUser(
      {required String userName,
      required String email,
      required String password}) async {
    logger.i('Making signup request with data:');
    logger.i('Username: $userName');
    logger.i('Email: $email');
    logger.i('Password: ${password.length} characters');

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
