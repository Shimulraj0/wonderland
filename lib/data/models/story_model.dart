class StoryModel {
  final String id;
  final String title;
  final String theme; // e.g. Adventure, Fantasy
  final int durationMinutes; 
  final DateTime createdAt;

  StoryModel({
    required this.id,
    required this.title,
    required this.theme,
    required this.durationMinutes,
    required this.createdAt,
  });
}
