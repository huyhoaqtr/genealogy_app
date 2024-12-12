class User {
  String? sId;
  String? phoneNumber;
  String? role;
  String? tribe;
  bool? active;
  String? createdAt;
  String? updatedAt;
  int? iV;
  Info? info;

  User(
      {this.sId,
      this.phoneNumber,
      this.role,
      this.tribe,
      this.active,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.info});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    phoneNumber = json['phoneNumber'];
    role = json['role'];
    tribe = json['tribe'];
    active = json['active'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    info = json['info'] != null ? Info.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['phoneNumber'] = phoneNumber;
    data['role'] = role;
    data['tribe'] = tribe;
    data['active'] = active;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    if (info != null) {
      data['info'] = info!.toJson();
    }
    return data;
  }
}

class Info {
  String? sId;
  String? fullName;
  String? avatar;
  List<String>? children;
  List<String>? couple;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Info(
      {this.sId,
      this.fullName,
      this.avatar,
      this.children,
      this.couple,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Info.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['fullName'];
    avatar = json['avatar'];
    if (json['children'] != null) {
      children = json['children'].cast<String>();
    }

    if (json['couple'] != null) {
      couple = json['couple'].cast<String>();
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['fullName'] = fullName;
    data['avatar'] = avatar;
    data['children'] = children;
    data['couple'] = couple;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
