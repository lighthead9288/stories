import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stories/models/story_data.dart';
import 'package:stories/repository/stories_repository.dart';
import 'package:stories/state/percent_notifier.dart';
import 'package:stories/state/states.dart';

class StoriesCubit extends Cubit<StoriesState> {
  final Future<void> Function() onPreviousImageScroll;
  final Future<void> Function() onNextImageScroll;
  final void Function(int prevColorCode, int nextColorCode) onSetCurBackgroundTween;
  final void Function() onCloseApp;

  int get storiesCount => _stories.length;

  // UI single items notifiers
  late PercentNotifier storyPercentNotifier = PercentNotifier(0, onNext: onNext);
  ValueNotifier<bool?> isLikedNotifier = ValueNotifier(null);

  late List<StoryData> _stories;
  int _curPageNumber = 0;
  final StoriesRepository _storiesRepository = StoriesRepository();

  StoriesCubit({
    required StoriesState initialState,
    required this.onPreviousImageScroll,
    required this.onNextImageScroll,
    required this.onSetCurBackgroundTween,
    required this.onCloseApp
  }) : super(initialState) {
    _fetchStories();
  }

  @override
  Future<void> close() {
    storyPercentNotifier.dispose();
    isLikedNotifier.dispose();
    return super.close();
  }

  Future<void> onPrevious() async {
    if (_curPageNumber != 0) {
      await onPreviousImageScroll();
      onSetCurBackgroundTween(
        _stories[_curPageNumber].backgroundColor,
        _stories[_curPageNumber - 1].backgroundColor
      );
      _curPageNumber--;
      emit(StoriesLoadedState(currentStory: _stories[_curPageNumber]));
    }
    storyPercentNotifier.timerRestart();
  }

  Future<void> onNext() async {
    if (_curPageNumber != _stories.length - 1) {
      await onNextImageScroll();
      onSetCurBackgroundTween(
        _stories[_curPageNumber].backgroundColor,
        _stories[_curPageNumber + 1].backgroundColor
      );
      _curPageNumber++;
      emit(StoriesLoadedState(currentStory: _stories[_curPageNumber]));
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

  void onLike() {
    _storiesRepository.addStoryMark(true, _curPageNumber);
    isLikedNotifier.value = true;
    onNext();
  }

  void onDislike() {
    _storiesRepository.addStoryMark(false, _curPageNumber);
    isLikedNotifier.value = false;
    onNext();
  }

  double getStoryLoadingPercent(int pageNumber, double percent) {
    return storyPercentNotifier.getStoryLoadingPercent(
      pageNumber, percent, _curPageNumber);
  }

  void getLikeValue() {
    isLikedNotifier.value = _storiesRepository.getLikeValue(_curPageNumber);
  }

  void _fetchStories() async {
    emit(StoriesLoadingState());
    _stories = await _storiesRepository.fetchStories();
    if (_stories.isEmpty) {
      emit(EmptyStoriesListState());
    } else {
      onSetCurBackgroundTween(
        _stories.first.backgroundColor, 
        _stories.first.backgroundColor
      );
      emit(StoriesLoadedState(currentStory: _stories[_curPageNumber]));
    }    
  }
}