import 'package:get/get.dart';
import 'package:love_quest/features/auth/presentation/pages/home_screen.dart';
import 'package:love_quest/features/auth/presentation/pages/login_screen.dart';
import 'package:love_quest/features/auth/presentation/pages/onboarding_screens/gender_screen.dart';
import 'package:love_quest/features/auth/presentation/pages/onboarding_screens/interests_screen.dart';
import 'package:love_quest/features/auth/presentation/pages/onboarding_screens/name_screen.dart';
import 'package:love_quest/features/auth/presentation/pages/signup_screen.dart';
import 'package:love_quest/features/auth/presentation/pages/splash_screen.dart';
import 'package:love_quest/features/cat_game/presentation/cat_game.binding.dart';
import 'package:love_quest/features/cat_game/presentation/cat_game.screen.dart';
import 'package:love_quest/features/chat/presentation/chat_screen.dart';
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
import 'package:love_quest/features/quiz_game/presentation/lightning_quiz.binding.dart';
import 'package:love_quest/features/quiz_game/presentation/lightning_quiz.screen.dart';
import 'package:love_quest/features/chat/presentation/chat.binding.dart';
import 'package:love_quest/features/schedule/presentation/schedule_binding.dart';
import 'package:love_quest/features/schedule/presentation/schedule_screen.dart';
import 'package:love_quest/features/test/test.binding.dart';
import 'package:love_quest/features/video_call/call_binding.dart';
import 'package:love_quest/features/video_call/call_page.dart';

import '../../features/test/test.page.dart';

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
  static const String test = '/test';
  static const String quiz_game = '/quiz-game';
  static const String chat = '/chat';
  static const String cat_game = '/cat-game';
  static const String schedule = '/schedule';
  static const String splash = '/splash';

  static final routes = [
    GetPage(name: signup, page: () => SignupScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: splash, page: () => SplashScreen()),
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
        name: quiz_game,
        page: () => LightningQuizScreen(),
        binding: LightningQuizBinding()),
    GetPage(
      name: chat,
      page: () => ChatScreen(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: schedule,
      page: () => const ScheduleScreen(),
      binding: ScheduleBinding(),
    ),
    GetPage(
      name: cat_game,
      page: () => const CatGameScreen(),
      binding: CatGameBinding(),
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
    GetPage(
      name: test,
      page: () => TestPage(),
      binding: TestBindings(),
    ),
  ];
}