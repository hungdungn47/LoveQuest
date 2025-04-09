import 'package:love_quest/core/resources/data_state.dart';
import 'package:love_quest/core/usecase/usecase.dart';
import 'package:love_quest/features/auth/domain/repository/user_repository.dart';

class SignupUseCase
    implements UseCase<DataState<Map<String, dynamic>>, SignupParams> {
  final UserRepository _userRepository;
  SignupUseCase(this._userRepository);
  @override
  Future<DataState<Map<String, dynamic>>> call(SignupParams params) {
    return _userRepository.registerUser(
        userName: params.userName,
        email: params.email,
        password: params.password);
  }
}

class SignupParams {
  final String userName;
  final String email;
  final String password;

  SignupParams(
      {required this.userName, required this.email, required this.password});
}
