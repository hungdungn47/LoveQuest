import 'package:flutter/material.dart';
import '../core/config/theme.dart';

class AppBarCustomize extends StatelessWidget {
  final String title;
  const AppBarCustomize({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 36, left: 16, right: 16, bottom: 8),
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        // minWidth: MediaQuery.of(context).size.width,
      ),
      decoration: BoxDecoration(
          color: AppColors.primary
      ),
      child: Text(title,
          style: Styles.bigTextW500.copyWith(color: Colors.white, fontSize: 28)),
    );
  }
}
