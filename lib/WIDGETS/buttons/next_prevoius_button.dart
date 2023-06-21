import 'package:flutter/material.dart';

Widget nextPrevoiusIcons(
    BuildContext context, void Function() inkWallOntapFunction, IconData icon) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.13,
    width: MediaQuery.of(context).size.width * 0.17,
    decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
          BoxShadow(
            color: Theme.of(context).dividerColor,
            blurRadius: 6,
            offset: const Offset(-2, -2),
          ),
        ]),
    child: InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: inkWallOntapFunction,
      child: Icon(icon,
          size: MediaQuery.of(context).size.width * 0.05,
          color: const Color(0xff9CADC0)),
    ),
  );
}