import 'package:flutter/material.dart';

class DatabaseProvider with ChangeNotifier {
  static String nameValue = '';
  static String about = '';
  static String selectedGender;
  static List<String> tags = [];
  static String age = '';
  static String profilePhoto;
  static TextEditingController emailController = TextEditingController();
  static TextEditingController passController = TextEditingController();
}
