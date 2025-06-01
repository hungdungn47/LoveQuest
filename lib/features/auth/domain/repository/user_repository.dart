import 'package:love_quest/core/resources/data_state.dart';
import 'package:love_quest/features/auth/data/models/response_user.dart';
import 'package:love_quest/features/auth/domain/entities/user.dart';
import 'package:love_quest/features/auth/domain/usecases/update_user.dart';

abstract interface class UserRepository {
  Future<DataState<Map<String, dynamic>>> loginUser(
      {required String email, required String password});
  Future<DataState<Map<String, dynamic>>> registerUser(
      {required String userName,
      required String email,
      required String password});
  Future<DataState<UserEntity>> getUserInfo();
  Future<DataState<Map<String, dynamic>>> verifyOtp({required String email, required String otp});
  Future<DataState<UserEntity>> updateUser(UpdateParams params);
  Future<DataState<Map<String, dynamic>>> addToken({required String newToken});
  Future<DataState<ResponseUser>> getOtherUser({required String userId});
}
