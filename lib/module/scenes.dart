class Scenes {
  String sceneNames;
  List<String> photos;
  Scenes({this.sceneNames, this.photos});
  Scenes.fromJson(Map<String, dynamic> json) {
    sceneNames = json['SceneNames'];
    if (json['Photos'] != null) {
      photos = json['Photos'].cast<String>();
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Photos'] = this.photos;
    data['SceneName'] = this.sceneNames;
    return data;
  }
}
