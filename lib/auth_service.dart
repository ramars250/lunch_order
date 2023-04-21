// ignore_for_file: avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      //將用戶登入狀態保存
      await SharedPreferences.getInstance().then((prefs) {
        prefs.setBool('isAdminLoggedIn', email == 'admin@bbb.com');
        prefs.setBool('isUserLoggedIn', email != 'admin@bbb.com');
        prefs.setString('userName', email.split('@')[0]);
      });
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user - not-found') {
        return '找不到這個用戶';
      } else if (e.code == 'wrong-password') {
        return '錯誤的密碼';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }
}
