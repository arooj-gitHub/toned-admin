import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uId, name, email;
  int status;
  DateTime? createAt;
  bool isAdmin;

  UserModel({
    required this.uId,
    required this.email,
    required this.name,
    required this.status,
    required this.createAt,
    required this.isAdmin,
  });

  factory UserModel.fromJson(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data()! as Map<String, dynamic>;
    return UserModel(
      uId: doc.id,
      email: map['email'] ?? '',
      name: map['username'] ?? "",
      status: map['status'],
      createAt: map['CreateAt'],
      isAdmin: map['isAdmin'] ?? false,
    );
  }
}
