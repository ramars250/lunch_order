// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunch_order/provider.dart';

class UserView extends ConsumerWidget {
  const UserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuData = ref.watch(menuProvider);
    final selectedStore = ref.watch(selectedStoreProvider);
    final itemData = ref.watch(selectedItemsProvider);
    final titleData = itemData.map((e) => e['item_title']);
    final priceData = itemData.map((e) => e['price']);
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
                ? menuData.when(
                    data: (menu) => GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 5,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                        ),
                        itemCount: menu[1].length,
                        itemBuilder: (context, index) {
                          final item = menu[1][index];
                          final title = menu[1][index]['item_title'];
                          final price = menu[1][index]['price'];
                          final isSelected = itemData.contains(item);
                          return GestureDetector(
                            onTap: () {
                              ref
                                  .read(selectedItemsProvider.notifier)
                                  .toggleItemsSelected(item);
                            },
                            child: Container(
                                margin:
                                    const EdgeInsets.only(left: 10, right: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: isSelected ? Colors.green : Colors.grey,
                                ),
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
          Text(
            titleData.isNotEmpty ? '你的餐點是${titleData.join(",")}' : '尚未點餐',
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            priceData.isNotEmpty
                ? '總共${priceData.reduce((value, element) => value + element)}元'
                : '總共0元',
            style: const TextStyle(
                fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () {

            },
            child: const Text(
              '送出',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// class UserView extends ConsumerWidget {
//   const UserView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final storeData = ref.watch(storeProvider);
//     final selectedStore = ref.watch(selectedStoreProvider);
//     final itemData = ref.watch(selectedItemsProvider);
//     final titleData = itemData.map((e) => e['item_title']);
//     final priceData = itemData.map((e) => e['price']);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('點餐'),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           SizedBox(
//             height: MediaQuery.of(context).size.height * 2 / 3,
//             width: MediaQuery.of(context).size.width,
//             child: selectedStore != -1
//                 ? storeData.when(
//                     data: (store) => GridView.builder(
//                         shrinkWrap: true,
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           childAspectRatio: 5,
//                           mainAxisSpacing: 5,
//                           crossAxisSpacing: 5,
//                         ),
//                         itemCount: store[selectedStore]['menu'].length,
//                         itemBuilder: (context, index) {
//                           final item = store[selectedStore]['menu'][index];
//                           final title =
//                               store[selectedStore]['menu'][index]['item_title'];
//                           final price =
//                               store[selectedStore]['menu'][index]['price'];
//                           final isSelected = itemData.contains(item);
//                           return GestureDetector(
//                             onTap: () {
//                               ref
//                                   .read(selectedItemsProvider.notifier)
//                                   .toggleItemsSelected(item);
//                               // print(itemData);
//                             },
//                             child: Container(
//                                 margin:
//                                     const EdgeInsets.only(left: 10, right: 10),
//                                 alignment: Alignment.center,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   color:
//                                       isSelected ? Colors.green : Colors.grey,
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 5),
//                                       child: Text(
//                                         title,
//                                         style: const TextStyle(fontSize: 16),
//                                       ),
//                                     ),
//                                     const Spacer(),
//                                     Padding(
//                                       padding: const EdgeInsets.only(right: 5),
//                                       child: Text(
//                                         '${price.toString()}元',
//                                         style: const TextStyle(fontSize: 16),
//                                       ),
//                                     ),
//                                   ],
//                                 )),
//                           );
//                         }),
//                     error: (error, _) => const Text('ERROR'),
//                     loading: () => const CircularProgressIndicator())
//                 : const Center(
//                     child: Text(
//                       '現在不開放點餐喔',
//                       style: TextStyle(fontSize: 36),
//                     ),
//                   ),
//           ),
//           const Divider(height: 5, color: Colors.blue),
//           // const SizedBox(height: 5),
//           Text(
//             titleData.isNotEmpty ? '你的餐點是${titleData.join(",")}' : '尚未點餐',
//             style: const TextStyle(fontSize: 20),
//           ),
//           Text(
//             priceData.isNotEmpty
//                 ? '總共${priceData.reduce((value, element) => value + element)}元'
//                 : '總共0元',
//             style: const TextStyle(
//                 fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
//           ),
//
//           ElevatedButton(
//             onPressed: () {
//               logout();
//             },
//             child: const Text(
//               '送出',
//               style: TextStyle(fontSize: 12),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void logout() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.clear();
//   }
// }
