// ignore_for_file: avoid_print
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunch_order/admin_view.dart';
import 'package:lunch_order/login_view.dart';
import 'package:lunch_order/user_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();

  final isAdminLogin = prefs.getBool('isAdminLoggedIn') ?? false;
  if (isAdminLogin) {
    runApp(const ProviderScope(child: MyApp(initialRoute: '/admin')));
    return;
  }

  final isUserLogin = prefs.getBool('isUserLoggedIn') ?? false;
  if (isUserLogin) {
    runApp(const ProviderScope(child: MyApp(initialRoute: '/user')));
  }
  runApp(const ProviderScope(child: MyApp(initialRoute: '/login')));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '中午吃什麼',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const LoginView(),
        '/admin': (context) => AdminView(),
        '/user': (context) => const UserView(),
      },
    );
  }
}
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   final ref = FirebaseDatabase.instance.ref('store');
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('中午吃什麼'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: getData,
//           child: const Text('讀資料'),
//         ),
//       ),
//     );
//   }
//
//   void getData() async {
//     final snapshot = await ref.child('').get();
//     if (snapshot.exists) {
//       final data = snapshot.value as List;
//       print(data[0]['store_name']);
//     } else {
//       print('Nooooo');
//     }
//   }
// }
