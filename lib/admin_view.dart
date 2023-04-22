// ignore_for_file: avoid_print
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunch_order/provider.dart';
import 'package:lunch_order/user_view.dart';

class AdminView extends ConsumerWidget {
  AdminView({Key? key}) : super(key: key);

  final List<String> timeList = [
    '09:00',
    '09:15',
    '09:30',
    '09:45',
    '10:00',
    '10:15',
    '10:30',
    '10:45',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeData = ref.watch(storeProvider);
    final storeSelected = ref.watch(selectedStoreProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('午餐吃什麼'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 2 / 3,
              width: MediaQuery.of(context).size.width,
              child: storeData.when(
                  data: (store) => GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 3,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                      ),
                      itemCount: store.length,
                      itemBuilder: (context, index) {
                        final isSelected = storeSelected == index;
                        return GestureDetector(
                          onTap: () {
                            ref
                                .read(selectedStoreProvider.notifier)
                                .selectedStore(index);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: isSelected ? Colors.green : Colors.grey,
                            ),
                            child: Text(store[index]['store_name'].toString()),
                          ),
                        );
                      }),
                  error: (error, _) => const Text('ERROR'),
                  loading: () => const CircularProgressIndicator()),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Text(
                    '結束訂餐時間',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: DropdownButton(
                    value: ref.watch(endTimeProvider),
                    items: timeList
                        .map<DropdownMenuItem>(
                            (time) => DropdownMenuItem<String>(
                                value: time,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    time,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                )))
                        .toList(),
                    onChanged: (value) =>
                        ref.read(endTimeProvider.notifier).state = value,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton(
              onPressed: () {
                DatabaseReference dataRef =
                    FirebaseDatabase.instance.ref('order');
                String now = DateTime.now().year.toString() +
                    DateTime.now().month.toString() +
                    DateTime.now().day.toString();
                dataRef.update({
                  now: Map<String, dynamic>.from(
                    {
                      'endTime': ref.watch(endTimeProvider),
                      'selectedStore': storeSelected,
                      'menu': storeData.when(
                          data: (store) => store[storeSelected]['menu'],
                          error: (error, _) => const Text('ERROR'),
                          loading: () => const CircularProgressIndicator()),
                    },
                  ),
                });
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const UserView()));
              },
              child: const Text('確定'),
            ),
          ),
        ],
      ),
    );
  }
}
//
// class AdminView2 extends StatelessWidget {
//   const AdminView2({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('午餐吃什麼'),
//         centerTitle: true,
//       ),
//       body: Column(children: [
//         SizedBox(
//           height: MediaQuery.of(context).size.height * 2 / 3,
//           width: MediaQuery.of(context).size.width,
//           child: Consumer(builder: (context, ref, _) {
//             final storeAsyncValue = ref.watch(storeProvider);
//             return storeAsyncValue.when(
//                 data: (store) => ListView.builder(
//                       itemCount: store.length,
//                       itemBuilder: (context, index) => GestureDetector(
//                         onTap: () {
//                           ref
//                               .read(selectedStoreProvider.notifier)
//                               .selectedStore(index);
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => const UserView()));
//                         },
//                         child: ListTile(
//                           title: Text(store[index]['store_name'].toString()),
//                         ),
//                       ),
//                     ),
//                 error: (error, _) => const Text('ERROR'),
//                 loading: () => const CircularProgressIndicator());
//           }),
//         ),
//         ElevatedButton(
//             onPressed: () {
//               DatabaseReference ref = FirebaseDatabase.instance.ref('order');
//               String now = DateTime.now().month.toString() +
//                   DateTime.now().day.toString();
//               String dateNow = DateTime.now().toString();
//               String dateHour = DateTime.parse('$dateNow-0800').hour.toString();
//               String dateMinute =
//                   DateTime.parse('$dateNow-0800').minute.toString();
//               ref.update({
//                 now: Map<String, dynamic>.from(
//                   {'start': '$dateHour:$dateMinute'},
//                 ),
//               });
//             },
//             child: const Text('登出')),
//       ]),
//     );
//   }
//
//   void logout() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.clear();
//   }
// }
