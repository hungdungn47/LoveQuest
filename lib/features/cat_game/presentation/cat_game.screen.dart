import 'package:flutter/material.dart';
import 'package:love_quest/core/config/theme.dart';
import 'dart:async';

class CatGameScreen extends StatefulWidget {
  const CatGameScreen({super.key});

  @override
  State<CatGameScreen> createState() => _CatGameScreenState();
}

class _CatGameScreenState extends State<CatGameScreen>
    with TickerProviderStateMixin {
  late AnimationController _orangeController;
  late AnimationController _blackController;
  late Animation<Offset> _orangeAnimation;
  late Animation<Offset> _blackAnimation;
  bool _isFoodVisible = false;
  int _orangePoints = 0;
  int _blackPoints = 0;
  bool _isAnimating = false;
  Timer? _foodTimer;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _orangeController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _blackController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _orangeAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.6),
    ).animate(CurvedAnimation(
      parent: _orangeController,
      curve: Curves.easeInExpo,
    ));

    _blackAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, 0.6),
    ).animate(CurvedAnimation(
      parent: _blackController,
      curve: Curves.linear,
    ));

    _startFoodCycle();
  }

  void _startFoodCycle() {
    _foodTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        _isFoodVisible = true;
      });

      _hideTimer = Timer(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _isFoodVisible = false;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _orangeController.dispose();
    _blackController.dispose();
    _foodTimer?.cancel();
    _hideTimer?.cancel();
    super.dispose();
  }

  void _animateOrangeCat() {
    if (_isAnimating) return;
    _isAnimating = true;

    _orangeController.forward().then((_) {
      if (_isFoodVisible) {
        setState(() {
          _isFoodVisible = false;
          _orangePoints++;
        });
      }
      _orangeController.reverse().then((_) {
        _isAnimating = false;
      });
    });
  }

  void _animateBlackCat() {
    if (_isAnimating) return;
    _isAnimating = true;

    _blackController.forward().then((_) {
      if (_isFoodVisible) {
        setState(() {
          _isFoodVisible = false;
          _blackPoints++;
        });
      }
      _blackController.reverse().then((_) {
        _isAnimating = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final foodCenterY = screenHeight / 2;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LoveQuest',
          style: TextStyle(
            fontSize: 28,
            fontFamily: 'Kaushan',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Text(
                  '🖤 $_blackPoints',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 16),
                Text(
                  '🧡 $_orangePoints',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/game-art/floor.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Food in the exact center
            if (_isFoodVisible)
              Positioned(
                top: foodCenterY - 100,
                left: screenWidth / 2 - 30,
                child: const Icon(
                  Icons.fastfood,
                  size: 60,
                  color: Colors.orange,
                ),
              ),
            // Black cat paw at the top with button on the left
            Positioned(
              top: 100,
              left: screenWidth / 2 - 150,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FloatingActionButton(
                    onPressed: _animateBlackCat,
                    backgroundColor: Colors.black,
                    child: const Icon(Icons.play_arrow, color: Colors.white),
                  ),
                  SlideTransition(
                    position: _blackAnimation,
                    child: Transform.rotate(
                      angle: 3.14,
                      child: Image.asset(
                        'assets/game-art/black-cat-paw.png',
                        width: 200,
                        height: 250,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Orange cat paw (animated) with button on the right
            Positioned(
              bottom: 150,
              left: screenWidth / 2 - 100,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SlideTransition(
                    position: _orangeAnimation,
                    child: Image.asset(
                      'assets/game-art/orange-cat-paw.png',
                      width: 200,
                      height: 250,
                      fit: BoxFit.fill,
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: _animateOrangeCat,
                    backgroundColor: Colors.orange,
                    child: const Icon(Icons.play_arrow, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
