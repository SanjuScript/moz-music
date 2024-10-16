import 'dart:ui';
import 'package:flutter/material.dart';
import '../../CONTROLLER/song_controllers.dart';

class SpeedDialog extends StatefulWidget {
  const SpeedDialog({super.key});

  @override
  State<SpeedDialog> createState() => _SpeedDialogState();
}

class _SpeedDialogState extends State<SpeedDialog> with TickerProviderStateMixin {
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
    double selectedSpeed = MozController.player.speed; // Reflect current speed

    return Dialog(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: _sigma, sigmaY: _sigma),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).dialogBackgroundColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDialogTitle(context),
                    const SizedBox(height: 20),
                    _buildSpeedSelector(context, "0.5x", 0.5, selectedSpeed == 0.5),
                    _buildDivider(),
                    _buildSpeedSelector(context, "0.8x", 0.8, selectedSpeed == 0.8),
                    _buildDivider(),
                    _buildSpeedSelector(context, "1.0x", 1.0, selectedSpeed == 1.0),
                    _buildDivider(),
                    _buildSpeedSelector(context, "1.5x", 1.5, selectedSpeed == 1.5),
                    _buildDivider(),
                    _buildSpeedSelector(context, "2.0x", 2.0, selectedSpeed == 2.0),
                    const SizedBox(height: 20),
                    _buildCloseButton(context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDialogTitle(BuildContext context) {
    return Text(
      "Speed Controls",
      style: TextStyle(
        fontFamily: 'coolvetica',
        color: Theme.of(context).disabledColor,
        fontSize: 18,
      ),
    );
  }

  Widget _buildSpeedSelector(BuildContext context, String speedLabel, double speedValue, bool isSelected) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          if (MozController.player.playing) {
            MozController.player.setSpeed(speedValue);
            Navigator.pop(context);
          }
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.transparent,
        ),
        child: Text(
          speedLabel,
          style: TextStyle(
            fontFamily: 'coolvetica',
            fontSize: 18,
            color: isSelected ? Colors.purple[300] : Theme.of(context).unselectedWidgetColor,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.white.withOpacity(0.3),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Close",
            style: TextStyle(
              fontFamily: 'coolvetica',
              fontSize: 16,
              color: Theme.of(context).disabledColor,
            ),
          ),
        ),
      ],
    );
  }
}

void showSpeedDialogue({required Color color,required BuildContext context,}) {
  showDialog(
    context: context,
    barrierColor:color,
    builder: (context) => SpeedDialog(),
  );
}
