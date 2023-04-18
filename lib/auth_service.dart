import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, password: password,);
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