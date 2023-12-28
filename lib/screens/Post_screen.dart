import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:instagram/data/firebase_service/firestore.dart';

import '../data/firebase_service/storage.dart';

class AddTextPost extends StatefulWidget {
  File _file;
  AddTextPost(this._file, {super.key});

  @override
  State<AddTextPost> createState() => _AddTextPostState();
}

class _AddTextPostState extends State<AddTextPost> {
  final caption = TextEditingController();
  final location = TextEditingController();
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'New Post',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    isloading = true;
                  });
                  String? post_url = await StorageMethod()
                      .uploadImageToStorage('post', widget._file);
                  await Firebase_Firestore().createPost(
                      postImage: post_url,
                      caption: caption.text,
                      location: location.text);
                  setState(() {
                    isloading = false;
                  });
                  Navigator.of(context).pop();
                },
                child: Text(
                  'share',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: isloading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 65.w,
                          height: 65.h,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: FileImage(widget._file),
                                fit: BoxFit.cover),
                          ),
                        ),
                        SizedBox(
                          width: 200.w,
                          height: 60.h,
                          child: TextField(
                            controller: caption,
                            decoration: InputDecoration(
                                hintText: ' Write a caption...',
                                border: InputBorder.none),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    SizedBox(
                      width: 200.w,
                      height: 60.h,
                      child: TextField(
                        controller: location,
                        decoration: InputDecoration(
                            hintText: 'Location...', border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
