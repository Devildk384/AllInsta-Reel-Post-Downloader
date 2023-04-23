import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instadownloader/VideoPlayer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:io';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get_storage/get_storage.dart';

class GenrateImageFrompath extends StatefulWidget {
  final String path;
  final bool isHome;
  final Function updateImageState;

  const GenrateImageFrompath(this.path, this.isHome, this.updateImageState,
      {super.key});
  @override
  _GenrateImageFrompathState createState() => _GenrateImageFrompathState();
}

class _GenrateImageFrompathState extends State<GenrateImageFrompath> {
  bool loading = true;
  var box = GetStorage();

  @override
  void initState() {
    loading = false;
    super.initState();
  }

  _deleteImage(String path) async {
    List allImagesPathList = box.read("allImage") ?? [];
    print(allImagesPathList);
    allImagesPathList.removeWhere((element) => element == path);
    print(allImagesPathList);
    box.write("allImage", allImagesPathList);
    File(path).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: loading
          ? CupertinoActivityIndicator(color: Color.fromARGB(255, 238, 212, 13),)
          : Column(
              children: [
                InkWell(
                  onTap: () {
                    Get.to(
                        PhotoView(imageProvider: FileImage(File(widget.path))));
                  },
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          // height: widget.isHome? 200 : 200,
                          decoration: BoxDecoration(
                            //  image: FileImage(File(widget.path)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          
                          child: Image.file(File(widget.path),
                          fit: BoxFit.cover,
                          height: 200,
                          width: 200,),
                        ),
                      ),
                    ],
                  ),
                ),
                widget.isHome
                    ? Padding(
                        padding: const EdgeInsets.all(1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: IconButton(
                                  onPressed: () {
                                    Share.shareFiles([widget.path]);
                                  },
                                  icon: Icon(
                                    Icons.share,
                                    color: Colors.white,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: IconButton(
                                  onPressed: () => showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          backgroundColor: Colors.black,
                                          title: const Text(
                                            'Delete Image',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          content: const Text(
                                            'Are you sure want to Delete?',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                context,
                                                'Cancel',
                                              ),
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () => {
                                                _deleteImage(widget.path),
                                                widget.updateImageState(true),
                                                Navigator.pop(context)
                                              },
                                              child: const Text(
                                                'OK',
                                                style: TextStyle(
                                                    color: Colors.yellow),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  )),
                            ),
                          ],
                        ),
                      )
                    : Container(height: 2,)
              ],
            ),
    );
  }
}
