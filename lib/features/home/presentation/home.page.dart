import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:love_quest/core/config/theme.dart';
import 'package:love_quest/features/home/presentation/home.controller.dart';
import 'package:love_quest/features/home/widgets/HomePage.dart';
import 'package:love_quest/features/schedule/presentation/schedule_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:love_quest/features/chat/presentation/chat_screen.dart';
import '../../profile/presentations/profile.page.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(32), topLeft: Radius.circular(32)),
        colorBehindNavBar: AppColors.background,
      ),
      controller: controller.persistentTabController,
      screens: _buildScreens(),
      items: _navBarsItems(),
      handleAndroidBackButtonPress: true,
      // Default is true.
      resizeToAvoidBottomInset: true,
      // This needs to be true if you want to move up the screen on a non-scrollable screen when keyboard appears. Default is true.
      stateManagement: true,
      // Default is true.
      hideNavigationBarWhenKeyboardAppears: true,
      // popBehaviorOnSelectedNavBarItemPress: PopActionScreensType.all,
      padding: const EdgeInsets.only(top: 8),
      backgroundColor: Colors.white,
      isVisible: true,
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          duration: Duration(milliseconds: 200),
          screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
        ),
      ),
      confineToSafeArea: true,
      navBarHeight: 64,
      navBarStyle: NavBarStyle.style1,
      // Choose the nav bar style with this property
    );
  }

  List<Widget> _buildScreens() {
    return [
      HomePageView(controller: controller),
      ScheduleScreen(),
      const ChatScreen(),
      ProfilePage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.home),
          title: ("Home"),
          activeColorPrimary: AppColors.primary,
          inactiveColorPrimary: CupertinoColors.systemGrey,
          textStyle: Styles.mediumTextW800),
      PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.calendar),
          title: ("Schedule"),
          activeColorPrimary: AppColors.primary,
          inactiveColorPrimary: CupertinoColors.systemGrey,
          textStyle: Styles.mediumTextW800),
      PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.chat_bubble_2),
          title: ("Messages"),
          activeColorPrimary: AppColors.primary,
          inactiveColorPrimary: CupertinoColors.systemGrey,
          textStyle: Styles.mediumTextW800),
      PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.profile_circled),
          title: ("Profile"),
          activeColorPrimary: AppColors.primary,
          inactiveColorPrimary: CupertinoColors.systemGrey,
          textStyle: Styles.mediumTextW800),
    ];
  }
}
