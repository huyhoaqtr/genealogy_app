import 'user.model.dart';

class Event {
  String? sId;
  User? user;
  String? title;
  String? desc;
  String? startTime;
  String? startDate;
  String? tribe;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Event(
      {this.sId,
      this.user,
      this.title,
      this.desc,
      this.startTime,
      this.startDate,
      this.tribe,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Event.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    title = json['title'];
    desc = json['desc'];
    startTime = json['startTime'];
    startDate = json['startDate'];
    tribe = json['tribe'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['title'] = this.title;
    data['desc'] = this.desc;
    data['startTime'] = this.startTime;
    data['startDate'] = this.startDate;
    data['tribe'] = this.tribe;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
