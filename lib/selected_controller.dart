import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedNotifier extends StateNotifier<int> {
  SelectedNotifier() : super(-1);

  void selectedStore(int index) {
    state = index;
  }

  void resetStore() {
    state = -1;
  }

}