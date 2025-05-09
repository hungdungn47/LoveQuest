import 'package:love_quest/core/resources/data_state.dart';
import 'package:love_quest/core/storage/local_storage.dart';
import 'package:love_quest/features/auth/data/data_sources/remote/user_api_service.dart';
import 'package:love_quest/features/auth/domain/entities/user.dart';
import 'package:love_quest/features/auth/domain/repository/user_repository.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class UserRepositoryImpl implements UserRepository {
  final UserApiService _userApiService;
  final localStorage = LocalStorage();
  final logger = Logger();
  UserRepositoryImpl(this._userApiService);
  @override
  Future<DataState<UserEntity>> getUserInfo() async {
    try {
      Map<String, dynamic> result = await _userApiService.getUserInfo();
      final UserEntity user = UserEntity(
        email: result['email'] ?? '',
        nickName: result['userName'] ?? '',
        fullName: result['fullName'] ?? '',
        id: result['_id'] ?? '',
        avatar: result['avatar'] ?? '',
      );
      return DataSuccess(user);
    } catch (e) {
      logger.e('Get user profile error: $e');
      return DataFailed(Exception(e));
    }
  }

  @override
  Future<DataState<Map<String, dynamic>>> loginUser(
      {required String email, required String password}) async {
    // TODO: implement loginUser
    try {
      Map<String, dynamic> result =
          await _userApiService.loginUser(email: email, password: password);
      final accessToken = result['accessToken'];
      if (accessToken != null) {
        localStorage.saveData('accessToken', result['accessToken']);
      }

      return DataSuccess(result);
    } catch (e) {
      print('Repository: Login failed with error: $e');
      if (e is DioException) {
        return DataFailed(Exception(
            'Login failed: ${e.response?.data?['message'] ?? e.message}'));
      }
      return DataFailed(Exception(e));
    }
  }

  @override
  Future<DataState<Map<String, dynamic>>> registerUser(
      {required String userName,
      required String email,
      required String password}) async {
    try {
      print('Repository: Starting user registration');
      Map<String, dynamic> result = await _userApiService.registerUser(
          userName: userName, email: email, password: password);
      localStorage.saveData('accessToken', result['accessToken']);
      return DataSuccess(result);
    } catch (e) {
      print('Repository: Registration failed with error: $e');
      if (e is DioException) {
        return DataFailed(Exception(
            'Registration failed: ${e.response?.data?['message'] ?? e.message}'));
      }
      return DataFailed(Exception('Registration failed: $e'));
    }
  }
}
