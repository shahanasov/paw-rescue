import 'package:cloud_firestore/cloud_firestore.dart';

class AdminModel{
  String name;
  String email;
 String authId;
  AdminModel({required this.email,required this.name,required this.authId});

  //  Convert Firestore document snapshot to UserModel
  static AdminModel fromSnapshot(
   DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return AdminModel(
      authId:snapshot.get('authId')as String,
      email:snapshot.get('email')as String,
     name: snapshot.get('name') as String,
    );
  }

  // Convert UserModel to JSON for storing in Firestore
  Map<String, dynamic> toJson() {
    return {
      'authId':authId,
      'name': name,
      'email': email,
    };
  }
}