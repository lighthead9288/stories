import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stories/state/stories_bloc.dart';

class StoriesWidget extends StatefulWidget {
  const StoriesWidget({Key? key}) : super(key: key);

  @override
  State<StoriesWidget> createState() => _StoriesWidgetState();
}

class _StoriesWidgetState extends State<StoriesWidget>
    with TickerProviderStateMixin {
  late double _deviceHeight;
  late double _deviceWidth;

  late final AnimationController _imageOffsetController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late final Tween<Offset> _imageOffsetTween =
      Tween<Offset>(begin: Offset.zero, end: Offset.zero);
  late final Animation<Offset> _imageOffsetAnimation =
      _imageOffsetTween.animate(_imageOffsetController);
  late BuildContext _cubitContext;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: BlocProvider(
            create: (_) => StoriesCubit(
                initialState: StoriesLoadingState(),
                onPreviousImageScroll: () async {
                  _changeAnimationControllerTarget(
                      Offset.zero, const Offset(2.0, 0.0));
                  await _imageOffsetController.forward();
                  _changeAnimationControllerTarget(
                      const Offset(-2.0, 0.0), Offset.zero);
                },
                onNextImageScroll: () async {
                  _changeAnimationControllerTarget(
                      Offset.zero, const Offset(-2.0, 0.0));
                  await _imageOffsetController.forward();
                  _changeAnimationControllerTarget(
                      const Offset(2.0, 0.0), Offset.zero);
                },
                onCloseApp: _onCloseApp),
            child: BlocBuilder<StoriesCubit, StoriesState>(
                builder: (_context, state) {
              _cubitContext = _context;
              if (state is StoriesLoadingState) {
                return Container(
                    color: Colors.black,
                    child: const Center(child: CircularProgressIndicator()));
              } else if (state is StoriesLoadedState) {
                var storiesCount = _cubitContext.read<StoriesCubit>().storiesCount;
                _cubitContext.read<StoriesCubit>().getLikeValue();
                _imageOffsetController.forward();
                return GestureDetector(
                    onLongPressStart: (_) =>
                        _cubitContext.read<StoriesCubit>().onStopped(),
                    onLongPressEnd: (_) =>
                        _cubitContext.read<StoriesCubit>().onReleased(),
                    onTapUp: (details) async {
                      if (details.localPosition.dx < _deviceWidth / 2) {
                        var cubit = _cubitContext.read<StoriesCubit>();
                        cubit.onPrevious();
                      } else {
                        _cubitContext.read<StoriesCubit>().onNext();
                      }
                    },
                    child: TweenAnimationBuilder(
                      key: UniqueKey(),
                      tween: state.backgroundTween,
                      duration: const Duration(milliseconds: 500),
                      builder: (_, Color? color, __) => Container(
                        height: _deviceHeight,
                        padding: EdgeInsets.symmetric(
                            vertical: _deviceHeight * 0.01),
                        color: color,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                                padding:
                                    EdgeInsets.only(top: _deviceHeight * 0.05),
                                child: ValueListenableBuilder(
                                    valueListenable: _cubitContext
                                        .read<StoriesCubit>()
                                        .storyPercentNotifier,
                                    builder: (_, double value, __) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: _getStoriesLinesPanelItems(
                                            storiesCount, value),
                                      );
                                    })),
                            Padding(
                                padding:
                                    EdgeInsets.only(top: _deviceHeight * 0.05),
                                child: SizedBox(
                                    height: _deviceHeight * 0.5,
                                    width: _deviceWidth,
                                    child: SlideTransition(
                                      key: UniqueKey(),
                                      position: _imageOffsetAnimation,
                                      child: Center(
                                        child: Container(
                                            height: _deviceHeight * 0.5,
                                            width: _deviceWidth * 0.75,
                                            color: Colors.purple,
                                            alignment: Alignment.center,
                                            child: Text(
                                                'Image ${state.number + 1}',
                                                style: const TextStyle(
                                                    color: Colors.white))),
                                      ),
                                    ))),
                            Padding(
                                padding:
                                    EdgeInsets.only(top: _deviceHeight * 0.05),
                                child: _getOpacityChangeElement(Text(
                                  state.currentStory.title,
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ))),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: _deviceHeight * 0.02),
                              child: _getOpacityChangeElement(Text(
                                state.currentStory.subtitle,
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.white),
                              )),
                            ),
                            (state.currentStory.containsButtons)
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        top: _deviceHeight * 0.05),
                                    child: _getOpacityChangeElement(
                                      ValueListenableBuilder(
                                        valueListenable: _cubitContext.read<StoriesCubit>().isLiked, 
                                        builder: (_, bool? likeValue, __) {
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              _likeButton(
                                                  Icon(
                                                    Icons.thumb_down,  
                                                    color: (likeValue == false) 
                                                      ? Colors.grey
                                                      : Colors.black,
                                                  ), 
                                                  () { 
                                                    _cubitContext.read<StoriesCubit>().onDislike();
                                                  }),
                                              SizedBox(
                                                width: _deviceWidth * 0.05,
                                              ),
                                              _likeButton(
                                                Icon(
                                                  Icons.thumb_up,  
                                                  color: (likeValue == true)
                                                    ? Colors.green
                                                    : Colors.black,
                                                ), () {
                                                _cubitContext.read<StoriesCubit>().onLike();
                                              }),
                                            ],
                                          );
                                        }
                                      )
                                    )
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ));
              } else {
                return const SizedBox();
              }
            })));
  }

  Widget _likeButton(Icon icon, void Function() onTap) {
    return SizedBox(
      height: _deviceHeight * 0.05,
      width: _deviceWidth * 0.35,
      child: ElevatedButton(
          onPressed: () {
            onTap();
          },
          child: icon,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            foregroundColor: MaterialStateProperty.all(Colors.black),
          )),
    );
  }

  Widget _getOpacityChangeElement(Widget child) {
    return TweenAnimationBuilder(
        key: UniqueKey(),
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 500),
        builder: (_, double opacity, __) {
          return Opacity(
            opacity: opacity,
            child: child,
          );
        });
  }

  List<Widget> _getStoriesLinesPanelItems(int storiesCount, double percent) {
    var storiesLinesPanelWidth = _deviceWidth * 0.95;
    var iconWidth = 30.0;
    var lineWidth = (storiesLinesPanelWidth - iconWidth) / storiesCount;

    List<Widget> lines = [];
    for (int i = 0; i < storiesCount; i++) {
      var progress =
          _cubitContext.read<StoriesCubit>().getStoryLoadingPercent(i, percent);
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
            onTap: () => _onCloseApp(),
            child: Icon(
              Icons.close,
              color: Colors.grey[300],
              size: iconWidth,
            ))));
    return lines;
  }

  void _changeAnimationControllerTarget(Offset begin, Offset end) {
    _changeOffset(begin, end);
    _imageOffsetController.reset();
  }

  void _changeOffset(Offset begin, Offset end) {
    _imageOffsetTween.begin = begin;
    _imageOffsetTween.end = end;
  }

  void _onCloseApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }

  @override
  void dispose() {
    _imageOffsetController.dispose();
    super.dispose();
  }
}
