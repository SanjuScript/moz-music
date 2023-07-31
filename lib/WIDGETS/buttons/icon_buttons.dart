import 'package:flutter/material.dart';

Widget iconConatiner(Widget child, BuildContext context,
    {bool onMore = false}) {
  return AnimatedContainer(
    duration: Duration(milliseconds: 500),
    height: MediaQuery.of(context).size.height * 0.05,
    width: onMore
        ? MediaQuery.of(context).size.width * 0.11
        : MediaQuery.of(context).size.width * 0.25,
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

Widget iconConatinerr(
  Widget child,
  BuildContext context,
) {
  return Flexible(
    child: AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: MediaQuery.of(context).size.height * 0.05,
      width: MediaQuery.of(context).size.width * 0.11,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor,
              blurRadius: 5,
              offset: const Offset(2, 2),
            ),
            BoxShadow(
              color: Theme.of(context).dividerColor,
              blurRadius: 5,
              offset: const Offset(-2, -2),
            ),
          ]),
      child: child,
    ),
  );
}
