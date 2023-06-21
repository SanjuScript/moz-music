import 'package:flutter/material.dart';

Widget iconConatiner(Widget child, BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.05,
    width: MediaQuery.of(context).size.width * 0.11,
    decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 7,
            offset: const Offset(2, 2),
          ),
          BoxShadow(
            color: Theme.of(context).dividerColor,
            blurRadius: 7,
            offset: const Offset(-2, -2),
          ),
        ]),
    child: child,
  );
}