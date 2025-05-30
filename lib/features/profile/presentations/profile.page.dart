import 'package:cached_network_image/cached_network_image.dart';
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBarCustomize(title: "LoveQuest"),
          Expanded(
              child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Avatar", style: Styles.bigTextW800),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(
                            () => CircleAvatar(
                                radius: 70, // Điều chỉnh kích thước avatar
                                backgroundColor: Colors.grey[200],
                                backgroundImage: CachedNetworkImageProvider(controller.avatar.value),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
