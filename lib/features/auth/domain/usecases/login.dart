import 'package:love_quest/core/resources/data_state.dart';
import 'package:love_quest/core/usecase/usecase.dart';
import 'package:love_quest/features/auth/domain/repository/user_repository.dart';

class LoginUseCase
    implements UseCase<DataState<Map<String, dynamic>>, LoginUserParams> {
  final UserRepository _userRepository;
  LoginUseCase(this._userRepository);
  @override
  Future<DataState<Map<String, dynamic>>> call(LoginUserParams params) {
    return _userRepository.loginUser(
        email: params.email, password: params.password);
  }
}

class LoginUserParams {
  final String email;
  final String password;

  LoginUserParams({required this.email, required this.password});
}
