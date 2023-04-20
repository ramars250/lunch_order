import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNotifier extends StateNotifier<List> {
  UserNotifier() : super([]);

  void addSelectedItems(item) {
    state = [...state, item];
  }

  void unSelectedItems(item) {
    state = state.where((element) => element != item).toList();
  }

  void removeItems(item) {
    state = List.of(state)..remove(item);
  }

  void toggleItemsSelected(item) {
    if (state.contains(item)) {
      unSelectedItems(item);
    } else {
      addSelectedItems(item);
    }
  }
}