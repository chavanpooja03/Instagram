import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/data/firebase_service/firestore.dart';
import 'package:instagram/data/image_cached/image_cached.dart';
import 'package:instagram/model/usermodel.dart';
import 'package:instagram/screens/posted_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              FutureBuilder(
                  future: Firebase_Firestore().getUser(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return SliverToBoxAdapter(
                          child: Center(child: CircularProgressIndicator()));
                    }

                    return SliverToBoxAdapter(child: Head(snapshot.data!));
                  }),
              StreamBuilder(
                  stream: _firebaseFirestore
                      .collection('posts')
                      .where(
                        'uid',
                        isEqualTo: _auth.currentUser!.uid,
                      )
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return SliverToBoxAdapter(
                          child:
                              const Center(child: CircularProgressIndicator()));
                    }
                    var snapLength = snapshot.data!.docs.length;
                    return SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        var snap = snapshot.data!.docs[index];
                        return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PostScreen(snap.data()),
                              ));
                            },
                            child: CachedImage(snap['postImage']));
                      }, childCount: snapLength),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget Head(Usermodel user) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 13.w, vertical: 10.h),
                  child: ClipOval(
                    child: SizedBox(
                      width: 80.w,
                      height: 80.h,
                      child: Container(
                        color: Colors.grey,
                        child: Image.asset('images/person.png'),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 35.w,
                        ),
                        Text(
                          '10',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.sp),
                        ),
                        SizedBox(
                          width: 60.w,
                        ),
                        Text(
                          '30',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.sp),
                        ),
                        SizedBox(
                          width: 60.w,
                        ),
                        Text(
                          '5',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.sp),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 30.w,
                        ),
                        Text(
                          'Followers',
                          style: TextStyle(
                            fontSize: 13.sp,
                          ),
                        ),
                        SizedBox(
                          width: 30.w,
                        ),
                        Text(
                          'Following',
                          style: TextStyle(
                            fontSize: 13.sp,
                          ),
                        ),
                        SizedBox(
                          width: 30.w,
                        ),
                        Text(
                          'Posts',
                          style: TextStyle(
                            fontSize: 13.sp,
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  Text(
                    user.username,
                    style:
                        TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    user.bio,
                    style:
                        TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                alignment: Alignment.center,
                height: 30.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.r),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Text('Edit Your Profile'),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            SizedBox(
              width: double.infinity,
              height: 30.h,
              child: const TabBar(
                unselectedLabelColor: Colors.grey,
                labelColor: Colors.black,
                indicatorColor: Colors.black,
                tabs: [
                  Icon(Icons.grid_on),
                  Icon(Icons.video_collection),
                  Icon(Icons.person),
                ],
              ),
            ),
            SizedBox(
              height: 5.h,
            )
          ],
        ),
      ),
    );
  }
}
