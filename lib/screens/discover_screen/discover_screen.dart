import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tinder_clone/constants/constants.dart';
import 'package:tinder_clone/models/user_model.dart';
import 'package:tinder_clone/providers/database_provider.dart';
import 'package:tinder_clone/screens/conversations_screen/conversations_screen.dart';
import 'package:tinder_clone/screens/my_profile_screen/my_profile_screen.dart';
import 'package:tinder_clone/screens/sign_in_screen/sign_in_screen.dart';
import 'package:tinder_clone/screens/user_profile_screen/user_profile_screen.dart';
import 'package:tinder_clone/services/auth_methods.dart';
import 'package:tinder_clone/widgets/show_dialogue_alert.dart';
import 'components/user_card.dart';
import 'components/rotation_3d.dart';

class DiscoverScreen extends StatefulWidget {
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    with SingleTickerProviderStateMixin {
  User currentUser;
  UserModel fetchedUser;
  Stream mystream;

  final double _maxRotation = 20;

  PageController _pageController;

  double _cardWidth;
  double _cardHeight;
  double _normalizedOffset = 0;
  double _prevScrollX = 0;
  bool _isScrolling = false;
  double pageOffset;
  //int _focusedIndex = 0;
  int selectedIndex = 0;

  AnimationController _tweenController;
  Tween<double> _tween;
  Animation<double> _tweenAnim;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0, viewportFraction: 0.8);
    currentUser = FirebaseAuth.instance.currentUser;
    mystream = FirebaseFirestore.instance
        .collection('users')
        .orderBy('addedOn', descending: true)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    _cardHeight = (screenHeight * 0.66).clamp(300.0, 600.0);
    _cardWidth = screenWidth * 0.9;

    return StreamBuilder<QuerySnapshot>(
        stream: mystream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
          if (!snapshots.hasData && snapshots.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Listener(
            onPointerUp: _handlePointerUp,
            child: NotificationListener(
              onNotification: handleScrollNotifications,
              child: Column(
                children: [
                  buildDiscover(snapshots),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      swiperButton(
                        onPressed: () {
                          _pageController.jumpToPage(selectedIndex + 1);
                        },
                        icon: Icons.close,
                        iconGrad: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.2),
                            Colors.white.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      swiperButton(
                          iconGrad: Constants().btnGrad,
                          icon: Icons.message,
                          onPressed: () {
                            currentUser.uid != fetchedUser.uid
                                ? Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                    return ConversationScreen(
                                      receiver: fetchedUser,
                                    );
                                  }))
                                : showAlertDialog(context,
                                    'Uable to send message to yourself', '');
                          }),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  buildDiscover(AsyncSnapshot<QuerySnapshot> snapshots) {
    return Container(
      height: _cardHeight,
      child: PageView.builder(
        physics: BouncingScrollPhysics(),
        onPageChanged: (value) {
          selectedIndex = value;
        },
        controller: _pageController,
        itemCount: snapshots.data.docs.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          DocumentSnapshot document = snapshots.data.docs[selectedIndex];

          fetchedUser = UserModel(
            uid: document.data()['uid'],
            aboutUser: document.data()['about'],
            username: document.data()['username'],
            email: document.data()['email'],
            profilePhoto: document.data()['profile_photo'],
            age: document.data()['age'],
            interets: document.data()['interets'],
          );

          return InkWell(
            onTap: () {
              currentUser.uid != fetchedUser.uid
                  ? Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                      return UserProfileScreen(
                        receiver: fetchedUser,
                      );
                    }))
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MyProfileScreen();
                        },
                      ),
                    );
            },
            child: buildItemRenderer(index, snapshots),
          );
        },
      ),
    );
  }

  Widget buildItemRenderer(int index, AsyncSnapshot<QuerySnapshot> snapshot) {
    DocumentSnapshot document = snapshot.data.docs[index];
    return Container(
      child: Rotation3d(
        rotationY: _normalizedOffset * _maxRotation,
        child: UserCard(
          _normalizedOffset,
          document: document,
          cardWidth: _cardWidth,
          cardHeight: _cardHeight,
        ),
      ),
    );
  }

  bool handleScrollNotifications(Notification notification) {
    //Scroll Update, add to our current offset, but clamp to -1 and 1
    if (notification is ScrollUpdateNotification) {
      if (_isScrolling) {
        double dx = notification.metrics.pixels - _prevScrollX;
        double scrollFactor = .01;
        double newOffset = (_normalizedOffset + dx * scrollFactor);
        _setOffset(newOffset.clamp(-1.0, 1.0));
      }
      _prevScrollX = notification.metrics.pixels;
      //Calculate the index closest to middle
    }
    //Scroll Start
    else if (notification is ScrollStartNotification) {
      _isScrolling = true;
      _prevScrollX = notification.metrics.pixels;
      if (_tween != null) {
        _tweenController.stop();
      }
    }
    return true;
  }

  //If the user has released a pointer, and is currently scrolling, we'll assume they're done scrolling and tween our offset to zero.
  //This is a bit of a hack, we can't be sure this event actually came from the same finger that was scrolling, but should work most of the time.
  void _handlePointerUp(PointerUpEvent event) {
    if (_isScrolling) {
      _isScrolling = false;
      _startOffsetTweenToZero();
    }
  }

  //Helper function, any time we change the offset, we want to rebuild the widget tree, so all the renderers get the new value.
  void _setOffset(double value) {
    setState(() {
      _normalizedOffset = value;
    });
  }

  //Tweens our offset from the current value, to 0
  void _startOffsetTweenToZero() {
    //The first time this runs, setup our controller, tween and animation. All 3 are required to control an active animation.
    int tweenTime = 1000;
    if (_tweenController == null) {
      //Create Controller, which starts/stops the tween, and rebuilds this widget while it's running
      _tweenController = AnimationController(
          vsync: this, duration: Duration(milliseconds: tweenTime));
      //Create Tween, which defines our begin + end values
      _tween = Tween<double>(begin: -1, end: 0);
      //Create Animation, which allows us to access the current tween value and the onUpdate() callback.
      _tweenAnim = _tween.animate(new CurvedAnimation(
          parent: _tweenController, curve: Curves.elasticOut))
        //Set our offset each time the tween fires, triggering a rebuild
        ..addListener(() {
          _setOffset(_tweenAnim.value);
        });
    }
    //Restart the tweenController and inject a new start value into the tween
    _tween.begin = _normalizedOffset;
    _tweenController.reset();
    _tween.end = 0;
    _tweenController.forward();
  }

  Widget swiperButton({iconGrad, icon, onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: iconGrad,
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
