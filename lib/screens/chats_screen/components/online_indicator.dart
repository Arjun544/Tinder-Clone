import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tinder_clone/Utils/Utilities.dart';
import 'package:tinder_clone/enums/user_state.dart';
import 'package:tinder_clone/models/user_model.dart';
import 'package:tinder_clone/services/auth_methods.dart';

class OnlineIndicator extends StatelessWidget {
  final String uid;
  final bool isText;
  final AuthMethods _authMethods = AuthMethods();

  OnlineIndicator({
    @required this.uid,
    @required this.isText,
  });

  @override
  Widget build(BuildContext context) {
    getColor(int state) {
      switch (Utils.numToState(state)) {
        case UserState.Offline:
          return Colors.red;
        case UserState.Online:
          return Colors.green;
        default:
          return Colors.orange;
      }
    }

    getText(int state) {
      switch (Utils.numToState(state)) {
        case UserState.Offline:
          return Text(
            'offline',
            style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
          );
        case UserState.Online:
          return Text(
            'online',
            style: TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold),
          );
        default:
          return Text(
            'offline',
            style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
          );
      }
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: _authMethods.getUserStream(
        uid: uid,
      ),
      builder: (context, snapshot) {
        UserModel user;

        if (snapshot.hasData && snapshot.data.data != null) {
          user = UserModel.fromMap(snapshot.data.data());
        }

        return isText == true
            ? getText(user?.state)
            : Container(
                height: 15,
                width: 15,
                margin: EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: getColor(user?.state),
                ),
              );
      },
    );
  }
}
