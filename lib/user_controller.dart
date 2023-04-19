import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNotifier extends StateNotifier<List> {
  UserNotifier() : super([]);

  void addSelectedItems(item) {
    state = [...state, item];
  }

  void removeItems(item) {
    state = List.of(state)..remove(item);
  }
}