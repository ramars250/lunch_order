import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunch_order/provider.dart';
import 'package:lunch_order/user_view.dart';

class AdminView extends StatelessWidget {
  const AdminView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('午餐吃什麼'),
        centerTitle: true,
      ),
      body: Center(
        child: Consumer(builder: (context, ref, _) {
          final storeAsyncValue = ref.watch(storeProvider);
          return storeAsyncValue.when(
              data: (store) => ListView.builder(
                    itemCount: store.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        ref
                            .read(selectedStoreProvider.notifier)
                            .selectedStore(index);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UserView()));
                      },
                      child: ListTile(
                        title: Text(store[index]['store_name'].toString()),
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
