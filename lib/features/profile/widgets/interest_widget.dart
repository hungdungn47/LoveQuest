import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../presentations/profile.controller.dart';
import '../presentations/interests_selection.page.dart';
import '../../../core/config/theme.dart';

class InterestWidget extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  InterestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
            child: Text(
              "Interests",
              style: Styles.bigTextW800,
            )),
        InkWell(
          onTap: () => Get.to(() => SelectInterestPage()),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 28),
            decoration: BoxDecoration(color: Colors.white),
            child: Row(
              children: [
                Expanded(
                  child: Obx(() => Text(
                    controller.selectedInterests.join(", "),
                    style: Styles.mediumTextW500.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )),
                ),

                Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: Colors.black,
                  size: 16,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  String _getStringFromList(List<String> hobbies) {
    return hobbies.join(", ");
  }
}
