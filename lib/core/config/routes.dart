import 'package:get/get.dart';
import 'package:love_quest/features/auth/presentation/pages/home_screen.dart';
import 'package:love_quest/features/auth/presentation/pages/login_screen.dart';
import 'package:love_quest/features/auth/presentation/pages/onboarding_screens/gender_screen.dart';
import 'package:love_quest/features/auth/presentation/pages/onboarding_screens/interests_screen.dart';
import 'package:love_quest/features/auth/presentation/pages/onboarding_screens/name_screen.dart';
import 'package:love_quest/features/auth/presentation/pages/signup_screen.dart';
import 'package:love_quest/features/draw_game/presentations/draw_game.binding.dart';
import 'package:love_quest/features/draw_game/presentations/draw_game.page.dart';
import 'package:love_quest/features/draw_game/presentations/test.page.dart';
import 'package:love_quest/features/film/film.bindings.dart';
import 'package:love_quest/features/film/film.page.dart';
import 'package:love_quest/features/film_choosing/film_choosing.bindings.dart';
import 'package:love_quest/features/film_choosing/film_choosing.page.dart';
import 'package:love_quest/features/home/presentation/home.binding.dart';
import 'package:love_quest/features/home/presentation/home.page.dart';
import 'package:love_quest/features/profile/presentations/profile.binding.dart';
import 'package:love_quest/features/profile/presentations/profile.page.dart';
import 'package:love_quest/features/video_call/call_binding.dart';
import 'package:love_quest/features/video_call/call_page.dart';

class AppRoutes {
  static const String signup = '/signup';
  static const String login = '/login';
  static const String name = '/name';
  // static const String birthday = '/birthday';
  static const String gender = '/gender';
  static const String interests = '/interests';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String draw_game = '/draw_game_test';
  static const String film = '/film';
  static const String filmChoosing = '/filmChoosing';
  static const String call_vid = '/call_vid';

  static final routes = [
    GetPage(name: signup, page: () => SignupScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: name, page: () => NameScreen()),
    // GetPage(name: birthday, page: () => BirthdayScreen()),
    GetPage(name: gender, page: () => GenderScreen()),
    GetPage(name: interests, page: () => InterestsScreen()),
    GetPage(
        name: home,
        page: () => HomePage(),
        binding: HomeBinding(),
    ),
    GetPage(
      name: profile,
      page: () => ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: draw_game,
      page: () => DrawGameView(),
      // page: () => Test(),
      binding: DrawGameBinding(),
    ),
    GetPage(
      name: film,
      page: () => FilmPage(),
      binding: FilmBindings(),
    ),
    GetPage(
      name: filmChoosing,
      page: () => FilmChoosingPage(),
      binding: FilmChoosingBindings(),
    ),
    GetPage(
      name: call_vid,
      page: () => CallPage(),
      binding: CallBinding(),
    ),
  ];
}