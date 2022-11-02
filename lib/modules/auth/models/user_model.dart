import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String fullName;
  String email;
  String phoneNumber;
  int age;
  DateTime createdAt;
  DateTime updatedAt;
  String password;
  String? profileImage;

  UserModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.age,
    required this.createdAt,
    required this.updatedAt,
    required this.password,
    this.profileImage,
  });

  factory UserModel.fromDatabase(
    Map<String, dynamic> data,
  ) {
    return UserModel(
      id: data['id'],
      fullName: data['fullName'],
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      age: data['age'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      password: data['password'],
      profileImage: data['profileImage'],
    );
  }

  Map<String, dynamic> toDatabase() {
    Map<String, dynamic> dataMap = {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'age': age,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'password': password,
      'profileImage': profileImage,
    };
    if (id != null) {
      dataMap['id'] = id;
    }
    return dataMap;
  }
}
