import 'dart:async';
import 'package:flutter/material.dart';
import 'package:music_player/main.dart';
import 'package:music_player/SCREENS/bottom_navigation_bar.dart';
import '../ANIMATION/fade_animation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController scaleController;
  late Animation<double> scaleAnimation;
  double opacity = 0;
  bool value = true;
  @override
  void initState() {
    super.initState();
    scaleController = AnimationController(
      vsync: this,
      duration:  Duration(milliseconds: isViewed != 0 ? 600  : 300),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.of(context)
              .pushReplacement(ThisIsFadeRoute(route: const BottomNav()));
        }
      });
    Timer( Duration(milliseconds: isViewed != 0 ? 300 : 100), () {
      scaleController.reset();
    });
    scaleAnimation =
        Tween<double>(begin: 0.0, end: 12).animate(scaleController);
    Timer( Duration(milliseconds: isViewed != 0 ? 600 : 100), () {
      setState(() {
        opacity = 1.0;
        value = false;
      });
    });
    Timer( Duration(milliseconds: isViewed != 0 ? 2000 : 100), () {
      setState(() {
        scaleController.forward();
      });
    });
  }

  @override
  void dispose() {
    scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Text(
                isViewed != 0 ? 'Welcome To Moz Music' : 'Moz Music',
                style: TextStyle(
                    color: Theme.of(context).canvasColor,
                    fontFamily: 'optica',
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
            )
          ],
        ),
        Center(
          child: AnimatedOpacity(
            curve: Curves.fastLinearToSlowEaseIn,
            duration: const Duration(seconds: 6),
            opacity: opacity,
            child: AnimatedContainer(
              duration: const Duration(seconds: 2),
              curve: Curves.fastLinearToSlowEaseIn,
              height: value ? 50 : 200,
              width: value ? 50 : 200,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurpleAccent.withOpacity(.2),
                    blurRadius: 100,
                    
                    spreadRadius: 20,
                  )
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Stack(children: [
                  Container(
                    width: 180,
                    height: 180,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    child: AnimatedBuilder(
                      animation: scaleAnimation,
                      builder: (c, child) => Transform.scale(
                        scale: scaleAnimation.value,
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                    ),
                  ),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.asset('assets/logo.jpg'))
                ]),
              ),
            ),
          ),
        )
      ]),
    );
  }
}

