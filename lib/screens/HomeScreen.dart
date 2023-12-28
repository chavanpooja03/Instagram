import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/Widget/PoatWidget.dart';

class HomesScreen extends StatefulWidget {
  const HomesScreen({super.key});

  @override
  State<HomesScreen> createState() => _HomesScreenState();
}

class _HomesScreenState extends State<HomesScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: SizedBox(
          height: 28.h,
          width: 105.w,
          child: Image.asset('images/logo.jpg'),
        ),
        leading: Image.asset('images/camera.jpg'),
        actions: [
          const Icon(Icons.favorite_border_outlined, color: Colors.black),
          Image.asset('images/send.jpg'),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          StreamBuilder(
              stream: _firebaseFirestore
                  .collection('posts')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                return SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error:${snapshot.error}'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasData && snapshot.data != null) {
                      return PostWidget(snapshot.data!.docs[index].data());
                    }
                  },
                  childCount:
                      snapshot.data == null ? 0 : snapshot.data!.docs.length,
                ));
              })
        ],
      ),
    );
  }
}
