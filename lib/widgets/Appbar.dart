import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/config/routes.dart';
import '../core/config/theme.dart';

class AppBarCustomize extends StatelessWidget implements PreferredSizeWidget {
  final String appBarTitle;
  const AppBarCustomize({super.key, required this.appBarTitle});

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   padding: EdgeInsets.only(top: 36, left: 16, right: 16, bottom: 8),
    //   constraints: BoxConstraints(
    //     minWidth: MediaQuery.of(context).size.width,
    //     // minWidth: MediaQuery.of(context).size.width,
    //   ),
    //   decoration: BoxDecoration(
    //       color: AppColors.primary
    //   ),
    //   child: Text(title,
    //       style: Styles.bigTextW500.copyWith(color: Colors.white, fontSize: 28)),
    // );
    return AppBar(
      leading: IconButton(
        icon: const Icon(CupertinoIcons.back, color: Colors.white),
        onPressed: () => Get.offAllNamed(AppRoutes.home),
      ),
      title: Text(
        appBarTitle,
        style: TextStyle(
          fontSize: 28,
          fontFamily: 'Kaushan',
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: AppColors.primary,
      elevation: 0,
      actions: [
        IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.schedule_offer);
            },
            icon: Icon(Icons.schedule, color: Colors.white,))
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // required
}
