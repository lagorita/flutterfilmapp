import 'package:flutter_filmapp/module/scenes.dart';

class Film {
  String category, cover, name,point;
  List<Scenes> scenes;

  Film({this.category, this.cover, this.name, this.point, this.scenes});

   Film.fromJson(Map<String, dynamic> json) {
    category = json['Category'];
    if (json['Scenes'] != null) {
      scenes = new List<Scenes>();
      json['Scenes'].forEach((v) {
        scenes.add(new Scenes.fromJson(v));
      });
    }
    cover = json['Cover'];
    name = json['Name'];
    point=json['Point'];


    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['Category'] = this.category;
      if (this.scenes != null) {
        data['Scenes']=this.scenes.map((e) => e.toJson()).toList();
      }
      data['Cover'] = this.cover;
      data['Name'] = this.name;
      data['Point']=this.point; 
      return data;
    }
  }

}
