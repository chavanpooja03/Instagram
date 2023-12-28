import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/screens/Post_screen.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:io';

class AddPostScreen extends StatefulWidget {
  AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final List<Widget> _mediaList = [];
  final List<File> path = [];
  File? _file;
  int currentpage = 0;
  int? lastPage;

  @override
  _fetchNewMedia() async {
    lastPage = currentpage;
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      List<AssetPathEntity> album =
          await PhotoManager.getAssetPathList(type: RequestType.image);
      List<AssetEntity> media =
          await album[0].getAssetListPaged(page: currentpage, size: 60);

      for (var asset in media) {
        if (asset.type == AssetType.image) {
          final file = await asset.file;
          if (file != null) {
            path.add(File(file.path));
            _file = path[0];
          }
          print(path);
        }
      }

      List<Widget> temp = [];
      for (var asset in media) {
        temp.add(FutureBuilder(
          future: asset.thumbnailDataWithSize(ThumbnailSize(200, 200)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.memory(
                        snapshot.data!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container();
          },
        ));
      }
      setState(() {
        _mediaList.addAll(temp);
        currentpage++;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
  }

  int indexx = 0;
  Widget build(BuildContext context) {
    return SizedBox(
      height: 375,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text(
            'New Post',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          centerTitle: false,
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddTextPost(_file!),
                    ));
                  },
                  child: Text(
                    'Next',
                    style: TextStyle(fontSize: 15, color: Colors.blue),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 375.h,
                  child: GridView.builder(
                      itemCount: _mediaList.isEmpty ? _mediaList.length : 1,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                      ),
                      itemBuilder: (context, index) {
                        return _mediaList[indexx];
                      }),
                ),
                Container(
                  width: double.infinity,
                  height: 40.h,
                  color: Colors.white,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        'Recent',
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.w800),
                      )
                    ],
                  ),
                ),
                GridView.builder(
                    itemCount: _mediaList.length,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 1,
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            setState(() {
                              indexx = index;
                              _file = path[index];
                            });
                          },
                          child: _mediaList[index]);
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
