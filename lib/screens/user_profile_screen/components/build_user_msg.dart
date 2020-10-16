import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tinder_clone/constants/constants.dart';
import 'package:tinder_clone/screens/conversations_screen/conversations_screen.dart';

Widget buildUserMsg(receiver, context, screenHeight) {
  return Positioned(
    bottom: screenHeight / 4.4,
    right: 60,
    child: InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ConversationScreen(
            receiver: receiver,
          );
        }));
      },
      child: Icon(
        Icons.message,
        color: Colors.white,
        size: 35,
      ),
    ),
  );
}
