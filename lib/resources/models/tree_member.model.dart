class TreeMember {
  String? fullName;
  String? avatar;
  String? address;
  String? dateOfBirth;
  String? dateOfDeath;
  String? description;
  double? positionX;
  double? positionY;
  String? title;
  String? gender;
  String? parent;
  List<TreeMember>? children;
  List<TreeMember>? couple;
  String? tribe;
  String? phoneNumber;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? level;
  bool? isDead;
  String? burial;
  String? placeOfWorship;
  String? personInCharge;

  TreeMember(
      {this.fullName,
      this.avatar,
      this.address,
      this.dateOfBirth,
      this.dateOfDeath,
      this.description,
      this.positionX,
      this.positionY,
      this.title,
      this.gender,
      this.phoneNumber,
      this.parent,
      this.couple,
      this.children,
      this.tribe,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.isDead,
      this.burial,
      this.placeOfWorship,
      this.personInCharge,
      this.level});

  TreeMember.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    avatar = json['avatar'];
    address = json['address'];
    dateOfBirth = json['dateOfBirth'];
    dateOfDeath = json['dateOfDeath'];
    description = json['description'];
    gender = json['gender'];
    positionX = (json['positionX'] as num?)?.toDouble();
    phoneNumber = json['phoneNumber'];
    positionY = (json['positionY'] as num?)?.toDouble();
    title = json['title'];
    parent = json['parent'];
    isDead = json['isDead'];
    if (json['burial'] != null) {
      burial = json['burial'];
    }
    if (json['placeOfWorship'] != null) {
      placeOfWorship = json['placeOfWorship'];
    }
    if (json['personInCharge'] != null) {
      personInCharge = json['personInCharge'];
    }

    if (json['couple'] != null) {
      couple = <TreeMember>[];
      json['couple'].forEach((v) {
        couple!.add(new TreeMember.fromJson(v));
      });
    }
    if (json['children'] != null) {
      children = <TreeMember>[];
      json['children'].forEach((v) {
        children!.add(new TreeMember.fromJson(v));
      });
    }
    tribe = json['tribe'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    level = json['level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = fullName;
    data['avatar'] = avatar;
    data['address'] = address;
    data['gender'] = gender;
    data['dateOfBirth'] = dateOfBirth;
    data['dateOfDeath'] = dateOfDeath;
    data['description'] = description;
    data['positionX'] = positionX;
    data['positionY'] = positionY;
    data['phoneNumber'] = phoneNumber;
    data['title'] = title;
    data['parent'] = parent;
    data['isDead'] = isDead;
    if (burial != null) {
      data['burial'] = burial;
    }
    if (personInCharge != null) {
      data['personInCharge'] = personInCharge;
    }
    if (placeOfWorship != null) {
      data['placeOfWorship'] = placeOfWorship;
    }

    if (couple != null) {
      data['couple'] = couple!.map((v) => v.toJson()).toList();
    }
    if (children != null) {
      data['children'] = children!.map((v) => v.toJson()).toList();
    }
    data['tribe'] = tribe;
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['level'] = level;
    return data;
  }
}
