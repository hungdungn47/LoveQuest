import 'package:love_quest/core/resources/data_state.dart';
import 'package:love_quest/core/usecase/usecase.dart';
import 'package:love_quest/features/auth/domain/entities/user.dart';
import 'package:love_quest/features/auth/domain/repository/user_repository.dart';

class GetProfileUseCase implements UseCase<DataState<UserEntity>, NoParams> {
  final UserRepository _userRepository;
  GetProfileUseCase(this._userRepository);
  @override
  Future<DataState<UserEntity>> call(NoParams params) {
    return _userRepository.getUserInfo();
  }
}

class NoParams {}
