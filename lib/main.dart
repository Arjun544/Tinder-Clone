import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_clone/providers/database_provider.dart';
import 'package:tinder_clone/providers/image_msg_provider.dart';
import 'package:tinder_clone/providers/user_provider.dart';
import 'package:tinder_clone/screens/add_interests_screen/add_interests_screen.dart';
import 'package:tinder_clone/screens/conversations_screen/conversations_screen.dart';
import 'package:tinder_clone/screens/home_screen/home_screen.dart';
import 'package:tinder_clone/screens/root_screen.dart';
import 'package:tinder_clone/screens/sign_in_screen/sign_in_screen.dart';

import 'screens/sign_up_screen/sign_up_screen.dart';

void main() async {
  Paint.enableDithering = true;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DatabaseProvider>(
          create: (context) => DatabaseProvider(),
        ),
        ChangeNotifierProvider<ImageMsgProvider>(
          create: (context) => ImageMsgProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Tinder Clone',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          unselectedWidgetColor: Colors.white,
        ),
        home: RootScreen(),
        routes: {
          SignInScreen.routeName: (ctx) => SignInScreen(),
          SignUpScreen.routeName: (ctx) => SignUpScreen(),
          AddInterestsScreen.routeName: (ctx) => AddInterestsScreen(),
          HomeScreen.routeName: (ctx) => HomeScreen(),
          ConversationScreen.routeName: (ctx) => ConversationScreen(),
        },
      ),
    );
  }
}
