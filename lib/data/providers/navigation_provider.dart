import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provides the current index for the bottom navigation bar
final navigationProvider = NotifierProvider<NavigationNotifier, int>(NavigationNotifier.new);

class NavigationNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setTab(int index) {
    state = index;
  }
}
