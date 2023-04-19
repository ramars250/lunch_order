// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunch_order/provider.dart';

class UserView extends ConsumerWidget {
  const UserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeData = ref.watch(storeProvider);
    final selectedStore = ref.watch(selectedStoreProvider);
    final itemData = ref.watch(selectedItemsProvider);
    final titleData = itemData.map((e) => e['item_title']);
    final priceData = itemData.map((e) => e['price']);
    // final totalPrice = ref.watch(priceProvider);
    // print(priceData);
    return Scaffold(
      appBar: AppBar(
        title: const Text('點餐'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 2 / 3,
            width: MediaQuery.of(context).size.width,
            child: selectedStore != -1
                ? storeData.when(
                    data: (store) => GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 5,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                        ),
                        itemCount: store[selectedStore]['menu'].length,
                        itemBuilder: (context, index) {
                          final item = store[selectedStore]['menu'][index];
                          final title =
                              store[selectedStore]['menu'][index]['item_title'];
                          final price =
                              store[selectedStore]['menu'][index]['price'];
                          return GestureDetector(
                            onTap: () {
                              ref
                                  .read(selectedItemsProvider.notifier)
                                  .addSelectedItems(item);
                              // print(itemData);
                            },
                            child: Container(
                                margin:
                                    const EdgeInsets.only(left: 10, right: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        title,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: Text(
                                        '$price元',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                )),
                          );
                        }),
                    error: (error, _) => const Text('ERROR'),
                    loading: () => const CircularProgressIndicator())
                : const Center(
                    child: Text(
                      '現在不開放點餐喔',
                      style: TextStyle(fontSize: 36),
                    ),
                  ),
          ),
          const Divider(height: 5, color: Colors.blue),
          const SizedBox(height: 10),
          Text(
            '你的餐點是${titleData.join(",")}',
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            '總共${priceData}元',
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
// ${titleData.toString().replaceAll("(", "").replaceAll(")", "")}
// ${priceData.reduce((value, element) => value + element)}
