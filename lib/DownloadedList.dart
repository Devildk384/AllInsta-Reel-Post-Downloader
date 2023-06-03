import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:allIns/GenerateVideoFromPath.dart';
import 'package:allIns/GenrateImageFromPath.dart';
import 'package:get/get.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:allIns/home.dart';
import 'package:allIns/Controller/DownloadController.dart';

class DownloadedList extends StatefulWidget {
  _DownloadedListState createState() => _DownloadedListState();
}

class _DownloadedListState extends State<DownloadedList> {
  DownloadController downloadController = Get.put(DownloadController());

  var box = GetStorage();
  bool loadingVideos = true;
  List allImages = [];
  List allVideos = [];

  bool isVideos = true;
  bool isVideoDelete = false;

  late BannerAd _bannerAd;
  late AppOpenAd? myAppOpenAd;

  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdLoaded = false;

  @override
  void initState() {
    if (isVideos && isVideoDelete == false) {
      allVideos = box.read("allVideo") ?? [];
      print("...............................................");
      print(allVideos);
      print("...............................................");
    }
    loadingVideos = false;
    _bannerAd = BannerAd(
      adUnitId: "ca-app-pub-8947607922376336/5464580409",
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            // _isBottomBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          setState(() {
            // _isBottomBannerAdLoaded = false;
          });
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    )..load();

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

    super.initState();
  }

  updateState(value) async {
    if (value == "videos") {
      setState(() {
        isVideos = true;
        var ids = box.read("allVideo") ?? [];
        allVideos = ids.toSet().toList();
        print("...............................................");
        print(allVideos);
        print("...............................................");
      });
    } else {
      setState(() {
        isVideos = false;
        var ids = box.read("allImage") ?? [];
        allImages = ids.toSet().toList();
        // print(allImages);
        // print("allImageallImagesallImagesallImagesallImagesallImagess");
      });
    }
  }

  updateImageState(value) async {
    setState(() {
      isVideos = false;
      var ids = box.read("allImage") ?? [];
      allImages = ids.toSet().toList();
    });
  }

  updateVideoState(value) async {
    downloadController.updateState();
    print(box.read("allVideo") ?? []);
    print(downloadController.processing);
    setState(() {
      isVideos = false;
    });
    void setTimeout(callback, time) {
      Duration timeDelay = Duration(milliseconds: time);
      print(
          "SStimeDelaytimeDelaytimeDelay..........................................dsdsddsdsdsb");
      Timer(timeDelay, callback);
      print(
          "timeDelaytimeDelaytimeDelay..........................................dsdsddsdsdsb");
    }

    void updateFunction() {
      setState(() {
        isVideos = true;
        var ids = box.read("allVideo") ?? [];
        allVideos = ids.toSet().toList();
      });
    }

    setTimeout(updateFunction, 100);

    // setState(() {
    //   isVideos = true;
    // });
    // void updateFunction() {
    //   setState(() {
    //     var ids = box.read("allVideo") ?? [];
    //     allVideos = ids.toSet().toList();
    //   });
    // }

    // void setTimeout(callback, time) {
    //   Duration timeDelay = Duration(milliseconds: time);
    //   print(
    //       "SStimeDelaytimeDelaytimeDelay..........................................dsdsddsdsdsb");
    //   Timer(timeDelay, callback);
    //   print(
    //       "timeDelaytimeDelaytimeDelay..........................................dsdsddsdsdsb");
    // }

    // setTimeout(updateFunction, 3000);
  }

  @override
  Widget build(BuildContext context) {
    print("...............................................");
    print(isVideos);
    print("...............................................");
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color.fromARGB(255, 28, 27, 27),
      body: Container(
        color: const Color.fromARGB(255, 28, 27, 27),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Container(
                          padding: const EdgeInsets.all(5),

                          decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          height: 50,
                          width: 50,
                          child: IconButton(
                              onPressed: () {
                                if (_isInterstitialAdLoaded) {
                                  print(
                                      "sdds...................................");
                                  _interstitialAd?.show(); // <- here
                                }
                                Navigator.of(context).pop("ddsds");
                                // Get.to(const HomePage());
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              )),

                          // child: const Center(child: Image(image: AssetImage("images/downlo.png"), height: 25,)),
                          // color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                    padding: EdgeInsets.all(8),
                    child: SizedBox(
                      height: 50,
                      child: Center(
                        child:
                            Image(image: AssetImage("images/alldownloads.png")),
                        // child: Text("All Downloads", style: TextStyle(
                        //   color: Color.fromARGB(255, 238, 212, 13),
                        //   fontSize: 26,
                        //   fontWeight: FontWeight.w500
                        // ),),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 8, right: 16),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          height: 50,
                          width: 50,
                          child: IconButton(
                              onPressed: () {
                                // Get.to(DownloadedList());
                              },
                              icon: const Icon(
                                Linecons.cog,
                                color: Colors.white,
                              )),

                          // child: const Center(child: Image(image: AssetImage("images/downlo.png"), height: 25,)),
                          // color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    updateState("videos");
                    // Get.to(InstaLogin());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Center(
                      child: Container(
                        height: 50,
                        width: 160,
                        decoration: isVideos
                            ? const BoxDecoration(
                                color: Color.fromARGB(255, 238, 212, 13),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)))
                            : const BoxDecoration(
                                color: Colors.black,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                        child: isVideos
                            ? const Center(
                                child: Text(
                                "Videos",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ))
                            : const Center(
                                child: Text(
                                "Videos",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              )),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    updateState("images");

                    print("images");

                    // Get.to(InstaLogin());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Container(
                      height: 50,
                      width: 160,
                      decoration: isVideos
                          ? const BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))
                          : const BoxDecoration(
                              color: Color.fromARGB(255, 238, 212, 13),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                      child: isVideos
                          ? const Center(
                              child: Text(
                              "Images",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ))
                          : const Center(
                              child: Text(
                              "Images",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                    ),
                  ),
                ),
              ],
            ),
            // SizedBox(
            //     height: 50,
            //     child: AdWidget(ad: _bannerAd!),
            //     // color: Colors.red,
            //   ),
            SizedBox(
              height: 100,
              child: AdWidget(ad: _bannerAd),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: isVideos
                    ? GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 1 / 1.5,
                        children: List<Widget>.generate(
                            allVideos.length,
                            (index) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GenrateVideoFrompath(
                                    allVideos[index], true, updateVideoState))),
                      )
                    : GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 1 / 1.5,
                        children: List<Widget>.generate(
                            allImages.length,
                            (index) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GenrateImageFrompath(
                                  allImages[index],
                                  true,
                                  updateImageState,
                                ))),
                      ),
              ),
            )

            //     loadingVideos ? Center(child: CupertinoActivityIndicator(),) :
            //     GridView.count(crossAxisCount: 4,
            //     childAspectRatio: 1/1.3,
            //     children:List<Widget>.generate(allImages.length, (index) => Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: GenrateVideoFrompath(allImages[index]),
            //  )),),
          ],
        ),
      ),
      // body:
      //    loadingVideos ? Center(child: CupertinoActivityIndicator(),) :
      //     GridView.count(crossAxisCount: 4,
      //     childAspectRatio: 1/1.3,
      //     children:List<Widget>.generate(allImages.length, (index) => Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: GenrateVideoFrompath(allImages[index]),
      //  )),),
    ));
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
