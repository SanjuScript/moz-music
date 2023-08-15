import 'package:flutter/material.dart';

class MozScrollBehaviour extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return StretchingOverscrollIndicator(axisDirection: flipAxisDirection(AxisDirection.right));
  }
}