import 'package:love_quest/core/resources/data_state.dart';
import 'package:love_quest/core/usecase/usecase.dart';
import 'package:love_quest/features/auth/domain/entities/user.dart';
import 'package:love_quest/features/auth/domain/repository/user_repository.dart';

class UpdateUserUseCase implements UseCase<DataState<UserEntity>, UpdateParams> {
  final UserRepository _userRepository;
  UpdateUserUseCase(this._userRepository);
  @override
  Future<DataState<UserEntity>> call(UpdateParams params) {
    return _userRepository.updateUser(params);
  }

}

class UpdateParams {
  String? job;
  String? country;
  String? address;
  String? email;
  String? gender;
  String? avatar;
  List<String>? interests;
  List<String>? profileImages;

  UpdateParams({this.avatar, this.profileImages, this.job, this.country, this.address, this.email, this.gender, this.interests});
  Map<String, dynamic> toJson() {
    return {
      if (job != null) 'job': job,
      if (country != null) 'country': country,
      if (address != null) 'address': address,
      if (email != null) 'email': email,
      if (gender != null) 'gender': gender,
      if (interests != null) 'interests': interests,
      if (profileImages != null) 'profileImages': profileImages,
      if (avatar != null) 'avatar': avatar
    };
  }
}