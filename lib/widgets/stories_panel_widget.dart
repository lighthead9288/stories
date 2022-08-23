import 'package:flutter/material.dart';
import 'package:stories/state/stories_cubit.dart';

class StoriesPanelWidget extends StatefulWidget {
  final StoriesCubit state;
  final void Function() onCloseApp;

  const StoriesPanelWidget(
      {Key? key, required this.state, required this.onCloseApp})
      : super(key: key);

  @override
  State<StoriesPanelWidget> createState() => _StoriesPanelWidgetState();
}

class _StoriesPanelWidgetState extends State<StoriesPanelWidget> {
  late double _deviceHeight;
  late double _deviceWidth;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Padding(
        padding: EdgeInsets.only(top: _deviceHeight * 0.04),
        child: ValueListenableBuilder(
            valueListenable: widget.state.storyPercentNotifier,
            builder: (_, double value, __) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _getStoriesLinesPanelItems(
                  widget.state.storiesCount, 
                  value
                ),
              );
            }));
  }

  List<Widget> _getStoriesLinesPanelItems(int storiesCount, double percent) {
    var storiesLinesPanelWidth = _deviceWidth * 0.95;
    var iconWidth = 30.0;
    var lineWidth = (storiesLinesPanelWidth - iconWidth) / storiesCount;

    List<Widget> lines = [];
    for (int i = 0; i < storiesCount; i++) {
      var progress = widget.state.getStoryLoadingPercent(i, percent);
      lines.add(Container(
        height: _deviceHeight * 0.005,
        width: lineWidth,
        margin: const EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[300]?.withOpacity(0.4)),
        alignment: Alignment.centerLeft,
        child: Container(
          height: _deviceHeight * 0.005,
          width: lineWidth * progress,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[300]?.withOpacity(1.0)),
        ),
      ));
    }
    lines.add(Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        child: GestureDetector(
            onTap: () => widget.onCloseApp(),
            child: Icon(
              Icons.close,
              color: Colors.grey[300],
              size: iconWidth,
            ))));
    return lines;
  }
}
