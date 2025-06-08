import 'package:flutter/material.dart';

class CustomProgressBar extends StatelessWidget {
  const CustomProgressBar({super.key, this.width, this.progress = 50});

  final progress;
  final width;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 16,
          width: width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                width: 1,
                color: Colors.blue,
              )),
        ),
        Container(
          height: 16,
          width: width * progress, // Adjust width dynamically
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ],
    );
  }
}
