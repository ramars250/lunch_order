import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

final selectedStoreProvider = StateProvider<List>((ref) => []);
