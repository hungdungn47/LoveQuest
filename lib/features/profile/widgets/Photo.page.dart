import 'package:flutter/material.dart';
import 'package:love_quest/features/profile/widgets/photo.dart';

import '../../../core/config/theme.dart';

class PhotoPage extends StatelessWidget {
  const PhotoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Photos",
            style: Styles.bigTextW800,
          ),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                PhotoItem(imageUrl: ""),
                PhotoItem(imageUrl: ""),
                PhotoItem(imageUrl: ""),
                PhotoItem(imageUrl: ""),
                PhotoItem(imageUrl: ""),
                PhotoItem(imageUrl: ""),
              ],
            ),
          )
        ],
      ),
    );
  }
}
