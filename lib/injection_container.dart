import 'package:get/get.dart';
import 'package:love_quest/core/network/dio_client.dart';
import 'package:love_quest/features/auth/data/data_sources/remote/user_api_service.dart';
import 'package:love_quest/features/auth/data/repository/user_repository.dart';
import 'package:love_quest/features/auth/domain/repository/user_repository.dart';
import 'package:love_quest/features/auth/domain/usecases/login.dart';
import 'package:love_quest/features/auth/domain/usecases/verify_otp.dart';
import 'package:love_quest/features/auth/presentation/controllers/auth_controller.dart';

import 'core/global/global.controller.dart';
import 'features/auth/domain/usecases/get_profile.dart';
import 'features/auth/domain/usecases/signup.dart';

Future<void> initializeDependencies() async {
  final dioClient = DioClient.instance;
  dioClient.configureDio(
    baseUrl: 'http://192.168.1.4:3000/api',
    defaultHeaders: {
      'Content-Type': 'application/json',
    },
  );
  Get.put<DioClient>(dioClient);
  Get.put<UserApiService>(UserApiServiceImpl(Get.find<DioClient>()));
  Get.put<UserRepository>(UserRepositoryImpl(Get.find<UserApiService>()));
  Get.put<LoginUseCase>(LoginUseCase(Get.find<UserRepository>()));
  Get.put<VerifyOtpUseCase>(VerifyOtpUseCase(Get.find<UserRepository>()));
  Get.put<SignupUseCase>(SignupUseCase(Get.find<UserRepository>()));
  Get.put<GetProfileUseCase>(GetProfileUseCase(Get.find<UserRepository>()));
  Get.put(AuthController());
  Get.put<GlobalController>(GlobalController());
}
