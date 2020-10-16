import 'package:flutter/material.dart';
import 'package:tinder_clone/models/user_model.dart';
import 'package:tinder_clone/screens/chats_screen/chats_screen.dart';
import 'package:tinder_clone/screens/discover_screen/discover_screen.dart';
import 'package:tinder_clone/screens/my_profile_screen/components/profle_row.dart';
import 'package:tinder_clone/screens/sign_in_screen/sign_in_screen.dart';
import 'package:tinder_clone/services/auth_methods.dart';

class MyProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: FutureBuilder(
          future: AuthMethods.getUserDetails(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserModel user = snapshot.data;
              return Column(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.profilePhoto),
                    radius: 60,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    user.username,
                    style: TextStyle(fontSize: 26, color: Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60),
                        ),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 30, right: 30, top: 50),
                        child: Column(
                          children: [
                            profileRow(
                              Icons.person_outline_rounded,
                              'Edit profile',
                              () {},
                            ),
                            profileRow(
                              Icons.chat_outlined,
                              'Start a chat',
                              () {},
                            ),
                            profileRow(
                              Icons.group_outlined,
                              'Messages',
                              () {},
                            ),
                            profileRow(
                              Icons.logout,
                              'Logout',
                              () {
                                AuthMethods().signOut();
                                Navigator.pushNamed(
                                    context, SignInScreen.routeName);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
