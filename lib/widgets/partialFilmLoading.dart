import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PartialFilmLoading extends StatelessWidget {
  const PartialFilmLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          height: 500,
          width: 500,
          child: Lottie.asset('assets/animations/loading.json')),
    );
  }
}
