import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:love_quest/core/config/routes.dart';
import 'package:love_quest/core/config/theme.dart';
import 'package:love_quest/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  await initializeDependencies();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      getPages: AppRoutes.routes,
      initialRoute: AppRoutes.home,
    );
  }
}
