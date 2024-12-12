import 'package:getx_app/resources/models/transaction.model.dart';
import 'package:getx_app/resources/models/user.model.dart';

class Fund {
  String? sId;
  String? title;
  String? desc;
  int? amount;
  User? creator;
  String? tribe;
  List<Transaction>? transactions;
  String? createdAt;
  String? updatedAt;
  int? iV;
  int? totalDeposit;
  int? totalWithdraw;

  Fund(
      {this.sId,
      this.title,
      this.desc,
      this.amount,
      this.creator,
      this.tribe,
      this.transactions,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.totalDeposit,
      this.totalWithdraw});

  Fund.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    desc = json['desc'];
    amount = json['amount'];
    creator = json['creator'] != null ? User.fromJson(json['creator']) : null;
    tribe = json['tribe'];
    if (json['transactions'] != null) {
      transactions = <Transaction>[];
      json['transactions'].forEach((v) {
        transactions!.add(Transaction.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    totalDeposit = json['totalDeposit'];
    totalWithdraw = json['totalWithdraw'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['title'] = title;
    data['desc'] = desc;
    data['amount'] = amount;
    if (creator != null) {
      data['creator'] = creator!.toJson();
    }
    data['tribe'] = tribe;
    if (transactions != null) {
      data['transactions'] = transactions!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['totalDeposit'] = totalDeposit;
    data['totalWithdraw'] = totalWithdraw;
    return data;
  }
}
