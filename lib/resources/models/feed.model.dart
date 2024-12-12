import 'user.model.dart';

class Feed {
  User? user;
  String? content;
  List<String>? images;
  List<String>? likes;
  int? commentCount;
  String? tribe;
  String? sId;
  String? createdAt;
  String? updatedAt;

  Feed(
      {this.user,
      this.content,
      this.images,
      this.likes,
      this.commentCount,
      this.tribe,
      this.sId,
      this.createdAt,
      this.updatedAt});

  Feed.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    content = json['content'];
    images = json['images'].cast<String>();
    likes = json['likes'].cast<String>();
    commentCount = json['commentCount'];
    tribe = json['tribe'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['content'] = content;
    data['images'] = images;
    data['likes'] = likes;
    data['commentCount'] = commentCount;
    data['tribe'] = tribe;
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
