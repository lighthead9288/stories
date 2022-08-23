import 'package:flutter/material.dart';

class LikeButtonWidget extends StatefulWidget {
  final Icon icon;
  final void Function() onTap;

  const LikeButtonWidget({ 
    Key? key,
    required this.icon,
    required this.onTap
  }) : super(key: key);

  @override
  State<LikeButtonWidget> createState() => _LikeButtonWidgetState();
}

class _LikeButtonWidgetState extends State<LikeButtonWidget> {
  late double _deviceHeight;
  late double _deviceWidth;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: _deviceHeight * 0.06,
      width: _deviceWidth * 0.42,
      child: ElevatedButton(
          onPressed: () {
            widget.onTap();
          },
          child: widget.icon,
          style: ElevatedButton.styleFrom(
              primary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ))),
    );
  }
}