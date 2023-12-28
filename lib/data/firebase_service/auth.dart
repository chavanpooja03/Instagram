import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/data/firebase_service/firestore.dart';
import 'package:instagram/data/firebase_service/util.dart';

class Authentication {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> Login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
    } on FirebaseException catch (e) {
      throw exceptions(e.message.toString());
    }
  }

  Future<void> SignUp({
    required String email,
    required String password,
    required String Confirmpassword,
    required String username,
    required String bio,
  }) async {
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty) {
        if (password == Confirmpassword) {
          await _auth.createUserWithEmailAndPassword(
              email: email.trim(), password: password.trim());
          await Firebase_Firestore()
              .createUser(email: email, username: username, bio: bio);
        } else {
          throw exceptions('Password and Confirm password should be same');
        }
      } else {
        throw exceptions("Enter all the Field");
      }
    } on FirebaseException catch (e) {
      throw exceptions(e.message.toString());
    }
  }
}
