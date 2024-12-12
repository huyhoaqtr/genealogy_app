import 'package:getx_app/resources/models/user.model.dart';

class Transaction {
  String? sId;
  int? price;
  String? desc;
  String? type;
  String? fund;
  User? creator;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Transaction(
      {this.sId,
      this.price,
      this.desc,
      this.type,
      this.fund,
      this.creator,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Transaction.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    price = json['price'];
    desc = json['desc'];
    type = json['type'];
    fund = json['fund'];
    creator = json['creator'] != null ? User.fromJson(json['creator']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['price'] = price;
    data['desc'] = desc;
    data['type'] = type;
    data['fund'] = fund;
    if (creator != null) {
      data['creator'] = creator!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
