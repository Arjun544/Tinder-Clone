import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinder_clone/screens/chats_screen/components/online_indicator.dart';

class UserCard extends StatelessWidget {
  final double offset;
  final double cardWidth;
  final double cardHeight;
  final DocumentSnapshot document;

  const UserCard(
    this.offset, {
    Key key,
    this.cardWidth = 250,
    this.cardHeight,
    this.document,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.center,
        children: <Widget>[_buildUserImage(), _buildUserData()],
      ),
    );
  }

  Widget _buildUserImage() {
    double maxParallax = 30;
    double globalOffset = offset * maxParallax * 2;
    double cardPadding = 5;
    double containerWidth = cardWidth - cardPadding;

    return Container(
      height: cardHeight,
      width: containerWidth,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _buildPositionedLayer(document.data()['profile_photo'],
              containerWidth * .8, maxParallax * .2, globalOffset)
        ],
      ),
    );
  }

  Widget _buildUserData() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 50, left: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            // The sized box mock the space of the city image
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  toBeginningOfSentenceCase(
                    document.data()['username'] + ', ',
                  ),
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  document.data()['age'],
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
            OnlineIndicator(uid: document.data()['uid'], isText: true),
          ],
        ));
  }

  Widget _buildPositionedLayer(
      String path, double width, double maxOffset, double globalOffset) {
    double cardPadding = 10;
    double layerWidth = cardWidth - cardPadding;
    return Positioned(
        bottom: 30,
        top: 30,
        left: ((layerWidth * .5) - (width / 2) - offset * maxOffset) +
            globalOffset,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.network(
            path,
            fit: BoxFit.cover,
            width: width,
            height: 500,
          ),
        ));
  }
}
