import 'package:flutter/material.dart';
import 'package:stories/widgets/opacity_change_widget.dart';

class SubtitleWidget extends StatefulWidget {
  final String subtitle;
  final Duration animationDuration;

  const SubtitleWidget({ 
    Key? key,
    required this.subtitle,
    required this.animationDuration
  }) : super(key: key);

  @override
  State<SubtitleWidget> createState() => _SubtitleWidgetState();
}

class _SubtitleWidgetState extends State<SubtitleWidget> {
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
        child:    Text(
          widget.subtitle,
          style: const TextStyle(fontSize: 18, height: 1.3, color: Colors.white),
        ),
        duration: widget.animationDuration,
      )
    );
  }
}