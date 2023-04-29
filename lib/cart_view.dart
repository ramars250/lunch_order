// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunch_order/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartView extends StatelessWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('你的餐點'),
        centerTitle: true,
      ),
      body: Consumer(builder: (context, ref, child) {
        final orderData = ref.watch(selectedItemsProvider);
        final orderPrice = ref.watch(priceProvider);
        print(orderData[0]);
        return Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: orderData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(orderData[index]['item_title']),
                );
              },
            ),
            Text('總金額為$orderPrice'),
            ElevatedButton(onPressed: logout, child: const Text('登出')),
          ],
        );
      }),
    );
  }
  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
