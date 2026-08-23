import '../api/api_constant.dart';

class UserModel {
  final int? id;
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? role;
  final String? phone;
  final String? bio;
  final String? avatar;
  final bool? isApprovedTeacher;
  final String? approvedAt;
  final bool? isActive;
  final String? dateJoined;
  final String? createdAt;

  UserModel({
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.role,
    this.phone,
    this.bio,
    this.avatar,
    this.isApprovedTeacher,
    this.approvedAt,
    this.isActive,
    this.dateJoined,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        role: json['role'],
        phone: json['phone'],
        bio: json['bio'],
        avatar: ApiConstant.resolveMediaUrl(json['avatar']),
        isApprovedTeacher: json['is_approved_teacher'],
        approvedAt: json['approved_at'],
        isActive: json['is_active'],
        dateJoined: json['date_joined'],
        createdAt: json['created_at'],
      );

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'role': role,
        'phone': phone,
        'bio': bio,
      };

  String get fullName {
    final first = firstName ?? '';
    final last = lastName ?? '';
    final name = '$first $last'.trim();
    return name.isEmpty ? (username ?? 'User') : name;
  }

  bool get isStudent => role == 'student';
  bool get isTeacher => role == 'teacher';
  bool get isAdmin => role == 'admin';
}
