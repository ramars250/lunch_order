// ignore_for_file: avoid_print
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunch_order/admin_view.dart';
import 'package:lunch_order/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '中午吃什麼',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginView(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ref = FirebaseDatabase.instance.ref('store');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('中午吃什麼'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: getData,
          child: const Text('讀資料'),
        ),
      ),
    );
  }

  void getData() async {
    final snapshot = await ref.child('').get();
    if (snapshot.exists) {
      final data = snapshot.value as List;
      print(data[0]['store_name']);
    } else {
      print('Nooooo');
    }
  }
}
