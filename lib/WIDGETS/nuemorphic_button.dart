import 'package:flutter/material.dart';

class Nuemorphic extends StatelessWidget {
  final Widget child;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool shadowVisibility;
  final EdgeInsetsGeometry? margin;
  final Color color;

  final bool shadowColorVisiblity;
  const Nuemorphic(
      {super.key,
      this.margin,
      required this.child,
      this.borderRadius,
      this.shadowColorVisiblity = false,
      this.color = const Color(0xffffffff),
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
          color: color,
          borderRadius: borderRadius,
          boxShadow: shadowVisibility
              ? [
                  BoxShadow(
                    color: shadowColorVisiblity
                        ? Theme.of(context).shadowColor
                        : Colors.transparent,
                    blurRadius: 3,
                    offset: const Offset(2, 2),
                  ),
                  BoxShadow(
                    color: Colors.transparent,
                    blurRadius: 3,
                    offset: const Offset(-2, -2),
                  ),
                ]
              : []),
      child: child,
    );
  }
}
