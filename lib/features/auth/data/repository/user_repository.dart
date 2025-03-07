import 'package:love_quest/core/resources/data_state.dart';
import 'package:love_quest/features/auth/data/data_sources/remote/user_api_service.dart';
import 'package:love_quest/features/auth/domain/entities/user.dart';
import 'package:love_quest/features/auth/domain/repository/user_repository.dart';

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
      {required String email, required String password}) {
    // TODO: implement registerUser
    throw UnimplementedError();
  }
}
