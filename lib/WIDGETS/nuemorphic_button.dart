import 'package:flutter/material.dart';

class Nuemorphic extends StatelessWidget {
  final Widget child;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool shadowVisibility;
  final EdgeInsetsGeometry? margin;

  const Nuemorphic(
      {super.key,
      this.margin,
      required this.child,
      this.borderRadius,
      this.padding,
      this.shadowVisibility = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      height: 100,
      width: 100,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: borderRadius,
          boxShadow: shadowVisibility
              ? [
                  BoxShadow(
                    color: Theme.of(context).shadowColor,
                    blurRadius: 3,
                    offset: const Offset(2, 2),
                  ),
                  BoxShadow(
                    color: Theme.of(context).dividerColor,
                    blurRadius: 3,
                    offset: const Offset(-2, -2),
                  ),
                ]
              : []),
      child: child,
    );
  }
}
