import 'user_model.dart';

class LoginResponseModel {
  final String? access;
  final String? refresh;
  final UserModel? user;

  LoginResponseModel({this.access, this.refresh, this.user});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        access: json['access'],
        refresh: json['refresh'],
        user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      );
}
