import 'package:flutter/material.dart';
import 'package:music_player/COLORS/colors.dart';
import 'package:music_player/PROVIDER/now_playing_provider.dart';
import 'package:music_player/PROVIDER/theme_class_provider.dart';
import 'package:provider/provider.dart';

Widget homeButton(BuildContext context, double wt) {
  return IconButton(
      splashRadius: 30,
      onPressed: () {
        Navigator.pop(context);
        context.read<NowPlayingProvider>().willPopHere();
      },
      icon: Icon(
        Icons.home_rounded,
        color: const Color(0xff333c67),
        size: wt * 0.07,
      ));
}

class HomePageButtons extends StatelessWidget {
  final Color color;
  final Widget child;
  const HomePageButtons(
      {super.key,
      this.color = const Color.fromARGB(255, 168, 73, 241),
      required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context,listen: false);
    return Padding(
      padding: const EdgeInsets.all(0.2),
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.28,
        margin: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 12),
        decoration: BoxDecoration(
            color: color.withOpacity(.9),
            border: Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(15),
            boxShadow: theme.gettheme() == CustomThemes.lightThemeMode ? [
              BoxShadow(
                  color: color.withOpacity(.9),
                  spreadRadius: 2,
                  offset: const Offset(2, -2)),
              BoxShadow(
                  color: color, blurRadius: 8, offset: const Offset(-2, 2))
            ] : []),
        child: child,
      ),
    );
  }
}
