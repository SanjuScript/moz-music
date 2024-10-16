import 'dart:developer';
import 'package:flutter/material.dart';

class MozSlider extends StatefulWidget {
  final Duration currentPosition;
  final Duration totalDuration;
  final ValueChanged<double> onChanged;
  final Color sliderColor;
  final Color thumbColor;
  final Color backgroundColor;

  const MozSlider({
    super.key,
    required this.currentPosition,
    required this.totalDuration,
    required this.onChanged,
    this.sliderColor = Colors.blue,
    this.thumbColor = Colors.white,
    this.backgroundColor = Colors.grey,
  });

  @override
  _MozSliderState createState() => _MozSliderState();
}

class _MozSliderState extends State<MozSlider>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _trackHeightAnimation;
  late double _sliderValue;
  late double _thumbRadius;

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.totalDuration.inMilliseconds > 0
        ? widget.currentPosition.inMilliseconds /
            widget.totalDuration.inMilliseconds
        : 0.0;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _trackHeightAnimation = Tween<double>(begin: 7.0, end: 11.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _thumbRadius = _trackHeightAnimation.value / 2; 
  }

  @override
  void didUpdateWidget(covariant MozSlider oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.currentPosition != oldWidget.currentPosition ||
        widget.totalDuration != oldWidget.totalDuration) {
      setState(() {
        _sliderValue = widget.totalDuration.inMilliseconds > 0
            ? widget.currentPosition.inMilliseconds /
                widget.totalDuration.inMilliseconds
            : 0.0;
        _thumbRadius = _trackHeightAnimation.value / 2; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Column(
      children: [
        AnimatedBuilder(
          animation: _trackHeightAnimation,
          builder: (context, child) {
            log(_trackHeightAnimation.value
                .toString()); 
            return Container(
              width: size.width,
              height: size.height * .038,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: widget.sliderColor,
                  inactiveTrackColor: widget.backgroundColor,
                  thumbColor: widget.thumbColor,
                  trackShape: const RoundedRectSliderTrackShape(),
                
                  trackHeight: _trackHeightAnimation.value,
                  overlayColor: widget.thumbColor.withOpacity(0.2),
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius:0 , 
                    
                  ),
                ),
                child: Slider(
                  value: _sliderValue.isNaN ||
                          _sliderValue < 0.0 ||
                          _sliderValue > 1.0
                      ? 0.0
                      : _sliderValue, 
                  min: 0.0,
                  max: 1.0,
                  onChanged: (value) {
                    setState(() {
                      _sliderValue = value;
                    });
                    widget.onChanged(value);
                  },
                  onChangeStart: (value) {
                    _startDrag();
                  },
                  onChangeEnd: (value) {
                    _stopDrag();
                  },
                ),
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(widget.currentPosition),
                style: TextStyle(
                    fontSize: size.width * 0.03,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xff97A4B7)),
              ),
              Text(
                _formatDuration(widget.totalDuration),
                style: TextStyle(
                    fontSize: size.width * 0.03,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xff97A4B7)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes);
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _startDrag() {
    _controller.forward(); // Start track height animation
  }

  void _stopDrag() {
    _controller.reverse(); // End track height animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

