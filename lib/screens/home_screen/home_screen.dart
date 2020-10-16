import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tinder_clone/constants/constants.dart';
import 'package:tinder_clone/enums/user_state.dart';
import 'package:tinder_clone/providers/user_provider.dart';
import 'package:tinder_clone/screens/chats_screen/chats_screen.dart';
import 'package:tinder_clone/screens/discover_screen/discover_screen.dart';
import 'package:tinder_clone/screens/my_profile_screen/my_profile_screen.dart';
import 'package:tinder_clone/services/auth_methods.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'trending screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController _tabController;
  User currentUser;
  UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    _tabController = TabController(initialIndex: 1, length: 3, vsync: this);

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshUser();

      AuthMethods.setUserState(
        userId: userProvider.getUser.uid,
        userState: UserState.Online,
      );
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String currentUserId =
        (userProvider != null && userProvider.getUser != null)
            ? userProvider.getUser.uid
            : "";

    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null
            ? AuthMethods.setUserState(
                userId: currentUserId, userState: UserState.Online)
            : print("resume state");
        break;
      case AppLifecycleState.inactive:
        currentUserId != null
            ? AuthMethods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("inactive state");
        break;
      case AppLifecycleState.paused:
        currentUserId != null
            ? AuthMethods.setUserState(
                userId: currentUserId, userState: UserState.Waiting)
            : print("paused state");
        break;
      case AppLifecycleState.detached:
        currentUserId != null
            ? AuthMethods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("detached state");
        break;
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(gradient: Constants().bgGrad),
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  // give the tab bar a height [can change hheight to preferred height]
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(
                        25.0,
                      ),
                    ),
                    child: TabBar(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      // give the indicator a decoration (color and border radius)
                      indicator: ShapeDecoration(
                        shape: CircleBorder(
                          side: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        gradient: Constants().btnGrad,
                        shadows: [
                          new BoxShadow(
                            color: Color(0xFFFD297B).withOpacity(0.5),
                            blurRadius: 10,
                            offset: Offset(-2, 2),
                          ),
                        ],
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      tabs: [
                        // first tab [you can add an icon using the icon property]
                        Tab(
                          icon: SvgPicture.asset(
                            'assets/Profile.svg',
                            height: 35,
                            color: Colors.white,
                          ),
                        ),

                        // second tab [you can add an icon using the icon property]
                        Tab(
                          icon: SvgPicture.asset(
                            'assets/Discovery.svg',
                            height: 35,
                            color: Colors.white,
                          ),
                        ),
                        Tab(
                          icon: SvgPicture.asset(
                            'assets/Chat.svg',
                            height: 35,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // tab bar view here
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        MyProfileScreen(),
                        DiscoverScreen(),
                        ChatsScreen(
                          userId: currentUser.uid,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
