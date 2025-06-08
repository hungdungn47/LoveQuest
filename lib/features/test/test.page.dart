import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../../core/config/theme.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  height: 500,
                  width: 500,
                  child: Lottie.asset('assets/animations/loading.json')
              ),
              const SizedBox(height: 20),
              AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText(
                    "Waiting for loading film",
                    textStyle: Styles.mediumTextW700,
                    colors: [
                      Colors.blue,
                      Colors.red,
                      Colors.green,
                      Colors.purple,
                    ],
                  ),
                ],
                isRepeatingAnimation: true,
                repeatForever: true,
              ),
            ]),
      ),
    );
  }
}
