import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tinder_clone/constants/constants.dart';
import 'package:tinder_clone/providers/database_provider.dart';
import 'package:tinder_clone/screens/home_screen/home_screen.dart';
import 'package:tinder_clone/screens/sign_up_screen/sign_up_screen.dart';
import 'package:tinder_clone/services/auth_methods.dart';
import 'package:tinder_clone/widgets/custom_btn.dart';
import 'package:tinder_clone/widgets/my_email_Field.dart';
import 'package:tinder_clone/widgets/my_pass_field.dart';
import 'package:tinder_clone/widgets/show_dialogue_alert.dart';

class SignInScreen extends StatefulWidget {
  static const String routeName = 'sign in screen';

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  AuthMethods _authMethods = AuthMethods();

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });
    try {
      dynamic result = await _authMethods.signInWithEmailAndPassword(
          DatabaseProvider.emailController.text.toString(),
          DatabaseProvider.passController.text);

      if (result != null) {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      } else {
        print('please supply valid email.');
      }
    } catch (e) {
      print(e);
      showAlertDialog(
        context,
        AuthMethods().signInError,
        'User not found',
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: Constants().bgGrad),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/tinder.png',
                      height: 50,
                      width: 50,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Shimmer.fromColors(
                      baseColor: Color(0xFFFF655B),
                      highlightColor: Colors.white,
                      child: Text(
                        'Tinder',
                        style: TextStyle(
                            fontSize: 38,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.07),
                Text(
                  "Sign in",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 60,
                      ),
                      MyEmailField(
                        textEditingController: DatabaseProvider.emailController,
                        textInputType: TextInputType.emailAddress,
                        fillColor: Color(0xFFA9B7E2),
                        hintText: 'Enter your email',
                        icon: SvgPicture.asset('assets/Message.svg'),
                        obscure: false,
                      ),
                      SizedBox(height: 30),
                      MyPassField(
                        passwordController: DatabaseProvider.passController,
                        textInputType: TextInputType.number,
                        hintText: 'Enter your password',
                        prefixIcon: SvgPicture.asset('assets/Lock.svg'),
                        obscure: true,
                      ),
                      SizedBox(height: screenHeight * 0.15),
                      _isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : DefaultButton(
                              text: "Sign In",
                              btnHeight: screenHeight * 0.08,
                              btnGradient: Constants().btnGrad,
                              press: () async {
                                if (!_formKey.currentState.validate()) {
                                  return;
                                }
                                _formKey.currentState.save();
                                _signIn();
                              },
                            ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.07),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, SignUpScreen.routeName);
                      },
                      child: Text(
                        'signup'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
