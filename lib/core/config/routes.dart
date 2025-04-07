import 'package:get/get.dart';
import 'package:love_quest/features/auth/presentation/pages/home_screen.dart';
import 'package:love_quest/features/auth/presentation/pages/login_screen.dart';
import 'package:love_quest/features/auth/presentation/pages/onboarding_screens/gender_screen.dart';
import 'package:love_quest/features/auth/presentation/pages/onboarding_screens/interests_screen.dart';
import 'package:love_quest/features/auth/presentation/pages/onboarding_screens/name_screen.dart';
import 'package:love_quest/features/auth/presentation/pages/signup_screen.dart';
import 'package:love_quest/features/chat/presentation/chat_screen.dart';
import 'package:love_quest/features/home/presentation/home.binding.dart';
import 'package:love_quest/features/home/presentation/home.page.dart';
import 'package:love_quest/features/profile/presentations/profile.binding.dart';
import 'package:love_quest/features/profile/presentations/profile.page.dart';
import 'package:love_quest/features/quiz_game/presentation/lightning_quiz.binding.dart';
import 'package:love_quest/features/quiz_game/presentation/lightning_quiz.screen.dart';
import 'package:love_quest/features/chat/presentation/chat.binding.dart';
import 'package:love_quest/features/schedule/presentation/schedule_binding.dart';
import 'package:love_quest/features/schedule/presentation/schedule_screen.dart';

class AppRoutes {
  static const String signup = '/signup';
  static const String login = '/login';
  static const String name = '/name';
  // static const String birthday = '/birthday';
  static const String gender = '/gender';
  static const String interests = '/interests';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String quiz_game = '/quiz-game';
  static const String chat = '/chat';

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
        name: quiz_game,
        page: () => LightningQuizScreen(),
        binding: LightningQuizBinding()),
    GetPage(
      name: chat,
      page: () => ChatScreen(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: '/schedule',
      page: () => const ScheduleScreen(),
      binding: ScheduleBinding(),
    ),
  ];
}
