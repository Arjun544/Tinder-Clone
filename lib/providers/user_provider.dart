import 'package:flutter/material.dart';
import 'package:tinder_clone/models/user_model.dart';
import 'package:tinder_clone/services/auth_methods.dart';

class UserProvider with ChangeNotifier {
  UserModel _user;

  UserModel get getUser => _user;

  Future<void> refreshUser() async {
    UserModel user = await AuthMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }

}