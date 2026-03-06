import 'package:flutter/material.dart';
import 'dart:math' as math;

class ShakeWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double shakeOffset;
  final int shakeCount;
  final ShakeController? controller;

  const ShakeWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.shakeOffset = 10,
    this.shakeCount = 3,
    this.controller,
  });

  @override
  State<ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    // Creates a sine wave animation: from 0 -> 1 -> -1 -> 0 repeatedly
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: ShakeCurve(count: widget.shakeCount),
    ));

    if (widget.controller != null) {
      widget.controller!._state = this;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void shake() {
    if (_controller.isAnimating) {
      _controller.reset();
    }
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_animation.value * widget.shakeOffset, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class ShakeController {
  _ShakeWidgetState? _state;

  void shake() {
    _state?.shake();
  }
}

class ShakeCurve extends Curve {
  final int count;

  const ShakeCurve({this.count = 3});

  @override
  double transformInternal(double t) {
    return math.sin(t * math.pi * 2 * count);
  }
}
