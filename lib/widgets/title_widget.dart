import 'package:flutter/material.dart';
import 'package:stories/widgets/opacity_change_widget.dart';

class TitleWidget extends StatefulWidget {
  final String title;
  final Duration animationDuration;

  const TitleWidget({ 
    Key? key,
    required this.title,
    required this.animationDuration
  }) : super(key: key);

  @override
  State<TitleWidget> createState() => _TitleWidgetState();
}

class _TitleWidgetState extends State<TitleWidget> {
  late double _deviceHeight;
  late double _deviceWidth;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: _deviceHeight * 0.01, horizontal: _deviceWidth * 0.09),
      child: OpacityChangeWidget(
          child: Text(
            widget.title,
            style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                height: 1.3,
                color: Colors.white),
          ),
          duration: widget.animationDuration,
        )
    );
  }
}