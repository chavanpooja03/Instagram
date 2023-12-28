import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/data/image_cached/image_cached.dart';
import 'package:date_format/date_format.dart';

class PostWidget extends StatelessWidget {
  final snapshot;
  const PostWidget(this.snapshot, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 375.w,
          height: 54.h,
          color: Colors.white,
          child: ListTile(
            title: Text(
              snapshot['username'] ?? '',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              snapshot['location'] ?? '',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            trailing: Icon(Icons.more_horiz),
          ),
        ),
        Container(
            height: 270.h,
            width: 370.w,
            child: CachedImage(snapshot['postImage'] ?? '')),
        Container(
          width: 375.w,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  SizedBox(width: 10.0),
                  Icon(
                    Icons.favorite_border_outlined,
                    color: Colors.black,
                    size: 30.0,
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Image.asset(
                    'images/comment.webp',
                    height: 32.0,
                  ),
                  SizedBox(
                    width: 30.w,
                  ),
                  Image.asset('images/send.jpg'),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Image.asset(
                      'images/save.png',
                      height: 29.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      (snapshot['username'] ?? ''),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Expanded(
                      child: Text(snapshot['caption'] ?? '',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 13.0,
                              color: Colors.black)),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, top: 8.0, bottom: 4.0),
                    child: Text(
                      formatDate(
                          snapshot['time'].toDate(), [yyyy, '-', mm, '-', dd]),
                      style: TextStyle(
                          fontSize: 11.0, fontWeight: FontWeight.normal),
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
