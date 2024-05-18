import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeModel {
  String? id;
  String? name;
  String? email;
  String? passWord;
  Timestamp? createdAt;
  EmployeeModel({
    this.id,
    this.name,
    this.email,
    this.passWord,
    this.createdAt,
  });
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    if (id != null) {
      result.addAll({'id': id});
    }
    if (name != null) {
      result.addAll({'name': name});
    }
    if (email != null) {
      result.addAll({'email': email});
    }
    if (passWord != null) {
      result.addAll({'passWord': passWord});
    }
    if (createdAt != null) {
      result.addAll({'createdAt': createdAt});
    }
    return result;
  }

  factory EmployeeModel.fromMap(Map<String, dynamic> map) {
    return EmployeeModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      passWord: map['passWord'],
      createdAt: map['createdAt'],
    );
  }
}
