import 'dart:ffi';

class Member {
  String name;
  int toChi;
  int nganh;
  int nhanh;
  String hoTen;
  int id;
  List<Vo> vo;
  int thuTu;
  String gioiTinh;
  int doi;
  String img;
  String chucVu;
  int parentId;
  String sinh;
  String mat;
  Double x;
  Double y;

  // Constructor
  Member({
    required this.name,
    required this.toChi,
    required this.nganh,
    required this.nhanh,
    required this.hoTen,
    required this.id,
    required this.vo,
    required this.thuTu,
    required this.gioiTinh,
    required this.doi,
    required this.img,
    required this.chucVu,
    required this.parentId,
    required this.sinh,
    required this.mat,
    required this.x,
    required this.y,
  });

  // fromJson factory constructor
  Member.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        toChi = json['to_chi'],
        nganh = json['nganh'],
        nhanh = json['nhanh'],
        hoTen = json['ho_ten'],
        id = json['id'],
        thuTu = json['thu_tu'],
        gioiTinh = json['gioi_tinh'],
        doi = json['doi'],
        img = json['img'],
        chucVu = json['chuc_vu'],
        parentId = json['parent_id'],
        sinh = json['sinh'],
        mat = json['mat'],
        x = json['position_x'],
        y = json['position_y'],
        // Handling the vo field
        vo = json['vo'] != null
            ? List<Vo>.from(json['vo'].map((v) => Vo.fromJson(v)))
            : [];

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'to_chi': toChi,
      'nganh': nganh,
      'nhanh': nhanh,
      'ho_ten': hoTen,
      'id': id,
      'vo': vo.map((v) => v.toJson()).toList(),
      'thu_tu': thuTu,
      'gioi_tinh': gioiTinh,
      'doi': doi,
      'img': img,
      'chuc_vu': chucVu,
      'parent_id': parentId,
      'sinh': sinh,
      'mat': mat,
      'position_x': x,
      'position_y': y
    };
  }
}

class Vo {
  String? hoTen;
  int? id;
  int? thuTu;
  String? gioiTinh;
  int? doi;
  String? img;
  String? chucVu;
  int? parentId;
  String? sinh;
  String? mat;

  // Constructor
  Vo({
    this.hoTen,
    this.id,
    this.thuTu,
    this.gioiTinh,
    this.doi,
    this.img,
    this.chucVu,
    this.parentId,
    this.sinh,
    this.mat,
  });

  Vo.fromJson(Map<String, dynamic> json)
      : hoTen = json['ho_ten'],
        id = json['id'],
        thuTu = json['thu_tu'],
        gioiTinh = json['gioi_tinh'],
        doi = json['doi'],
        img = json['img'],
        chucVu = json['chuc_vu'],
        parentId = json['parent_id'],
        sinh = json['sinh'],
        mat = json['mat'];

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'ho_ten': hoTen,
      'id': id,
      'thu_tu': thuTu,
      'gioi_tinh': gioiTinh,
      'doi': doi,
      'img': img,
      'chuc_vu': chucVu,
      'parent_id': parentId,
      'sinh': sinh,
      'mat': mat,
    };
  }
}
