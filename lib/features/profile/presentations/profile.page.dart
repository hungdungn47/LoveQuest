import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:love_quest/core/config/routes.dart';
import 'package:love_quest/core/storage/local_storage.dart';
import 'package:love_quest/features/profile/presentations/profile.controller.dart';
import 'package:love_quest/features/profile/widgets/info.dart';
import 'package:love_quest/widgets/Appbar.dart';

import '../../../core/config/theme.dart';
import '../widgets/Photo.page.dart';
import '../widgets/interest_widget.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustomize(appBarTitle: "LoveQuest"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: SingleChildScrollView(
              child: Column(
                children: [
                  PhotoPage(),
                  InterestWidget(),
                  InfoPage(),
                  Container(
                    width: double.infinity, // takes full width
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 28),
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        LocalStorage().removeData('accessToken');
                        Get.offAllNamed(AppRoutes.login);
                      },
                      child: Center(
                        child: Text(
                          "Log out",
                          style: Styles.mediumTextW500.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
            ),
          ))
        ],
      ),
    );
  }
}
