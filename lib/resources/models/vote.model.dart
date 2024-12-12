import 'package:getx_app/resources/models/user.model.dart';

class VoteSession {
  String? sId;
  String? title;
  String? desc;
  List<Options>? options;
  User? creator;
  String? tribe;
  String? createdAt;
  String? updatedAt;
  int? iV;

  VoteSession(
      {this.sId,
      this.title,
      this.desc,
      this.options,
      this.creator,
      this.tribe,
      this.createdAt,
      this.updatedAt,
      this.iV});

  VoteSession.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    desc = json['desc'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
    creator = json['creator'] != null ? User.fromJson(json['creator']) : null;
    tribe = json['tribe'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['desc'] = desc;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    if (creator != null) {
      data['creator'] = creator!.toJson();
    }
    data['tribe'] = tribe;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Options {
  String? text;
  List<User>? votes;
  String? sId;

  Options({this.text, this.votes, this.sId});

  Options.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    if (json['votes'] != null) {
      votes = <User>[];
      json['votes'].forEach((v) {
        votes!.add(User.fromJson(v));
      });
    }
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    if (votes != null) {
      data['votes'] = votes!.map((v) => v.toJson()).toList();
    }
    data['_id'] = sId;
    return data;
  }
}
