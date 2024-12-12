class Province {
  String? name;
  int? code;
  String? codename;
  String? divisionType;
  int? phoneCode;
  List<Districts>? districts;

  Province(
      {this.name,
      this.code,
      this.codename,
      this.divisionType,
      this.phoneCode,
      this.districts});

  Province.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    codename = json['codename'];
    divisionType = json['division_type'];
    phoneCode = json['phone_code'];
    if (json['districts'] != null) {
      districts = <Districts>[];
      json['districts'].forEach((v) {
        districts!.add(Districts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    data['codename'] = codename;
    data['division_type'] = divisionType;
    data['phone_code'] = phoneCode;
    if (districts != null) {
      data['districts'] = districts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Districts {
  String? name;
  int? code;
  String? codename;
  String? divisionType;
  String? shortCodename;
  List<Wards>? wards;

  Districts(
      {this.name,
      this.code,
      this.codename,
      this.divisionType,
      this.shortCodename,
      this.wards});

  Districts.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    codename = json['codename'];
    divisionType = json['division_type'];
    shortCodename = json['short_codename'];
    if (json['wards'] != null) {
      wards = <Wards>[];
      json['wards'].forEach((v) {
        wards!.add(Wards.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    data['codename'] = codename;
    data['division_type'] = divisionType;
    data['short_codename'] = shortCodename;
    if (wards != null) {
      data['wards'] = wards!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Wards {
  String? name;
  int? code;
  String? codename;
  String? divisionType;
  String? shortCodename;

  Wards(
      {this.name,
      this.code,
      this.codename,
      this.divisionType,
      this.shortCodename});

  Wards.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    codename = json['codename'];
    divisionType = json['division_type'];
    shortCodename = json['short_codename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    data['codename'] = codename;
    data['division_type'] = divisionType;
    data['short_codename'] = shortCodename;
    return data;
  }
}
