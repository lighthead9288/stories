class StoryData {
  final int backgroundColor;
  final String fakeImgUrl;
  final String title;
  final String subtitle;
  final bool containsButtons;

  StoryData({
    required this.backgroundColor,
    required this.fakeImgUrl,
    required this.title,
    required this.subtitle,
    required this.containsButtons
  });

  factory StoryData.fromJson(Map<String, dynamic> data) {
    return StoryData(
      backgroundColor: int.parse(data["backgroundColor"]),
      fakeImgUrl: data["fakeImgUrl"],
      title: data["title"],
      subtitle: data["subtitle"],
      containsButtons: data["containsButtons"],
    );
  }
}