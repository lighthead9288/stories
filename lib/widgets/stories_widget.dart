import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stories/state/states.dart';
import 'package:stories/state/stories_cubit.dart';
import 'package:stories/widgets/buttons_panel_widget.dart';
import 'package:stories/widgets/empty_stories_list_widget.dart';
import 'package:stories/widgets/loading_widget.dart';
import 'package:stories/widgets/sliding_image_widget.dart';
import 'package:stories/widgets/stories_panel_widget.dart';
import 'package:stories/widgets/subtitle_widget.dart';
import 'package:stories/widgets/title_widget.dart';

class StoriesWidget extends StatefulWidget {
  const StoriesWidget({Key? key}) : super(key: key);

  @override
  State<StoriesWidget> createState() => _StoriesWidgetState();
}

class _StoriesWidgetState extends State<StoriesWidget>
    with TickerProviderStateMixin {
  late double _deviceHeight;
  late double _deviceWidth;

  final Duration _animationDuration = const Duration(milliseconds: 500);
  late final AnimationController _imageOffsetController = AnimationController(
    duration: _animationDuration,
    vsync: this,
  );
  late final Tween<Offset> _imageOffsetTween =
    Tween<Offset>(begin: Offset.zero, end: Offset.zero);
  late final Animation<Offset> _imageOffsetAnimation =
    _imageOffsetTween.animate(_imageOffsetController);
  late ColorTween _curBackgroundTween;
  late BuildContext _cubitContext;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: BlocProvider(
        create: (_) => StoriesCubit(
          initialState: StoriesLoadingState(),
          onPreviousImageScroll: () async => await _onPreviousImageScroll(),
          onNextImageScroll: () async => await _onNextImageScroll(),
          onSetCurBackgroundTween: (prev, next) =>
            _onSetCurBackgroundTween(prev, next),
          onCloseApp: _onCloseApp,
        ),
        child: BlocBuilder<StoriesCubit, StoriesState>(
          builder: (_context, state) {
            _cubitContext = _context;
            if (state is StoriesLoadingState) {
              return const LoadingWidget();
            } else if (state is StoriesLoadedState) {
              return _getLoadedUI(state);
            } else {
              return const EmptyStoriesListWidget();
            }
          }
        )
      )
    );
  }

  Widget _getLoadedUI(StoriesLoadedState state) {
    _cubitContext.read<StoriesCubit>().getLikeValue();
    _imageOffsetController.forward();
    return GestureDetector(
      onLongPressStart: (_) => _cubitContext.read<StoriesCubit>().onStopped(),
      onLongPressEnd: (_) => _cubitContext.read<StoriesCubit>().onReleased(),
      onTapUp: (details) async {
        if (details.localPosition.dx < _deviceWidth / 2) {
          await _cubitContext.read<StoriesCubit>().onPrevious();
        } else {
          await _cubitContext.read<StoriesCubit>().onNext();
        }
      },
      child: TweenAnimationBuilder(
        key: UniqueKey(),
        tween: _curBackgroundTween,
        duration: _animationDuration,
        builder: (_, Color? color, __) => Container(
          height: _deviceHeight,
          padding: EdgeInsets.symmetric(vertical: _deviceHeight * 0.01),
          color: color,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                child: Column(
                  children: [
                    StoriesPanelWidget(
                      state: _cubitContext.read<StoriesCubit>(),
                      onCloseApp: _onCloseApp
                    ),
                    SlidingImageWidget(
                      offsetAnimation: _imageOffsetAnimation,
                      url: state.currentStory.fakeImgUrl
                    ),
                  ],
                ),
                top: 0,
              ),
              Positioned(
                child: SizedBox(
                  width: _deviceWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleWidget(
                        title: state.currentStory.title,
                        animationDuration: _animationDuration
                      ),
                      SubtitleWidget(
                        subtitle: state.currentStory.subtitle,
                        animationDuration: _animationDuration
                      ),
                      (state.currentStory.containsButtons)
                        ? ButtonsPanelWidget(
                            state: _cubitContext.read<StoriesCubit>(),
                            animationDuration: _animationDuration
                          )
                        : const SizedBox(),
                    ],
                  ),
                ),
                bottom: (state.currentStory.containsButtons)
                  ? 0
                  : _deviceHeight * 0.08,
                left: 0,
              )
            ],
          )
        ),
      )
    );
  }

  @override
  void dispose() {
    _imageOffsetController.dispose();
    super.dispose();
  }

  Future<void> _onPreviousImageScroll() async {
    _changeAnimationControllerTarget(Offset.zero, const Offset(2.0, 0.0));
    await _imageOffsetController.forward();
    _changeAnimationControllerTarget(const Offset(-2.0, 0.0), Offset.zero);
  }

  Future<void> _onNextImageScroll() async {
    _changeAnimationControllerTarget(Offset.zero, const Offset(-2.0, 0.0));
    await _imageOffsetController.forward();
    _changeAnimationControllerTarget(const Offset(2.0, 0.0), Offset.zero);
  }

  void _onSetCurBackgroundTween(int prev, int next) {
    _curBackgroundTween = ColorTween(begin: Color(prev), end: Color(next));
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
}
