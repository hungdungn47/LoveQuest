import 'package:flutter/material.dart';

import '../../../core/config/theme.dart';

class PageViewItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  const PageViewItem({super.key, required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: Styles.bigTextW700,
          ),
          SizedBox(
            height: 32,
          ),
          Image.asset(imageUrl)
        ],
      ),
    );
  }
}
