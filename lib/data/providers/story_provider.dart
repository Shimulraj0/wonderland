import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/story_model.dart';
import 'package:uuid/uuid.dart';

final storyProvider = NotifierProvider<StoryNotifier, List<StoryModel>>(StoryNotifier.new);

class StoryNotifier extends Notifier<List<StoryModel>> {
  @override
  List<StoryModel> build() => _initialStories;

  static final List<StoryModel> _initialStories = [
    StoryModel(
      id: '1',
      title: 'Emma & the Pirate Treasure',
      theme: 'Adventure',
      durationMinutes: 5,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    StoryModel(
      id: '2',
      title: 'Cats on a Space Adventure',
      theme: 'Space',
      durationMinutes: 4,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    StoryModel(
      id: '3',
      title: 'Dino Island Mystery',
      theme: 'Dinosaurs',
      durationMinutes: 3,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  Future<void> generateStory({
    required String theme,
    required int duration,
    required String childName,
  }) async {
    // Simulate generation delay
    await Future.delayed(const Duration(seconds: 3));

    final newStory = StoryModel(
      id: const Uuid().v4(),
      title: '$childName & the $theme Adventure',
      theme: theme,
      durationMinutes: duration,
      createdAt: DateTime.now(),
    );

    state = [newStory, ...state];
  }
}
