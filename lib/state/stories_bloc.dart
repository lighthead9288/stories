import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stories/models/story_data.dart';

class StoriesCubit extends Cubit<StoriesState> {
  final Future<void> Function() onPreviousImageScroll;
  final Future<void> Function() onNextImageScroll;
  final void Function() onCloseApp;

  StoriesCubit({
    required StoriesState initialState, 
    required this.onPreviousImageScroll, 
    required this.onNextImageScroll,
    required this.onCloseApp
  }) : super(initialState) {
    storyPercentNotifier = PercentNotifier(0, onNext: onNext);
    emit(StoriesLoadedState(currentStory: _stories[_curPageNumber], number: _curPageNumber, backgroundTween: _curBackgroundTween));
  }

  int get storiesCount => _stories.length;

  final List<StoryData> _stories = [
    StoryData(
        backgroundColor: 0xFF90CAF9,
        title: 'Screen 1 title',
        subtitle: 'Screen 1 subtitle',
        containsButtons: false),
    StoryData(
        backgroundColor: 0xFF000000,
        title: 'Screen 2 title',
        subtitle: 'Screen 2 subtitle',
        containsButtons: true),
    StoryData(
        backgroundColor: 0xFFFF9800,
        title: 'Screen 3 title',
        subtitle: 'Screen 3 subtitle',
        containsButtons: true),
    StoryData(
        backgroundColor: 0xFFF44336,
        title: 'Screen 4 title',
        subtitle: 'Screen 4 subtitle',
        containsButtons: true),
    StoryData(
        backgroundColor: 0xFF43A047,
        title: 'Screen 5 title',
        subtitle: 'Screen 5 subtitle',
        containsButtons: true)
  ];

  int _curPageNumber = 0;
  late ColorTween _curBackgroundTween = ColorTween(begin: Color(_stories.first.backgroundColor), end: Color(_stories.first.backgroundColor));
  late PercentNotifier storyPercentNotifier = PercentNotifier(0, onNext: onNext);

  void onPrevious() async {
    if (_curPageNumber != 0) {                        
      await onPreviousImageScroll();
      _curBackgroundTween = ColorTween(begin: Color(_stories[_curPageNumber].backgroundColor), end: Color(_stories[_curPageNumber - 1].backgroundColor));
      _curPageNumber--;
      emit(StoriesLoadedState(currentStory: _stories[_curPageNumber], number: _curPageNumber, backgroundTween: _curBackgroundTween));
    }
    storyPercentNotifier.timerRestart();
  }

  Future<void> onNext() async {
    if (_curPageNumber != _stories.length - 1) {                        
      await onNextImageScroll();
      _curBackgroundTween = ColorTween(begin: Color(_stories[_curPageNumber].backgroundColor), end: Color(_stories[_curPageNumber + 1].backgroundColor));
      _curPageNumber++;
      emit(StoriesLoadedState(currentStory: _stories[_curPageNumber], number: _curPageNumber, backgroundTween: _curBackgroundTween));
      storyPercentNotifier.timerRestart();                        
    } else {
      onCloseApp();
    }
  }

  void onStopped() {
    storyPercentNotifier.timerStop();
  }

  void onReleased() {
    storyPercentNotifier.timerStart();
  }

  double getStoryLoadingPercent(int pageNumber, double percent) {
    return (pageNumber < _curPageNumber)
      ? 1
      : (pageNumber > _curPageNumber)
          ? 0
          : percent;
  }

  @override
  Future<void> close() {
    storyPercentNotifier.dispose();
    return super.close();
  }
}

abstract class StoriesState {}

class StoriesLoadingState extends StoriesState {}

class StoriesLoadedState extends StoriesState {
  final StoryData currentStory;
  final int number;
  final ColorTween backgroundTween;

  StoriesLoadedState({required this.currentStory, required this.number, required this.backgroundTween});
}

class PercentNotifier extends ValueNotifier<double> {
  final Future<void> Function() onNext;
  
  PercentNotifier(double value, {required this.onNext}) : super(value) {
    timerStart();
  }

  static const _singleStorySeconds = 7;
  late Timer timer;

  void timerStop() {
    timer.cancel();
  }

  void timerRestart() {
    value = 0;
    timer.cancel();
    timerStart();
  }

  void timerStart() {
    timer = Timer.periodic(const Duration(milliseconds: _singleStorySeconds * 10), (t) async {
      if (value < 1) {
        value += 0.01;
      } else {
        timer.cancel();
        onNext();
      }
    });
  }
}