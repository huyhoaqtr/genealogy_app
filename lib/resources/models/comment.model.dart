import 'user.model.dart';

class CommentFeed {
  String? sId;
  User? user;
  String? content;
  List<String>? likes;
  String? parent;
  List<CommentFeed>? replies;
  String? feed;
  String? createdAt;
  String? updatedAt;
  int? iV;

  CommentFeed(
      {this.sId,
      this.user,
      this.content,
      this.likes,
      this.parent,
      this.replies,
      this.feed,
      this.createdAt,
      this.updatedAt,
      this.iV});

  CommentFeed.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;

    content = json['content'];
    likes = json['likes'].cast<String>();
    parent = json['parent'];
    if (json['replies'] != null) {
      replies = <CommentFeed>[];
      json['replies'].forEach((v) {
        replies!.add(new CommentFeed.fromJson(v));
      });
    }
    feed = json['feed'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['content'] = this.content;
    data['likes'] = this.likes;
    data['parent'] = this.parent;
    if (this.replies != null) {
      data['replies'] = this.replies!.map((v) => v.toJson()).toList();
    }
    data['feed'] = this.feed;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
