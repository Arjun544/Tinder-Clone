import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tinder_clone/constants/constants.dart';
import 'package:tinder_clone/providers/database_provider.dart';
import 'package:tinder_clone/screens/add_interests_screen/add_interests_screen.dart';
import 'package:tinder_clone/screens/sign_in_screen/sign_in_screen.dart';
import 'package:tinder_clone/services/auth_methods.dart';
import 'package:tinder_clone/widgets/custom_btn.dart';
import 'package:tinder_clone/widgets/my_email_Field.dart';
import 'package:tinder_clone/widgets/my_pass_field.dart';
import 'package:tinder_clone/widgets/show_dialogue_alert.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = 'sign up screen';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final List<String> errors = [];
  bool _isloading = false;

  AuthMethods _authMethods = AuthMethods();

  Future<void> _signUp() async {
    setState(() {
      _isloading = true;
    });
    try {
      dynamic result = await _authMethods.signUpWithEmailAndPassword(
          DatabaseProvider.emailController.text,
          DatabaseProvider.passController.text);
      if (result != null) {
        Navigator.pushReplacementNamed(context, AddInterestsScreen.routeName);
      }
    } catch (e) {
      print(e);
      showAlertDialog(
        context,
        AuthMethods().signUpError,
        'Email is already registered',
      );
    }
    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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
                  "Sign up",
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
                        fillColor: Color(0xFFA9B7E2),
                        textInputType: TextInputType.emailAddress,
                        hintText: 'Enter your email',
                        icon: SvgPicture.asset('assets/Message.svg'),
                        obscure: false,
                      ),
                      SizedBox(height: 30),
                      MyPassField(
                        obscure: true,
                        passwordController: DatabaseProvider.passController,
                        textInputType: TextInputType.number,
                        hintText: 'Enter your password',
                        prefixIcon: SvgPicture.asset('assets/Lock.svg'),
                      ),
                      SizedBox(height: screenHeight * 0.15),
                      _isloading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : DefaultButton(
                              text: "Sign Up",
                              btnHeight: screenHeight * 0.08,
                              btnGradient: Constants().btnGrad,
                              press: () async {
                                if (!_formKey.currentState.validate()) {
                                  return;
                                }
                                _formKey.currentState.save();
                                _signUp();
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
                      "Already have an account?",
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
                        Navigator.pushNamed(context, SignInScreen.routeName);
                      },
                      child: Text(
                        'signin'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
