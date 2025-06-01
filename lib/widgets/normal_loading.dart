import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:love_quest/core/config/theme.dart';

class NormalLoading extends StatelessWidget {
  const NormalLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: LoadingAnimationWidget.stretchedDots(
      color: AppColors.primary,
      size: 50,
    ));
  }
}
