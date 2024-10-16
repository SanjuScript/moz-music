import 'package:flutter/material.dart';

class AppInfoPage extends StatelessWidget {
  const AppInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:   Text(
                  'App Info',
                  style: TextStyle(
                    // fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'optica',
                    color:Theme.of(context).splashColor,
                  ),
                ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Moz Music',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'rounder',
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              const SizedBox(height: 20),
               FadeInText(
                text: 'Developed by: Sanjay',
                fontSize: 22,
                color:Theme.of(context).cardColor,
              ),
                FadeInText(
                text: 'Version 1.4.5',
                fontSize: 22,
                color: Colors.grey[800]!,
              ),
              const SizedBox(height: 40),
              const Text(
                'Features:',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily:'coolvetica',
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 10),
              const FeatureTile(icon: Icons.favorite, text: 'Favorites'),
              const FeatureTile(icon: Icons.playlist_play, text: 'Playlists'),
              const FeatureTile(icon: Icons.history, text: 'Recently Played'),
              const FeatureTile(icon: Icons.star, text: 'Mostly Played'),
              const FeatureTile(icon: Icons.search, text: 'Searching'),
              const FeatureTile(icon: Icons.settings, text: 'Variety of Settings'),
              const FeatureTile(icon: Icons.build, text: 'Advanced Settings Control'),
              const FeatureTile(icon: Icons.play_arrow, text: 'Background Play Support'),
              const FeatureTile(icon: Icons.color_lens, text: 'Themes'),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const FeatureTile({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        elevation: 8,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.deepPurple, size: 30),
          title: Text(text, style: const TextStyle(fontSize: 18,fontFamily: 'optica'),),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          onTap: () {
            // Handle tap if needed
          },
        ),
      ),
    );
  }
}

class FadeInText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;

  const FadeInText({
    Key? key,
    required this.text,
    required this.fontSize,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 500),
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize, color: color,fontFamily: 'coolvetica'),
      ),
    );
  }
}
