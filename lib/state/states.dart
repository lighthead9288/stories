import 'package:stories/models/story_data.dart';

class StoriesLoadingState extends StoriesState {}

class EmptyStoriesListState extends StoriesState {}

class StoriesLoadedState extends StoriesState {
  final StoryData currentStory;

  StoriesLoadedState({required this.currentStory});
}

abstract class StoriesState {}