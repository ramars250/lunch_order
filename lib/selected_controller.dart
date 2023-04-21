import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectedNotifier extends StateNotifier<int> {
  SelectedNotifier() : super(-1);

  void selectedStore(int index) {
    state = index;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('selectedStore', index);
    });
  }

  void resetStore() {
    state = -1;
  }
}
