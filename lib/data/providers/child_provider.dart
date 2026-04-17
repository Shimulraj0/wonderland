import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/child_model.dart';
import 'package:uuid/uuid.dart';

final childProvider = NotifierProvider<ChildNotifier, List<ChildModel>>(ChildNotifier.new);

class ChildNotifier extends Notifier<List<ChildModel>> {
  @override
  List<ChildModel> build() => _initialChildren;

  static final List<ChildModel> _initialChildren = [
    ChildModel(
      id: '1',
      name: 'Emma',
      avatarPath: 'assets/images/profile_image.png',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    ChildModel(
      id: '2',
      name: 'Lucas',
      avatarPath: 'assets/images/profile_image.png',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  void addChild(String name, String avatarPath) {
    final newChild = ChildModel(
      id: const Uuid().v4(),
      name: name,
      avatarPath: avatarPath,
      createdAt: DateTime.now(),
    );
    state = [...state, newChild];
  }

  void removeChild(String id) {
    state = state.where((child) => child.id != id).toList();
  }
}
