import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tinder_clone/screens/chats_screen/components/online_indicator.dart';

import 'build_user_name.dart';

Widget buildUserDetails(receiver, context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildUserName(receiver, context),
        SizedBox(
          height: 10,
        ),
        OnlineIndicator(uid: receiver.uid, isText: true),
        SizedBox(
          height: 30,
        ),
        Text(
          'About me :',
          style: TextStyle(
              fontSize: 24, color: Colors.white, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          receiver.aboutUser,
          style: TextStyle(fontSize: 20, color: Colors.white70),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          'Interests :',
          style: TextStyle(
              fontSize: 24, color: Colors.white, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 10,
        ),
        GridView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: receiver.interets.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: 2),
            itemBuilder: (context, index) {
              return Flex(
                direction: Axis.horizontal,
                children: [
                  Flexible(
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(right: 10, bottom: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.primaries[
                                Random().nextInt(Colors.primaries.length)]
                            .withOpacity(0.5),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Text(
                        receiver.interets[index],
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
        SizedBox(
          height: 30,
        ),
        Text(
          'Photos :',
          style: TextStyle(
              fontSize: 24, color: Colors.white, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    ),
  );
}
