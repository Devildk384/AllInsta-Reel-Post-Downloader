class InstaPostWithoutLogin {
  Graphql? graphql;

  InstaPostWithoutLogin({this.graphql});

  InstaPostWithoutLogin.fromJson(Map<String, dynamic> json) {
    graphql =
        json['graphql'] != null ? new Graphql.fromJson(json['graphql']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.graphql != null) {
      data['graphql'] = this.graphql!.toJson();
    }
    return data;
  }
}

class Graphql {
  ShortcodeMedia? shortcodeMedia;

  Graphql({this.shortcodeMedia});

  Graphql.fromJson(Map<String, dynamic> json) {
    shortcodeMedia = json['shortcode_media'] != null
        ? new ShortcodeMedia.fromJson(json['shortcode_media'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.shortcodeMedia != null) {
      data['shortcode_media'] = this.shortcodeMedia!.toJson();
    }
    return data;
  }
}

class ShortcodeMedia {
  EdgeSideCar? edge_sidecar_to_children;


  ShortcodeMedia({this.edge_sidecar_to_children});

   ShortcodeMedia.fromJson(Map<String, dynamic> json) {
    edge_sidecar_to_children = json['edge_sidecar_to_children'] != null
        ? new EdgeSideCar.fromJson(json['edge_sidecar_to_children'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.edge_sidecar_to_children != null) {
      data['edge_sidecar_to_children'] = this.edge_sidecar_to_children!.toJson();
    }
    return data;
  }
}


class EdgeSideCar {
  List? edges;

  EdgeSideCar({this.edges});

   EdgeSideCar.fromJson(Map<String, dynamic> json) {
    edges = json['edges'];
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['edges'] = this.edges;
  
    return data;
  }
}


