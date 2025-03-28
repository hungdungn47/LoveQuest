import 'package:flutter/material.dart';
import 'package:love_quest/core/config/theme.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isSelected;

  const CustomOutlinedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200, // Fixed width
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.primary : Colors.white,
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.primary,
            width: 2.4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
