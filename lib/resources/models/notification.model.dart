class NotificationModel {
  String? sId;
  String? title;
  String? desc;
  String? type;
  String? screenId;
  String? user;
  bool? isRead;
  String? createdAt;
  String? updatedAt;
  int? iV;

  NotificationModel(
      {this.sId,
      this.title,
      this.desc,
      this.type,
      this.screenId,
      this.user,
      this.isRead,
      this.createdAt,
      this.updatedAt,
      this.iV});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    desc = json['desc'];
    type = json['type'];
    screenId = json['screenId'];
    user = json['user'];
    isRead = json['isRead'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['desc'] = this.desc;
    data['type'] = this.type;
    data['screenId'] = this.screenId;
    data['user'] = this.user;
    data['isRead'] = this.isRead;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }

  NotificationModel copyWith(
      {String? sId,
      bool? isRead,
      String? title,
      String? desc,
      String? type,
      String? screenId,
      String? user,
      String? createdAt,
      String? updatedAt,
      int? iV}) {
    return NotificationModel(
      sId: sId ?? this.sId,
      isRead: isRead ?? this.isRead,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      type: type ?? this.type,
      screenId: screenId ?? this.screenId,
      user: user ?? this.user,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      iV: iV ?? this.iV,
    );
  }
}
