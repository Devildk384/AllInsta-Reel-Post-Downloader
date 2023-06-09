import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:allIns/Controller/DownloadController.dart';
import 'package:allIns/Controller/instagram_login.dart';
import 'package:allIns/DownloadedList.dart';
import 'package:allIns/GenerateVideoFromPath.dart';
import 'package:get_storage/get_storage.dart';
import 'package:allIns/GenrateImageFromPath.dart';
import 'package:allIns/RecentList.dart';
import 'package:allIns/RecentListStart.dart';
import 'package:allIns/RecentListStartwithUpdate.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart' as wb;
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List photos = [];

  DownloadController downloadController = Get.put(DownloadController());
  TextEditingController urlController = TextEditingController();
  // var box = GetStorage();
  bool loadingVideos = true;
  List allImages = [];
  bool isVideos = true;
  bool isLogin = true;

  bool isUpdate = false;

  BannerAd? _bannerAd;

  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdLoaded = false;

  @override
  void initState() {
    downloadController;
    checkCookies();
    print(downloadController);
    print("DSMDSKJDSJKDSJKDS");
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

  checkCookies() async {
    final cookieManager = wb.WebviewCookieManager();
    final gotCookies =
        await cookieManager.getCookies('https://www.instagram.com/');
    // is Cookie found then set isLogin to true
    setState(() {
      if (gotCookies.length > 0) isLogin = true;
    });
  }

  updateImageState(value) async {
    setState(() {
      isVideos = false;
      // allImages = box.read("allImage") ?? [];
    });
  }

  updateVideoState(value) async {
    setState(() {
      isVideos = false;
      // allImages = box.read("allVideo") ?? [];
    });
  }

  //  @override
  // void dispose() {
  //   _interstitialAd?.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    print("isUpdate");

    print(isUpdate);
    print("isUpdate");

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 28, 27, 27),
        body: DoubleBackToCloseApp(
          snackBar: const SnackBar(content: Text('Double Back to leave')),
          child: Container(
            constraints: const BoxConstraints.expand(),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                padding: const EdgeInsets.all(5),
                                height: 50,
                                width: 50,

                                child: const Center(
                                  child: Image(
                                    image: AssetImage("images/mainlogo.png"),
                                    height: 25,
                                  ),
                                ),

                                // color: Colors.red,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    height: 50,
                                    width: 50,
                                    child: IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Linecons.cog,
                                          color: Colors.white,
                                        )),
                                    // child: const Center(child: Image(image: AssetImage("images/setting.png"), height: 25,)),
                                    // color: Colors.red,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      height: 50,
                                      width: 50,
                                      child: IconButton(
                                          onPressed: () {
                                            if (_isInterstitialAdLoaded) {
                                              print(
                                                  "sdds...................................");
                                              _interstitialAd
                                                  ?.show(); // <- here
                                            }
                                            Get.to(DownloadedList());
                                            navigateSecondPage();
                                          },
                                          icon: const Icon(
                                            Icons.file_download,
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
                        const Padding(
                          padding: EdgeInsets.only(right: 0, left: 10),
                          child: Image(
                            image: AssetImage(
                              "images/allins.png",
                            ),
                            height: 70,
                          ),
                          // child: Text(
                          //   "Insta Downloader",
                          //   style: TextStyle(color: Color.fromARGB(255, 233, 8, 8), fontSize: 32),
                          // ),
                        ),
                        !isLogin
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 30, top: 0, bottom: 0),
                                child: Center(
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(InstaLogin());
                                      checkCookies();
                                    },
                                    child: Container(
                                      height: 60,
                                      // ignore: sort_child_properties_last
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15))),
                                              padding: const EdgeInsets.only(
                                                  left: 20),
                                              width: 50,
                                              child: const Center(
                                                  child: Icon(
                                                FontAwesome5.instagram,
                                                color: Colors.white,
                                                size: 35,
                                              )),
                                              // color: Colors.red,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: Center(
                                              child: Column(
                                                children: const [
                                                  Padding(
                                                    padding: EdgeInsets.all(6),
                                                    child: Text(
                                                      "Login to Instagram",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                  Text(
                                                    "For Smooth Private Download ",
                                                    style: TextStyle(
                                                        color: Colors.white70),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(25),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 30, left: 8, right: 8),
                          child: TextField(
                            cursorColor:
                                const Color.fromARGB(255, 238, 212, 13),
                            controller: urlController,
                            autocorrect: true,
                            onTap: () {
                              setState(() {});
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    padding: const EdgeInsets.all(5),
                                    height: 40,
                                    width: 50,
                                    child: const Center(
                                      child: Image(
                                        image: AssetImage("images/search.png"),
                                        height: 25,
                                      ),
                                    ),

                                    // color: Colors.red,
                                  ),
                                ),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: SizedBox(
                                    height: 20,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        urlController.clear();
                                      },
                                    ),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 238, 212, 13),
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                ),
                                filled: true,
                                hintStyle: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                                hintText: "Paste instagram link here",
                                fillColor: Colors.black),
                          ),
                        ),
                        Obx(
                          () => SizedBox(
                            height: 100,
                            child: downloadController.processing.value
                                ? const Center(
                                    child: CupertinoActivityIndicator(
                                      color: Color.fromARGB(255, 238, 212, 13),
                                    ),
                                  )
                                : Center(
                                    child: InkWell(
                                      onTap: () {
                                        if (urlController.text.contains(
                                            "https://www.instagram.com")) {
                                          // https://www.instagram.com/p/CoxlcZ_LGHm/?utm_source=ig_web_copy_link
                                          // urlController.text.contains("https://www.instagram.com/reels/videos");
                                          downloadController.downloadReal(
                                              urlController.text, context);
                                          urlController.clear();
                                        }
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 150,
                                        // ignore: sort_child_properties_last
                                        child: const Center(
                                          child: Text(
                                            "Download Now",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                        decoration: const BoxDecoration(
                                          // color: Color(0xffee2913),
                                          color:
                                              Color.fromARGB(255, 238, 212, 13),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(25),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ),

                        // Positioned(
                        //   right: 0,
                        //   top: 20,
                        //   child: Container(
                        //     child: TextButton(
                        //         onPressed: () {},
                        //         child: Text("No Recent Downloads")),
                        //   ),
                        // ),
                        GetBuilder(
                          init: downloadController,
                          builder: (_) => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: downloadController.path != null
                                    ? RecentList(
                                        path: "dkjdkjd",
                                        update: downloadController.path != null
                                            ? true
                                            : false)
                                    : isUpdate
                                        ? RecentListStart(isUpdate)
                                        : RecentListStartUpdate(),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          child: AdWidget(ad: _bannerAd!),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void refreshData() {
    isUpdate = true;
  }

  FutureOr onGoBack(dynamic value) {
    // print(value);
    // print("onGoBackonGoBackonGoBackonGoBackonGoBackonGoBackonGoBackonGoBack");

    // // setState(() {
    // //   isUpdate = true;
    // // });

    // void setTimeout(callback, time) {
    //   Duration timeDelay = Duration(milliseconds: time);
    //   print(
    //       "SStimeDelaytimeDelaytimeDelay..........................................dsdsddsdsdsb");
    //   Timer(timeDelay, callback);
    //   print(
    //       "timeDelaytimeDelaytimeDelay..........................................dsdsddsdsdsb");
    // }

    // void updateFunctionFalse() {
    //   setState(() {
    //     isUpdate = false;
    //   });
    // }

    // void updateFunctionTrue() {
    //   setState(() {
    //     isUpdate = true;
    //   });
    // }

    // setTimeout(updateFunctionTrue, 1000);
    // setTimeout(updateFunctionFalse, 2000);
    refreshData();
    setState(() {});

    void setTimeout(callback, time) {
      Duration timeDelay = Duration(milliseconds: time);
      print(
          "SStimeDelaytimeDelaytimeDelay..........................................dsdsddsdsdsb");
      Timer(timeDelay, callback);
      print(
          "timeDelaytimeDelaytimeDelay..........................................dsdsddsdsdsb");
    }

    void updateFunctionFalse() {
      setState(() {
        isUpdate = false;
      });
    }

    setTimeout(updateFunctionFalse, 1000);
  }

  void navigateSecondPage() {
    Route route = MaterialPageRoute(builder: (context) => DownloadedList());
    Navigator.push(context, route).then(onGoBack);
  }
}
