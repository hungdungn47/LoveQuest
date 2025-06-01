import 'package:get/get.dart';
import 'package:love_quest/core/network/dio_client.dart';
import 'package:love_quest/features/auth/data/data_sources/remote/user_api_service.dart';
import 'package:love_quest/features/auth/data/repository/user_repository.dart';
import 'package:love_quest/features/auth/domain/repository/user_repository.dart';
import 'package:love_quest/features/auth/domain/usecases/login.dart';
import 'package:love_quest/features/auth/domain/usecases/update_user.dart';
import 'package:love_quest/features/auth/domain/usecases/verify_otp.dart';
import 'package:love_quest/features/auth/presentation/controllers/auth_controller.dart';
import 'package:love_quest/features/chat/data/datasources/chat_api_service.dart';
import 'package:love_quest/features/chat/data/repository/chat_repository_impl.dart';
import 'package:love_quest/features/chat/domain/repository/chat_repository.dart';
import 'package:love_quest/features/film_choosing/services/filmChoosingService.dart';
import 'package:love_quest/features/film_choosing/services/filmChoosingServiceIpm.dart';
import 'package:love_quest/features/schedule/domain/data/schedule_api_service.dart';

import 'core/ads/ads_service.dart';
import 'core/global/global.controller.dart';
import 'features/auth/domain/usecases/getOtherUser.dart';
import 'features/auth/domain/usecases/get_profile.dart';
import 'features/auth/domain/usecases/signup.dart';

Future<void> initializeDependencies() async {
  final dioClient = DioClient.instance;
  dioClient.configureDio(
    baseUrl: 'http://10.0.2.2:3000/api',
    defaultHeaders: {
      'Content-Type': 'application/json',
    },
  );
  Get.put<DioClient>(dioClient);
  Get.put<UserApiService>(UserApiServiceImpl(Get.find<DioClient>()));
  Get.put<ScheduleApiService>(ScheduleApiService(Get.find<DioClient>()));
  Get.put<UserRepository>(UserRepositoryImpl(Get.find<UserApiService>()));
  Get.put<LoginUseCase>(LoginUseCase(Get.find<UserRepository>()));
  Get.put<VerifyOtpUseCase>(VerifyOtpUseCase(Get.find<UserRepository>()));
  Get.put<SignupUseCase>(SignupUseCase(Get.find<UserRepository>()));
  Get.put<GetProfileUseCase>(GetProfileUseCase(Get.find<UserRepository>()));
  Get.put<UpdateUserUseCase>(UpdateUserUseCase(Get.find<UserRepository>()));
  Get.put<GetOtherUserUseCase>(GetOtherUserUseCase(Get.find<UserRepository>()));
  Get.put<IFilmChoosingService>(FilmChoosingServiceImp(Get.find<DioClient>()));
  Get.put<AdsService>(AdsService()).initAds();

  Get.put<ChatApiService>(ChatApiService(Get.find<DioClient>()));
  Get.put<ChatRepository>(ChatRepositoryImpl(Get.find<ChatApiService>()));

  Get.put(AuthController());
  Get.put<GlobalController>(GlobalController());
}
