import 'package:flutter/material.dart';

class SlidingImageWidget extends StatefulWidget {
  final Animation<Offset> offsetAnimation;
  final String url;

  const SlidingImageWidget({ 
    Key? key,
    required this.offsetAnimation,
    required this.url
  }) : super(key: key);

  @override
  State<SlidingImageWidget> createState() => _SlidingImageWidgetState();
}

class _SlidingImageWidgetState extends State<SlidingImageWidget> {
  late double _deviceHeight;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    return SlideTransition(
      key: UniqueKey(),
      position: widget.offsetAnimation,
      child: Center(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: _deviceHeight * 0.05),
            alignment: Alignment.center,
            child: Image.asset(widget.url)),
      ),
    );
  }
}