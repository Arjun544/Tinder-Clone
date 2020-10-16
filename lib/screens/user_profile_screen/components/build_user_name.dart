import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinder_clone/screens/conversations_screen/conversations_screen.dart';

Widget buildUserName(receiver, context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        toBeginningOfSentenceCase(
          receiver.username + ', ',
        ),
        style: TextStyle(
            fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      Text(
        receiver.age,
        style: TextStyle(
            fontSize: 30,
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.normal),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
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
            ],
          ),
        ),
      ),
    ],
  );
}
