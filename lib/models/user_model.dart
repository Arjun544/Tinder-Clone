import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String aboutUser;
  String password;
  String email;
  String username;
  String status;
  int state;
  String profilePhoto;
  String age;
  Timestamp addedOn;
  String gender;
  List<dynamic> interets;

  UserModel({
    this.uid,
    this.aboutUser,
    this.password,
    this.email,
    this.username,
    this.addedOn,
    this.status,
    this.state,
    this.profilePhoto,
    this.age,
    this.gender,
    this.interets,
  });

  Map toMap(UserModel userModel) {
    var data = Map<String, dynamic>();
    data['uid'] = userModel.uid;
    data['about'] = userModel.aboutUser;
    data['addedOn'] = userModel.addedOn;
    data['password'] = userModel.password;
    data['email'] = userModel.email;
    data['username'] = userModel.username;
    data["status"] = userModel.status;
    data["state"] = userModel.state;
    data["profile_photo"] = userModel.profilePhoto;
    data['age'] = userModel.age;
    data['gender'] = userModel.gender;
    data['interets'] = userModel.interets;
    return data;
  }

  // Named constructor
  UserModel.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.aboutUser = mapData['about'];
    this.addedOn = mapData['addedOn'];
    this.password = mapData['password'];
    this.email = mapData['email'];
    this.username = mapData['username'];
    this.status = mapData['status'];
    this.state = mapData['state'];
    this.profilePhoto = mapData['profile_photo'];
    this.age = mapData['age'];
    this.gender = mapData['gender'];
    this.interets = mapData['interets'];
  }
}
