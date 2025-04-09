import 'package:love_quest/core/resources/data_state.dart';
import 'package:love_quest/features/auth/data/data_sources/remote/user_api_service.dart';
import 'package:love_quest/features/auth/domain/entities/user.dart';
import 'package:love_quest/features/auth/domain/repository/user_repository.dart';
import 'package:dio/dio.dart';

class UserRepositoryImpl implements UserRepository {
  final UserApiService _userApiService;
  UserRepositoryImpl(this._userApiService);
  @override
  Future<DataState<UserEntity>> getUserInfo() {
    // TODO: implement getUserInfo
    throw UnimplementedError();
  }

  @override
  Future<DataState<Map<String, dynamic>>> loginUser(
      {required String email, required String password}) async {
    // TODO: implement loginUser
    try {
      Map<String, dynamic> result =
          await _userApiService.loginUser(email: email, password: password);
      return DataSuccess(result);
    } catch (e) {
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
      print('Repository: Registration successful');
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
