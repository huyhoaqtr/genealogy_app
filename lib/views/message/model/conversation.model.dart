import 'package:getx_app/resources/models/user.model.dart';

class Conversation {
  String? sId;
  String? type;
  List<Members>? members;
  String? createdAt;
  String? updatedAt;
  int? iV;
  LastMessage? lastMessage;

  Conversation(
      {this.sId,
      this.type,
      this.members,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.lastMessage});

  Conversation.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    type = json['type'];
    if (json['members'] != null) {
      members = <Members>[];
      json['members'].forEach((v) {
        members!.add(new Members.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    lastMessage = json['lastMessage'] != null
        ? new LastMessage.fromJson(json['lastMessage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['type'] = this.type;
    if (this.members != null) {
      data['members'] = this.members!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.lastMessage != null) {
      data['lastMessage'] = this.lastMessage!.toJson();
    }
    return data;
  }
}

class Members {
  String? sId;
  Info? info;

  Members({this.sId, this.info});

  Members.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    info = json['info'] != null ? new Info.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
    return data;
  }
}

class Info {
  String? sId;
  String? fullName;
  String? avatar;
  int? iV;

  Info({this.sId, this.fullName, this.avatar, this.iV});

  Info.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['fullName'];
    avatar = json['avatar'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['fullName'] = this.fullName;
    data['avatar'] = this.avatar;
    data['__v'] = this.iV;
    return data;
  }
}

class LastMessage {
  String? sId;
  String? conversation;
  String? content;
  String? file;
  User? sender;
  String? createdAt;
  String? updatedAt;
  int? iV;

  LastMessage(
      {this.sId,
      this.conversation,
      this.content,
      this.file,
      this.sender,
      this.createdAt,
      this.updatedAt,
      this.iV});

  LastMessage.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    conversation = json['conversation'];
    content = json['content'];
    file = json['file'];
    // sender = json['sender'];
    sender = json['sender'] != null ? new User.fromJson(json['sender']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['conversation'] = this.conversation;
    data['content'] = this.content;
    data['file'] = this.file;
    // data['sender'] = this.sender;
    if (this.sender != null) {
      data['sender'] = this.sender!.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
