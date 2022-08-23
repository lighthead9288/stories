import 'package:flutter/material.dart';
import 'package:stories/state/stories_cubit.dart';
import 'package:stories/widgets/like_button_widget.dart';
import 'package:stories/widgets/opacity_change_widget.dart';

class ButtonsPanelWidget extends StatefulWidget {
  final StoriesCubit state;
  final Duration animationDuration;

  const ButtonsPanelWidget({ 
    Key? key,
    required this.state,
    required this.animationDuration
  }) : super(key: key);

  @override
  State<ButtonsPanelWidget> createState() => _ButtonsPanelWidgetState();
}

class _ButtonsPanelWidgetState extends State<ButtonsPanelWidget> {
  late double _deviceHeight;
  late double _deviceWidth;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Padding(
        padding: EdgeInsets.only(
            top: _deviceHeight * 0.02, bottom: _deviceHeight * 0.05),
        child: OpacityChangeWidget(
          child: ValueListenableBuilder(
            valueListenable: widget.state.isLikedNotifier,
            builder: (_, bool? likeValue, __) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LikeButtonWidget(
                    icon: Icon(
                      Icons.thumb_down,
                      color: (likeValue == false) ? Colors.grey : Colors.black,
                    ), 
                    onTap: () {
                      widget.state.onDislike();
                    }
                  ),
                  SizedBox(
                    width: _deviceWidth * 0.05,
                  ),
                  LikeButtonWidget(
                    icon: Icon(
                      Icons.thumb_up,
                      color: (likeValue == true) ? Colors.green : Colors.black,
                    ), 
                    onTap: () {
                      widget.state.onLike();
                    }
                  )
                ],
              );
            }
          ),
          duration: widget.animationDuration,
        )
      );
  }
}