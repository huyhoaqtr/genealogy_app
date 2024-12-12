import 'user.model.dart';

class LoginResponse {
  String? accessToken;
  User? user;

  LoginResponse({this.accessToken, this.user});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}
