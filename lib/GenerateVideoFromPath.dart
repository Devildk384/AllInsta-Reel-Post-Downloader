import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allIns/VideoPlayer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:io';

class GenrateVideoFrompath extends StatefulWidget {
  final String path;
  final bool isHome;
  final Function updateVideoState;

  // final bool isreward;
  const GenrateVideoFrompath(this.path, this.isHome, this.updateVideoState,
      {super.key});
  @override
  _GenrateVideoFrompathState createState() => _GenrateVideoFrompathState();
}

class _GenrateVideoFrompathState extends State<GenrateVideoFrompath> {
  var box = GetStorage();
  var uint8list = null;
  bool loading = true;
  // late RewardedAd _rewardedAd;
  bool _isRewardedAdLoaded = false;
  bool isrewardValue = true;
  @override
  void initState() {
    print(widget.path);
    print("DKJJKDSKJDSDSDSJSDKJJDSKJDSJDSJKDSJKDSJKDSJKDDSJK");
    if (widget.path.contains(".mp4")) {
      genrateThumb();
    }
    loading = false;
//  RewardedAd.load(
//     adUnitId: "ca-app-pub-8947607922376336/5113360720",
//     request: const AdRequest(),
//     rewardedAdLoadCallback: RewardedAdLoadCallback(
//       onAdLoaded: (ad) {
//         _rewardedAd = ad;
//         ad.fullScreenContentCallback = FullScreenContentCallback(
//           onAdDismissedFullScreenContent: (ad) {
//             setState(() {
//               _isRewardedAdLoaded = false;
//             });
//           },
//         );
//         setState(() {
//           _isRewardedAdLoaded = true;
//         });
//       },
//       onAdFailedToLoad: (err) {
//         setState(() {
//           _isRewardedAdLoaded = false;
//         });
//       },
//     ),
//   );
    super.initState();
  }

  _deleteVideo(String path) async {
    List allImagesPathList = box.read("allVideo") ?? [];
    List allData = box.read("all") ?? [];

    print(allImagesPathList);
    allImagesPathList.removeWhere((element) => element == path);
    allData.removeWhere((element) => element == path);

    print(allImagesPathList);
    box.write("allVideo", allImagesPathList);
    box.write("all", allData);

    File(path).delete();
  }

  genrateThumb() async {
    await VideoThumbnail.thumbnailData(
      video: widget.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth:
          500, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 100,
    ).then((value) {
      uint8list = value;
      loading = false;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (uint8list == null) {
      return Container(
          color: Colors.transparent,
          child: CupertinoActivityIndicator(
            color: Color.fromARGB(255, 238, 212, 13),
          ));
    }

    return Container(
        color: Colors.transparent,
        child: loading
            ? CupertinoActivityIndicator(
                color: Color.fromARGB(255, 238, 212, 13),
              )
            : Container(
                constraints: const BoxConstraints.expand(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Column(
                    children: [
                      InkWell(
                          onTap: () {
                            Get.to(VideoPlayer(widget.path));
                          },
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Container(
                                  height: widget.isHome ? 200 : 200,
                                  decoration: widget.isHome
                                      ? BoxDecoration(

                                          // borderRadius: BorderRadius.circular(20),
                                          image: DecorationImage(
                                              image: MemoryImage(uint8list),
                                              fit: BoxFit.cover))
                                      : BoxDecoration(

                                          // borderRadius: BorderRadius.circular(20),
                                          image: DecorationImage(
                                              image: MemoryImage(uint8list),
                                              fit: BoxFit.cover)),
                                ),
                              ),
                              ClipOval(
                                child: Container(
                                    color: Colors.black38,
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.play_arrow,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    )),
                              )
                            ],
                          )),
                      widget.isHome
                          ? Container(
                              child: Padding(
                                padding: EdgeInsets.all(1),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  backgroundColor: Colors.black,
                                                  title: const Text(
                                                    'Delete Video',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  content: const Text(
                                                    'Are you sure want to Delete?',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                        context,
                                                        'Cancel',
                                                      ),
                                                      child: const Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () => {
                                                        _deleteVideo(
                                                            widget.path),
                                                        widget.updateVideoState(
                                                            true),
                                                        Navigator.pop(context)
                                                      },
                                                      child: const Text(
                                                        'OK',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.yellow),
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
                              ),
                            )
                          : Container()
                    ],
                  ),
                )));
  }
}
