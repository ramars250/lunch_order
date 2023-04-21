// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunch_order/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class UserView extends ConsumerWidget {
  const UserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuData = ref.watch(menuProvider);
    final itemData = ref.watch(selectedItemsProvider);
    final titleData = itemData.map((e) => e['item_title']);
    final priceData = itemData.map((e) => e['price']);
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        final prefs = snapshot.data!;
        final userName = prefs.getString('userName');
        return Scaffold(
          appBar: AppBar(
            title: const Text('點餐'),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 2 / 3,
                  width: MediaQuery.of(context).size.width,
                  child: menuData.when(
                      data: (menu) {
                        if (menu.isEmpty) {
                          return const Center(
                            child: Text(
                              '現在不開放點餐喔',
                              style: TextStyle(fontSize: 36),
                            ),
                          );
                        }
                        return GridView.builder(
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
                            final title = item['item_title'];
                            final price = item['price'];
                            final isSelected = itemData.contains(item);
                            String orderTime = menu[0];
                            return GestureDetector(
                              onTap: () {
                                final now = DateTime.parse('${DateTime.now()}-0800');
                                final format = DateFormat('HH:mm');
                                final nowString = format.format(now);
                                final diff = orderTime.compareTo(nowString);
                                print(nowString);
                                if (diff <= 0) {
                                  print('訂餐截止囉');
                                } else {
                                  ref
                                      .read(selectedItemsProvider.notifier)
                                      .toggleItemsSelected(item);
                                }

                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.only(left: 10, right: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      isSelected ? Colors.green : Colors.grey,
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
                                ),
                              ),
                            );
                          },
                        );
                      },
                      error: (error, _) => const Text('ERROR'),
                      loading: () => const CircularProgressIndicator()),
                ),
              ),
              const Divider(height: 5, color: Colors.blue),
              Text(
                titleData.isEmpty ? '尚未點餐' : '你的餐點是${titleData.join(",")}',
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                priceData.isEmpty
                    ? '總共0元'
                    : '總共${priceData.reduce((value, element) => value + element)}元',
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  print(userName);
                  logout();
                },
                child: const Text(
                  '送出',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}

// class UserView3 extends ConsumerWidget {
//   const UserView3({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final menuData = ref.watch(menuProvider);
//     final itemData = ref.watch(selectedItemsProvider);
//     final titleData = itemData.map((e) => e['item_title']);
//     final priceData = itemData.map((e) => e['price']);
//     return FutureBuilder(
//       future: SharedPreferences.getInstance(),
//       builder:
//           (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
//         if (!snapshot.hasData) {
//           return const CircularProgressIndicator();
//         }
//         final prefs = snapshot.data!;
//         final userName = prefs.getString('userName');
//         final selectedStoreId = prefs.getInt('selectedStore');
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('點餐'),
//             centerTitle: true,
//           ),
//           body: Column(
//             children: [
//               SizedBox(
//                 height: MediaQuery.of(context).size.height * 2 / 3,
//                 width: MediaQuery.of(context).size.width,
//                 child: selectedStoreId != -1
//                     ? menuData.when(
//                     data: (menu) => GridView.builder(
//                         shrinkWrap: true,
//                         gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           childAspectRatio: 5,
//                           mainAxisSpacing: 5,
//                           crossAxisSpacing: 5,
//                         ),
//                         itemCount: menu[1].length,
//                         itemBuilder: (context, index) {
//                           final item = menu[1][index];
//                           final title = menu[1][index]['item_title'];
//                           final price = menu[1][index]['price'];
//                           final isSelected = itemData.contains(item);
//                           return GestureDetector(
//                             onTap: () {
//                               ref
//                                   .read(selectedItemsProvider.notifier)
//                                   .toggleItemsSelected(item);
//                             },
//                             child: Container(
//                                 margin: const EdgeInsets.only(
//                                     left: 10, right: 10),
//                                 alignment: Alignment.center,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   color: isSelected
//                                       ? Colors.green
//                                       : Colors.grey,
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Padding(
//                                       padding:
//                                       const EdgeInsets.only(left: 5),
//                                       child: Text(
//                                         title,
//                                         style:
//                                         const TextStyle(fontSize: 16),
//                                       ),
//                                     ),
//                                     const Spacer(),
//                                     Padding(
//                                       padding:
//                                       const EdgeInsets.only(right: 5),
//                                       child: Text(
//                                         '$price元',
//                                         style:
//                                         const TextStyle(fontSize: 16),
//                                       ),
//                                     ),
//                                   ],
//                                 )),
//                           );
//                         }),
//                     error: (error, _) => const Text('ERROR'),
//                     loading: () => const CircularProgressIndicator())
//                     : const Center(
//                   child: Text(
//                     '現在不開放點餐喔',
//                     style: TextStyle(fontSize: 36),
//                   ),
//                 ),
//               ),
//               const Divider(height: 5, color: Colors.blue),
//               Text(
//                 titleData.isNotEmpty ? '你的餐點是${titleData.join(",")}' : '尚未點餐',
//                 style: const TextStyle(fontSize: 20),
//               ),
//               Text(
//                 priceData.isNotEmpty
//                     ? '總共${priceData.reduce((value, element) => value + element)}元'
//                     : '總共0元',
//                 style: const TextStyle(
//                     fontSize: 20,
//                     color: Colors.red,
//                     fontWeight: FontWeight.bold),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   logout();
//                   print(userName);
//                 },
//                 child: const Text(
//                   '送出',
//                   style: TextStyle(fontSize: 12),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   void logout() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.clear();
//   }
// }
