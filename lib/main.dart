import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:love_quest/core/config/routes.dart';
import 'package:love_quest/core/config/theme.dart';
import 'package:love_quest/core/firebase/firebase_messaging_service.dart';
import 'package:love_quest/features/auth/presentation/controllers/auth_controller.dart';
import 'package:love_quest/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessagingService().init();
  await GetStorage.init();
  final RequestConfiguration requestConfiguration = RequestConfiguration(
    testDeviceIds: ['5E9BA96C2AE1FD5E1CE9065088A3407E', 'EMULATOR'], // device ID thật của bạn
  );
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);
  await MobileAds.instance.initialize();
  await initializeDependencies();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  // This widget is the root of your application.
  final AuthController authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      getPages: AppRoutes.routes,
      initialRoute: AppRoutes.splash
    );
  }
}
