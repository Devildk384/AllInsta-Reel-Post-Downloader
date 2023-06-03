import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:allIns/DownloadedList.dart';
import 'package:allIns/GenerateVideoFromPath.dart';
import 'package:allIns/GenrateImageFromPath.dart';
import 'package:get/get.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RecentListStart extends StatefulWidget {
  final bool isUpdate;

  const RecentListStart(this.isUpdate, {super.key});
  @override
  // ignore: library_private_types_in_public_api
  _RecentListStartState createState() => _RecentListStartState();
}

class _RecentListStartState extends State<RecentListStart> {
  var box = GetStorage();
  bool loadingVideos = true;
  List allImages = [];
  List allVideos = [];
  List all = [];

  bool isVideos = true;
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdLoaded = false;
  @override
  void initState() {
    print(widget.isUpdate);
    print(
        "widget.isUpdatewidget.isUpdatewidget.isUpdatewidget.isUpdatewidget.isUpdate");

    var allData = box.read("all") ?? [];
    // var allImagesdata = box.read("allImage") ?? [];
    var reversedList = new List.from(allData.reversed);

    all = [...reversedList];
    print("...............................................");
    print(allData);
    print("...............................................");

    InterstitialAd.load(
      adUnitId: "ca-app-pub-8947607922376336/7184006128",
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isInterstitialAdLoaded = true;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isInterstitialAdLoaded = false;
          _interstitialAd?.dispose();
        },
      ),
    );
    // print(widget.path);
    // if (widget.path != null) {
    //   print("ddkjdjkfdjfdkkkkkkkkkkkkkkkkkk");
    // }
    // updateImageState();
    // updateVideoState();
    // loadingVideos = false;
    if (widget.isUpdate) {
      updateState(widget.isUpdate);
    }
    super.initState();
  }

  updateState(value) async {
    setState(() {
      var allData = box.read("all") ?? [];
      // var allImagesdata = box.read("allImage") ?? [];
      var reversedList = new List.from(allData.reversed);

      all = [...reversedList];
      print("...............................................");
      print(allData);
      print("...............................................");
    });
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
    print("widget.isUpdate");

    print(widget.isUpdate);
    print("widget.isUpdate");

    if (widget.isUpdate) {
      updateState(widget.isUpdate);
    }

    return Container(
      height: 280,
      decoration: const BoxDecoration(),
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
              child: TextButton(
                onPressed: () {
                  if (_isInterstitialAdLoaded) {
                    print("sdds...................................");
                    _interstitialAd?.show(); // <- here
                  }
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
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
            ),
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
