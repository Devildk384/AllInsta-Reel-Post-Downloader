import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:instadownloader/model/Insta_video_without_login.dart';
import 'package:instadownloader/model/insta_image_post_with_login.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:instadownloader/Controller/instagram_login.dart';
import 'package:instadownloader/model/insta_post_with_login.dart';
import 'package:instadownloader/model/insta_post_without_login.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart' as wb;
import 'package:external_path/external_path.dart';
import 'dart:math';

class DownloadController extends GetxController {
  var processing = false.obs;
  bool isLogin = false;
  String? path;
  var box = GetStorage();
  Dio dio = Dio();
  Random random = new Random();

  Future<String?> _startDownload(String link, BuildContext context) async {
    // Asking for video storage permission 
    await Permission.storage.request();
    isLogin = false;
    // Checking for Cookies
    final cookieManager = wb.WebviewCookieManager();
    final gotCookies = await cookieManager.getCookies('https://www.instagram.com/');
    // is Cookie found then set isLogin to true
    if (gotCookies.length > 0) isLogin = true;

    // Build the url
    var linkParts = link.replaceAll(" ", "").split("/");
    var url = '${linkParts[0]}//${linkParts[2]}/${linkParts[3]}/${linkParts[4]}' + "?__a=1&__d=dis";
    print(url);
    // Make Http requiest to get the download link of video
    var httpClient =  HttpClient();
    List <dynamic>? videoURLLLLL;
    String urll = "";
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      print(request);
            print("request");

      gotCookies.forEach((element) {
        request.cookies.add(Cookie(element.name, element.value));
      });
      var response = await request.close();
      print(response);
            print("response");

      if (response.statusCode == HttpStatus.OK) {
        print(response);
        var json = await response.transform(utf8.decoder).join();
        print(json);

        var data = jsonDecode(json);
        print(data);
        
  

        // print(data["items"][0]["carousel_media"]);
        // newData = data["items"][0]["carousel_media"];
        if (isLogin) {
          print("login");

          if (data["items"][0]["carousel_media_count"] == null) {
                        urll = data["items"][0]["image_versions2"]["candidates"][0]["url"];

            
          }else{
            
              print("MOREEEE");
                      InstaImagePostWithLogin postWithLogin = InstaImagePostWithLogin.fromJson(data);
          videoURLLLLL = postWithLogin.items?.first.carouselMedia as List?;
          }
          // InstaImagePostWithLogin postWithLogin = InstaImagePostWithLogin.fromJson(data);
          // videoURLLLLL = postWithLogin.items?.first.videoVersions?.first.url as List?;
        } else {
          print(data["graphql"]["shortcode_media"]["media_preview"]);
          print("kjjjkkj");
          if (data["graphql"]["shortcode_media"]["media_preview"] == null) {
                      print("moreee");

            InstaPostWithoutLogin post = InstaPostWithoutLogin.fromJson(data);
          videoURLLLLL = post.graphql?.shortcodeMedia?.edge_sidecar_to_children?.edges;
          }else{
              print("single");

            urll = data["graphql"]["shortcode_media"]["display_url"];
          }
          
        }
      }
      else{
          await Navigator.push(context, MaterialPageRoute(builder: (_) => InstaLogin()));
      }
    } catch (exception) {
      // log(exception.toString());
      // Login to instagram in case of Cookie expire or download any private account's video
      await Navigator.push(context, MaterialPageRoute(builder: (_) => InstaLogin()));
    }



    // Download video & save
    // if (videoURLLLLL.length) {
    //   return null;
    // } else {
     String path = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_PICTURES);
        print(path);
      // var appDocDir = await getTemporaryDirectory();
      // String savePath = appDocDir.path + "/temp.mp4";
      // print(savePath);
      if (urll == "") {
            videoURLLLLL?.forEach((element) async {
              print(element);
        const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
      Random _rnd = Random();

     String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
              var name = "${path}/${random.nextInt(90)+ random.nextInt(100)}${getRandomString(10)}.jpg";
             if (element["image_versions2"] == null) {
                    var res = await dio.download(element["node"]["display_url"], name);

             }else{
                var res = await dio.download(element["image_versions2"]["candidates"][0]["url"], name);

             }
               List allImagesPath = box.read("allImage") ?? [];
        print(allImagesPath);
        allImagesPath.add(name);
        box.write("allImage", allImagesPath);

      });
      }else{
        print(urll);
         const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
      Random _rnd = Random();

     String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
                  var name = "${path}/${random.nextInt(90)+ random.nextInt(100)}${getRandomString(10)}.jpg";

             var res = await dio.download(urll, name);
              return name;


      }
  
    //  print(res);
    }
  // }


   Future<String?> _startVideoDownload(String link, BuildContext context) async {
    // Asking for video storage permission 
    await Permission.storage.request();
    isLogin = false;
    // Checking for Cookies
    final cookieManager = wb.WebviewCookieManager();
    final gotCookies = await cookieManager.getCookies('https://www.instagram.com/');
    print(gotCookies);
    // is Cookie found then set isLogin to true
    if (gotCookies.length > 0) isLogin = true;

    // Build the url
    var linkParts = link.replaceAll(" ", "").split("/");
    var url = '${linkParts[0]}//${linkParts[2]}/${linkParts[3]}/${linkParts[4]}' + "?__a=1&__d=dis";
    // Make Http requiest to get the download link of video
    print(url);
    var httpClient = new HttpClient();
    String? videoURLLLLL;
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      gotCookies.forEach((element) {
        request.cookies.add(Cookie(element.name, element.value));
      });
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(utf8.decoder).join();
        var data = jsonDecode(json);
        print(data);
          // print(data["graphql"]["shortcode_media"]["display_resources"]);
        if (isLogin) {
          print("loginnnnn");
          InstaPostWithLogin postWithLogin = InstaPostWithLogin.fromJson(data);
          videoURLLLLL = postWithLogin.items?.first.videoVersions?.first.url;
          print(videoURLLLLL);
        } else {
          InstaPostVideoWithoutLogin post = InstaPostVideoWithoutLogin.fromJson(data);
          videoURLLLLL = post.graphql?.shortcodeMedia?.videoUrl;
        }
      }else{
              await Navigator.push(context, MaterialPageRoute(builder: (_) => InstaLogin()));

      }
    } catch (exception) {

      await Navigator.push(context, MaterialPageRoute(builder: (_) => InstaLogin()));
    }

    // Download video & save
    if (videoURLLLLL == null) {
      return null;
    } else {
     String path = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
        print(path);
      // var appDocDir = await getTemporaryDirectory();
      // String savePath = appDocDir.path + "/temp.mp4";
      // print(savePath);
      var name = "${path}/${random.nextInt(90)+ random.nextInt(100)}.mp4";
     var res = await dio.download(videoURLLLLL, name);
     return name;
    //  print(res);
    }
  }



 
  

  downloadReal(String link, BuildContext context) async {
    print(link);
    processing.value = true;
    try {
      path = null;
      update();
      if (link.contains("reel")) {
        await _startVideoDownload(link, context).then((value) {
        if (value == null) throw Exception();
        path = value;
        update();
        List allImagesPath = box.read("allVideo") ?? [];
        print(allImagesPath);
        allImagesPath.add(path);
        box.write("allVideo", allImagesPath);
      });
      }else{
      await _startDownload(link, context).then((value) {
        if (value == null) throw Exception();
        path = value;
        update();
        List allImagesPath = box.read("allImage") ?? [];
        print(allImagesPath);
        allImagesPath.add(path);
        box.write("allImage", allImagesPath);
      });
      }
    
    } catch (e) {}
    processing.value = false;
  }
}
