import 'package:love_quest/core/network/dio_client.dart';
import 'package:logger/logger.dart';
import 'package:love_quest/core/storage/local_storage.dart';

abstract class UserApiService {
  Future<Map<String, dynamic>> loginUser(
      {required String email, required String password});
  Future<Map<String, dynamic>> registerUser(
      {required String userName,
      required String email,
      required String password});
  Future<Map<String, dynamic>> getUserInfo();
  Future<Map<String, dynamic>> verifyOtp({required String email, required String otp});
  Future<Map<String, dynamic>> updateUser({required Map<String, dynamic> updateData});
}

class UserApiServiceImpl implements UserApiService {
  final DioClient _client;
  UserApiServiceImpl(this._client);
  final logger = Logger();
  @override
  Future<Map<String, dynamic>> getUserInfo() async {
    try {
      final accessToken = LocalStorage().readData('accessToken');
      logger.i('Access token in API service: ${accessToken}');
      final response = await _client.get('/users/me', headers: {'Authorization': 'Bearer ${accessToken}'});
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

  @override
  Future<Map<String, dynamic>> verifyOtp({required String email, required String otp}) async {
    try {
      final response = await _client.post('/auth/verify-otp', data: {
        'email': email,
        'otp': otp
      });
      return response.data;
    } catch (e) {
      logger.e('Verify OTP error: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> updateUser({required Map<String, dynamic> updateData}) async {
    try {
      final response = await _client.patch('/users/me', data: updateData);
      return response.data;
    } catch (e) {
      logger.e('Update user error: $e');
      rethrow;
    }
  }
}
