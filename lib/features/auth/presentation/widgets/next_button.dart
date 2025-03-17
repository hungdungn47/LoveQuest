import 'package:flutter/material.dart';
import 'package:love_quest/core/config/theme.dart';

class NextButton extends StatelessWidget {
  final VoidCallback onPressed;

  const NextButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary.withOpacity(0.2),
        ),
        child: Icon(
          Icons.arrow_forward,
          color: AppColors.primary,
        ),
      ),
    );
  }
}