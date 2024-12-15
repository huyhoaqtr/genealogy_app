import 'user.model.dart';

class Web3Transaction {
  String? sId;
  User? user;
  String? tribe;
  String? txHash;
  String? blockId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Web3Transaction(
      {this.sId,
      this.user,
      this.tribe,
      this.txHash,
      this.blockId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Web3Transaction.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    tribe = json['tribe'];
    txHash = json['txHash'];
    blockId = json['blockId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['tribe'] = tribe;
    data['txHash'] = txHash;
    data['blockId'] = blockId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
