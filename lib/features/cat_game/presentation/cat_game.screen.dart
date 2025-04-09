import 'package:flutter/material.dart';
import 'package:love_quest/core/config/theme.dart';
import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

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
  bool _isGoodFood = true; // true for good food, false for bad food
  int _orangePoints = 0;
  int _blackPoints = 0;
  bool _isAnimating = false;
  Timer? _foodTimer;
  Timer? _hideTimer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _orangeController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _blackController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _orangeAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.6),
    ).animate(CurvedAnimation(
      parent: _orangeController,
      curve: Curves.linear,
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
        _isGoodFood = Random().nextBool(); // Randomly choose food type
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
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSound(bool isGoodFood) async {
    try {
      await _audioPlayer.play(
        AssetSource('sfx/${isGoodFood ? 'correct' : 'wrong'}.wav'),
      );
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  void _animateOrangeCat() {
    if (_isAnimating) return;
    _isAnimating = true;

    _orangeController.forward().then((_) {
      if (_isFoodVisible) {
        setState(() {
          _isFoodVisible = false;
          _orangePoints += _isGoodFood ? 1 : -2;
        });
        _playSound(_isGoodFood);
      }
      Future.delayed(const Duration(milliseconds: 50), () {
        _orangeController.reverse().then((_) {
          _isAnimating = false;
        });
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
          _blackPoints += _isGoodFood ? 1 : -2;
        });
        _playSound(_isGoodFood);
      }
      Future.delayed(const Duration(milliseconds: 50), () {
        _blackController.reverse().then((_) {
          _isAnimating = false;
        });
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
                top: foodCenterY - 80,
                left: screenWidth / 2 - 50,
                child: Image.asset(
                  _isGoodFood
                      ? 'assets/game-art/food.png'
                      : 'assets/game-art/fish-bone.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
            // Black cat paw centered
            Positioned(
              top: 50,
              left: screenWidth / 2 - 100,
              child: SlideTransition(
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
            ),
            // Black button positioned relative to black paw
            Positioned(
              top: 50 + 100, // 100 from top + half of paw height
              left: screenWidth / 2 -
                  100 -
                  100, // paw left position - button width
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _animateBlackCat,
                    borderRadius: BorderRadius.circular(40),
                    child: const Center(
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Orange cat paw centered
            Positioned(
              bottom: 50,
              left: screenWidth / 2 - 100,
              child: SlideTransition(
                position: _orangeAnimation,
                child: Image.asset(
                  'assets/game-art/orange-cat-paw.png',
                  width: 200,
                  height: 250,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            // Orange button positioned relative to orange paw
            Positioned(
              bottom: 50 + 100, // 150 from bottom + half of paw height
              left:
                  screenWidth / 2 - 100 + 200, // paw left position + paw width
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _animateOrangeCat,
                    borderRadius: BorderRadius.circular(40),
                    child: const Center(
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
