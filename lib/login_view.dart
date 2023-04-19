// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:lunch_order/admin_view.dart';
import 'package:lunch_order/auth_service.dart';
import 'package:lunch_order/user_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('登入'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(hintText: 'Email'),
              ),
            ),
            const SizedBox(height: 30.0),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: TextField(
                controller: passwordController,
                decoration: const InputDecoration(hintText: 'Password'),
              ),
            ),
            const SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                final message = await AuthService().login(
                  email: emailController.text,
                  password: passwordController.text,
                );
                if (message!.contains('Success')) {
                  if (emailController.text == 'admin@bbb.com') {
                    navigator.pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const AdminView(),
                      ),
                    );
                  } else {
                    navigator.pushReplacement(MaterialPageRoute(
                        builder: (context) => const UserView()));
                  }
                }
                scaffoldMessenger
                    .showSnackBar(SnackBar(content: Text(message.toString())));
              },
              child: const Text('登入'),
            ),
          ],
        ),
      ),
    );
  }
}
