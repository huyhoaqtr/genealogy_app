import './user.model.dart';

class TribeModel {
  String? sId;
  String? name;
  String? code;
  String? address;
  bool? active;
  String? createdAt;
  String? updatedAt;
  String? description;
  int? iV;
  User? leader;

  TribeModel(
      {this.sId,
      this.name,
      this.code,
      this.active,
      this.address,
      this.createdAt,
      this.updatedAt,
      this.description,
      this.iV,
      this.leader});

  TribeModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    code = json['code'];
    active = json['active'];
    address = json['address'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    description = json['description'];
    iV = json['__v'];
    leader = json['leader'] != null ? User.fromJson(json['leader']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['code'] = code;
    data['active'] = active;
    data['address'] = address;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['description'] = description;
    data['__v'] = iV;
    if (leader != null) {
      data['leader'] = leader!.toJson();
    }
    return data;
  }
}
