class GenealogyModel {
  String? sId;
  List<PageData>? data;
  String? tribe;
  String? createdAt;
  String? updatedAt;
  int? iV;

  GenealogyModel(
      {this.sId,
      this.data,
      this.tribe,
      this.createdAt,
      this.updatedAt,
      this.iV});

  GenealogyModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['data'] != null) {
      data = <PageData>[];
      json['data'].forEach((v) {
        data!.add(PageData.fromJson(v));
      });
    }
    tribe = json['tribe'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['tribe'] = tribe;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class PageData {
  bool? isDelete;
  String? text;
  String? title;
  String? sId;

  PageData({this.isDelete, this.text, this.title, this.sId});

  PageData.fromJson(Map<String, dynamic> json) {
    isDelete = json['isDelete'];
    text = json['text'];
    title = json['title'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isDelete'] = isDelete;
    data['text'] = text;
    data['title'] = title;
    data['_id'] = sId;
    return data;
  }
}
