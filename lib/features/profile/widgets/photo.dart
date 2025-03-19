import 'package:flutter/material.dart';

import '../../../core/config/theme.dart';

class PhotoItem extends StatelessWidget {
  final String imageUrl;
  const PhotoItem({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(12),
          width: 100,
          height: 120,
          decoration: BoxDecoration(
              color: Color(0xFFD9D9D9),
              image: imageUrl.isNotEmpty ? DecorationImage(image: AssetImage(imageUrl), fit: BoxFit.contain) : null,
              border: Border.all(
                  color: Colors.black,
                  style: BorderStyle.solid,
                  width: 1
              ),
              borderRadius: BorderRadius.circular(18)
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24)
            ),
            child: Icon(Icons.add_sharp, color: Colors.white,),
          ),
        )
      ],
    );
  }
}
