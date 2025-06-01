import 'package:love_quest/core/resources/data_state.dart';
import 'package:love_quest/core/usecase/usecase.dart';
import 'package:love_quest/features/auth/data/models/response_user.dart';
import 'package:love_quest/features/auth/domain/entities/user.dart';
import 'package:love_quest/features/auth/domain/repository/user_repository.dart';

class GetOtherUserUseCase implements UseCase<DataState<ResponseUser>, UserIdParams> {
  final UserRepository _userRepository;
  GetOtherUserUseCase(this._userRepository);
  @override
  Future<DataState<ResponseUser>> call(UserIdParams params) {
    return _userRepository.getOtherUser(userId: params.userId);
  }
}

class UserIdParams {
  String userId;
  UserIdParams(this.userId);
}
