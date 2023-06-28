import 'package:flutter/material.dart';
import '../ANIMATION/card_animation.dart';


class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: AnimCard(
          Color(0xffFF6594),
          '',
          '',
          '',
        ),
      ),
    );
  }
}


