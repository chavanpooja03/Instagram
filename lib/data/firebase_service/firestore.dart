import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/data/firebase_service/util.dart';
import 'package:instagram/model/usermodel.dart';
import 'package:uuid/uuid.dart';

class Firebase_Firestore {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> createUser({
    required String? email,
    required String? username,
    required String? bio,
  }) async {
    await _firebaseFirestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .set({
      'email': email,
      'username': username,
      'bio': bio,
      'followers': [],
      'following': []
    });
    return true;
  }

  Future<Usermodel> getUser() async {
    try {
      final user = await _firebaseFirestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
      final snapuser = user.data();
      if (snapuser != null) {
        return Usermodel(snapuser['bio'], snapuser['email'],
            snapuser['followers'], snapuser['following'], snapuser['username']);
      } else {
        return Usermodel('', '', [], [], '');
      }
    } on FirebaseException catch (e) {
      throw exceptions(e.message.toString());
    }
  }

  Future<bool> createPost({
    required String? postImage,
    required String? caption,
    required String? location,
  }) async {
    var uid = Uuid().v4();
    DateTime data = new DateTime.now();
    Usermodel user = await getUser();
    await _firebaseFirestore.collection('posts').doc(uid).set({
      'postImage': postImage,
      'username': user.username,
      'caption': caption,
      'location': location,
      'uid': _auth.currentUser!.uid,
      'postId': uid,
      'time': data
    });
    return true;
  }
}
