import 'package:flutter/material.dart';

Widget nextPrevoiusIcons(
    BuildContext context, void Function() inkWallOntapFunction, IconData icon) {
  return InkWell(
    overlayColor: MaterialStateProperty.all(Colors.transparent),
    onTap: inkWallOntapFunction,
    radius: 30,
    child: Icon(icon,
        size: MediaQuery.of(context).size.width * 0.07,
        color: const Color(0xff333c67)),
  );
}
