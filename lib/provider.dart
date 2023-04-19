// ignore_for_file: avoid_print

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunch_order/selected_controller.dart';
import 'package:lunch_order/user_controller.dart';

final storeProvider = FutureProvider<List<dynamic>>((ref) async {
  final storeRef = FirebaseDatabase.instance.ref('store');
  final storeName = await storeRef.child('').get();
  final snapshot = await storeRef.get();
  if (snapshot.exists) {
    final data = List.from(storeName.value as List);
    return data;
  } else {
    return [];
  }
});

//記錄選中店家的Provider
final selectedStoreProvider =
    StateNotifierProvider<SelectedNotifier, int>((ref) => SelectedNotifier());

//記錄選中餐點的Provider
final selectedItemsProvider =
    StateNotifierProvider<UserNotifier, List>((ref) => UserNotifier());

//訂單金額
final priceProvider = StateProvider<int>((ref) {
  final order = ref.watch(selectedItemsProvider);
  int totalPrice = 0;
  totalPrice = order.map((e) => e['price'] as int).fold<int>(0, (previousValue, item) => previousValue + item);
  return totalPrice;
//   final data =
//       order.map((e) => e['price']).reduce((value1, value2) => value1 + value2);
//
// //   final data = order.map((e) => e['price']).reduce((value, element) => value + element);
// //   // totalPrice = data;
//   print(data);
//   return totalPrice;
});
