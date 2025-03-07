import 'package:get/get.dart';
import 'package:love_quest/core/network/dio_client.dart';
import 'package:love_quest/features/auth/data/data_sources/remote/user_api_service.dart';
import 'package:love_quest/features/auth/data/repository/user_repository.dart';
import 'package:love_quest/features/auth/domain/repository/user_repository.dart';
import 'package:love_quest/features/auth/domain/usecases/login.dart';

Future<void> initializeDependencies() async {
  Get.put<DioClient>(DioClient.instance);
  Get.put<UserApiService>(UserApiServiceImpl(Get.find<DioClient>()));
  Get.put<UserRepository>(UserRepositoryImpl(Get.find<UserApiService>()));
  Get.put<LoginUseCase>(LoginUseCase(Get.find<UserRepository>()));
}
