import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:stories/models/story_data.dart';

class StoriesRepository {
  final Map<int, bool> _likesMap = <int, bool>{};

  Future<List<StoryData>> fetchStories() async {
    final String storiesString =
      await rootBundle.loadString('assets/json/stories.json');
    Map<String, dynamic> storiesData = jsonDecode(storiesString);
    if (storiesData.containsKey("stories")) {
      List list = storiesData["stories"];
      return list.map((item) => StoryData.fromJson(item)).toList();
    }
    return [];
  }

  void addStoryMark(bool mark, int number) {
    _likesMap[number] = mark;
  }

  bool? getLikeValue(int number) {
    if (_likesMap.containsKey(number)) {
      return _likesMap[number];
    } else {
      return null;
    }
  }
}
