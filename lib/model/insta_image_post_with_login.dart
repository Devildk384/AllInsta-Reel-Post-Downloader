class InstaImagePostWithLogin {
  List<Items>? items;

  InstaImagePostWithLogin({this.items});

  InstaImagePostWithLogin.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class Items {
//   List<VideoVersions>? videoVersions;

//   Items({this.videoVersions});

//   Items.fromJson(Map<String, dynamic> json) {
//     if (json['image_versions2'] != null) {
//       videoVersions = <VideoVersions>[];
//       json['image_versions2'].forEach((v) {
//         videoVersions!.add(new VideoVersions.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.videoVersions != null) {
//       data['image_versions2'] =
//           this.videoVersions!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

class Items {
  List? carouselMedia;

  Items({this.carouselMedia});

   Items.fromJson(Map<String, dynamic> json) {
    carouselMedia = json['carousel_media'];
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['carousel_media'] = this.carouselMedia;
  
    return data;
  }
}