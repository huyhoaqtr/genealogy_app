import 'dart:io';

import 'package:getx_app/resources/models/user.model.dart';

class Message {
  String? sId;
  String? content;
  String? file;
  User? sender;
  Message? replyMessage;
  String? createdAt;
  String? updatedAt;
  String? tempId;
  File? tempImage;

  Message({
    this.sId,
    this.content,
    this.file,
    this.sender,
    this.replyMessage,
    this.createdAt,
    this.updatedAt,
    this.tempId,
    this.tempImage,
  });

  Message.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    content = json['content'];
    file = json['file'];
    sender = json['sender'] != null ? User.fromJson(json['sender']) : null;
    replyMessage = json['replyMessage'] != null
        ? Message.fromJson(json['replyMessage'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    tempId = json['tempId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['content'] = content;
    data['file'] = file;
    if (sender != null) {
      data['sender'] = sender!.toJson();
    }
    if (replyMessage != null) {
      data['replyMessage'] = replyMessage!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (tempId != null) {
      data['tempId'] = tempId;
    }
    return data;
  }
}
