import 'package:flutter/material.dart';

class OpacityChangeWidget extends StatelessWidget {
  final Widget child;
  final Duration duration;  

  const OpacityChangeWidget({ 
    Key? key, 
    required this.child, 
    required this.duration 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      key: UniqueKey(),
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      builder: (_, double opacity, __) {
        return Opacity(
          opacity: opacity,
          child: child,
        );
    });
  }
}