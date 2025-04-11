import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:love_quest/core/config/theme.dart';

class Test extends StatelessWidget {
  final String title;
  const Test({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: IntrinsicHeight(
        child: Container(
          width: MediaQuery.of(context).size.width,
          // height: 160,
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.close_rounded,
                      size: 32,
                      color: Colors.white,
                    ))),
            Text(title,
                style: Styles.bigTextW800.copyWith(color: Colors.white)),
            SizedBox(
              height: 28,
            ),
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12)),
                child: Text(
                  "OK",
                  style: Styles.mediumTextW800.copyWith(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
          ]),
        ),
      ),
    );
  }
}
