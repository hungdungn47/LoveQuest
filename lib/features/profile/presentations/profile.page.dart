import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:love_quest/features/profile/presentations/profile.controller.dart';
import 'package:love_quest/features/profile/widgets/info.dart';
import 'package:love_quest/widgets/Appbar.dart';

import '../widgets/Photo.page.dart';
import '../widgets/interest_widget.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBarCustomize(title: "LoveQuest"),
          Expanded(
              child: SingleChildScrollView(
              child: Column(
                children: [
                  PhotoPage(),
                  InterestWidget(hobbies: ["Books", "Gym", "Cycling"],),
                  InfoPage()
              ],
            ),
          ))
        ],
      ),
    );
  }
}
