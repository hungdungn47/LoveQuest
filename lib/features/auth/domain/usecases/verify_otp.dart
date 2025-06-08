import 'package:love_quest/core/resources/data_state.dart';
import 'package:love_quest/core/usecase/usecase.dart';
import 'package:love_quest/features/auth/domain/repository/user_repository.dart';

class VerifyOtpUseCase implements UseCase<DataState<Map<String, dynamic>>, VerifyOtpParams> {
  final UserRepository _userRepository;
  VerifyOtpUseCase(this._userRepository);
  @override
  Future<DataState<Map<String, dynamic>>> call(VerifyOtpParams params) {
    return _userRepository.verifyOtp(email: params.email, otp: params.otp);
  }

}

class VerifyOtpParams {
  final String email;
  final String otp;

  VerifyOtpParams({required this.email, required this.otp});
}