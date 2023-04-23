import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:instadownloader/DownloadedList.dart';
import 'package:instadownloader/GenerateVideoFromPath.dart';
import 'package:instadownloader/GenrateImageFromPath.dart';
import 'package:get/get.dart';
import 'package:fluttericon/linecons_icons.dart';

class RecentList extends StatefulWidget {
  final String? path;
  late bool? update;

   RecentList({this.path, this.update, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RecentListState createState() => _RecentListState();
}

class _RecentListState extends State<RecentList> {
  var box = GetStorage();
  bool loadingVideos = true;
  List allImages = [];
  List allVideos = [];
  List all = [];

  bool isVideos = true;

  @override
  void initState() {
    print(widget.path);
        print(widget.update);

          print("wiiii...............................................");

    if (isVideos && widget.update == true ) {
      var allVideosdata = box.read("allVideo") ?? [];
      var allImagesdata = box.read("allImage") ?? [];
      all = [...allVideosdata, ...allImagesdata];
      print("...............................................");
      print(allVideos);
      print("...............................................");
    }else{
      var allVideosdata = box.read("allVideo") ?? [];
      var allImagesdata = box.read("allImage") ?? [];
      all = [...allVideosdata, ...allImagesdata];
      print("...............................................");
      print(allVideos);
      print("...............................................");
    }
    print(widget.path);
    if (widget.path != null) {
      print("ddkjdjkfdjfdkkkkkkkkkkkkkkkkkk");
    }
    updateImageState();
    updateVideoState();
    loadingVideos = false;
    super.initState();
  }

  updateState(value) async {
    if (value == "videos") {
      setState(() {
        isVideos = true;
        allVideos = box.read("allVideo") ?? [];
        print("...............................................");
        print(allVideos);
        print("...............................................");
      });
    } else {
      setState(() {
        isVideos = false;
        allImages = box.read("allImage") ?? [];
      });
    }
  }

  updateImageState() async {
    setState(() {
      allImages = box.read("allImage") ?? [];
    });
  }

  updateVideoState() async {
    setState(() {
      allVideos = box.read("allVideo") ?? [];
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      decoration: const BoxDecoration(
        ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              alignment: Alignment.topRight,
              height: 50,
              width: 300,
              decoration: const BoxDecoration(
                // color: Colors.black
                ),
              child:  TextButton(
                onPressed: (){
                   Get.to(DownloadedList());
                },
                child: const Text(
                  "View All",
                  textAlign: TextAlign.end,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8,),
            child: SizedBox(
              // color: Colors.red,
                 height: 220,
                child: ListView.builder(
                    itemCount: all.length < 6 ? all.length : 5,
                    shrinkWrap: false,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      /// Create List Item tile
                      return CategoriesTile(
                          path: all[index],
                          updateImageState: updateImageState,
                          updateVideoState: updateVideoState);
                    }),
              ),
            ),
          
        ],
      ),
    );
  }
}

class CategoriesTile extends StatelessWidget {
  final String path;
  final Function updateImageState;
  final Function updateVideoState;

  const CategoriesTile(
      {required this.path,
      required this.updateImageState,
      required this.updateVideoState,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
          child: Column(
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                // color: Colors.red,
                height: 220,
                width: 150,
                child: path.contains("Pictures")
                    ? GenrateImageFrompath(path ?? "", false, updateImageState)
                    : GenrateVideoFrompath(path ?? "", false, updateVideoState),
              )),
        ],
      )),
    );
  }
}