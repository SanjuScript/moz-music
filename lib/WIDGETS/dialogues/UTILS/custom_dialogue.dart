import 'dart:ui';

import 'package:flutter/material.dart';

class CustomBlurDialog {
  static void show({
    required BuildContext context,
    required String title,
    required String content,
    required List<Widget> actions,
  }) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return _CustomDialog(
          title: title,
          content: content,
          actions: actions,
        );
      },
    );
  }
}

class _CustomDialog extends StatefulWidget {
  final String title;
  final String content;
  final List<Widget> actions;

  const _CustomDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.actions,
  }) : super(key: key);

  @override
  State<_CustomDialog> createState() => __CustomDialogState();
}

class __CustomDialogState extends State<_CustomDialog>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 18).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _sigma => _animation.value;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: _sigma, sigmaY: _sigma),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).splashColor.withOpacity(0.70),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'optica',
                        color: Theme.of(context).cardColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.content,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).cardColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: widget.actions,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
