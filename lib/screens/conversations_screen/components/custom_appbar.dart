import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinder_clone/constants/constants.dart';
import 'package:tinder_clone/models/user_model.dart';
import 'package:tinder_clone/screens/chats_screen/components/online_indicator.dart';
import 'package:tinder_clone/screens/user_profile_screen/user_profile_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final UserModel receiver;

  const CustomAppBar({this.receiver});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return UserProfileScreen(
            receiver: receiver,
          );
        }));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: Colors.blueGrey.withOpacity(0.2),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(receiver.profilePhoto),
              maxRadius: 30,
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  toBeginningOfSentenceCase(receiver.username),
                  style: TextStyle(
                      fontSize: 24,
                      color: Constants.secondaryColor,
                      fontWeight: FontWeight.w600),
                ),
                OnlineIndicator(uid: receiver.uid, isText: true),
              ],
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.phone,
                    size: 30,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  final Size preferredSize = const Size.fromHeight(80);
}
