import 'package:flutter/material.dart';

class Nuemorphic extends StatelessWidget {
  final Widget child;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool shadowVisibility;
  final EdgeInsetsGeometry? margin;
  
  final bool shadowColorVisiblity;
  const Nuemorphic(
      {super.key,
      this.margin,
      required this.child,
      this.borderRadius,
      this.shadowColorVisiblity = false,
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
                    color: shadowColorVisiblity
                        ? Theme.of(context).shadowColor
                        : const Color.fromARGB(255, 6, 8, 10),
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
