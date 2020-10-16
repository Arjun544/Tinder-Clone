import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Constants {
  static const btnColor = Color(0xFFD9B372);
  static const secondaryColor = Color(0xFF071930);
  static const primaryColor = Color(0xFFFD297B);

  LinearGradient bgGrad = LinearGradient(
    colors: [
      Color(0xFF223C53),
      Color(0xFF071930),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  LinearGradient iconGrad = LinearGradient(
    colors: [
      Color(0xFFBC9A6F),
      Colors.amberAccent.withOpacity(0.6),
      
    ],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  LinearGradient btnGrad = LinearGradient(
    colors: [
      Color(0xFFFD297B),
      Color(0xFFFF5864),
      Color(0xFFFF655B),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  LinearGradient imgGgrad = LinearGradient(
    colors: [
      Color(0xFF071930).withOpacity(0),
      Color(0xFF071930).withOpacity(0.74),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Form Error
  final RegExp emailValidatorRegExp =
      RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static const String kEmailNullError = "Please Enter your email";
  static const String kInvalidEmailError = "Please Enter Valid Email";
  static const String kPassNullError = "Please Enter your password";
  static const String kShortPassError = "Password is too short";
  static const String kMatchPassError = "Passwords don't match";
  static const String kNamelNullError = "Please Enter your name";

  static const textFieldDecoration = InputDecoration(
    contentPadding: const EdgeInsets.symmetric(vertical: 26.0, horizontal: 10),
    filled: true,
    fillColor: Color(0xFFA9B7E2),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: const BorderRadius.all(
        const Radius.circular(20.0),
      ),
    ),
    hintText: "",
    hintStyle: TextStyle(
      color: Colors.black,
      fontSize: 17,
    ),
    floatingLabelBehavior: FloatingLabelBehavior.always,
    suffixIcon: Icon(Icons.lock),
  );
}
