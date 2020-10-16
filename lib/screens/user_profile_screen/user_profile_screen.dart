import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tinder_clone/constants/constants.dart';
import 'package:tinder_clone/models/user_model.dart';
import 'package:tinder_clone/screens/user_profile_screen/components/build_user_details.dart';

class UserProfileScreen extends StatelessWidget {
  final UserModel receiver;

  const UserProfileScreen({this.receiver});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          Container(
            alignment: Alignment.topRight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(receiver.profilePhoto),
                fit: BoxFit.cover,
              ),
            ),
            child: IconButton(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              icon: Icon(
                Icons.close_rounded,
                size: 40,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.1,
            maxChildSize: 0.6,
            builder: (BuildContext context, ScrollController scrollController) {
              return ClipRRect(
                child: Container(
                  margin: EdgeInsets.only( top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      color: Constants.secondaryColor.withOpacity(0.5)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 5,
                      sigmaY: 5,
                    ),
                    child: Container(
                      margin: EdgeInsets.only(left: 20, right: 0, top: 30),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.0),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: [
                            Transform.rotate(
                              angle: 89.5,
                              child: Icon(
                                Icons.arrow_back_ios_sharp,
                                color: Colors.white,
                              ),
                            ),
                            buildUserDetails(receiver, context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ));
  }
}
