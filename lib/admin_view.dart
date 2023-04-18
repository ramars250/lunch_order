import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunch_order/provider.dart';

class AdminView extends StatelessWidget {
  const AdminView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('午餐吃什麼'),
      ),
      body: Center(
        child: Consumer(builder: (context, ref, _) {
          final menuAsyncValue = ref.watch(storeProvider);
          return menuAsyncValue.when(
              data: (menu) => GestureDetector(
                    onTap: () {},
                    child: ListView.builder(
                      itemCount: menu.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(menu[index]['store_name'].toString()),
                      ),
                    ),
                  ),
              error: (error, _) => const Text('ERROR'),
              loading: () => const CircularProgressIndicator());
        }),
      ),
    );
  }
}
