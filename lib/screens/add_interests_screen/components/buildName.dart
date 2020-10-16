import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tinder_clone/constants/constants.dart';
import 'package:tinder_clone/providers/database_provider.dart';
import 'package:tinder_clone/widgets/custom_btn.dart';
import 'package:tinder_clone/widgets/my_email_Field.dart';

class BuildNameWidget extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final PageController pageController;
  final ValueNotifier<int> currentPageNotifier;
  final int index;
  final Function pageChanged;

  const BuildNameWidget({
    this.screenWidth,
    this.screenHeight,
    this.pageController,
    this.currentPageNotifier,
    this.index,
    this.pageChanged,
  });

  @override
  _BuildNameWidgetState createState() => _BuildNameWidgetState();
}

class _BuildNameWidgetState extends State<BuildNameWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: GestureDetector(
              onTap: () {
                widget.pageController.previousPage(
                  duration: Duration(milliseconds: 100),
                  curve: Curves.linear,
                );
                return false;
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.blueGrey,
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: Text(
              'My first \nname is',
              style: TextStyle(fontSize: 40),
            ),
          ),
          Column(
            children: [
              MyEmailField(
                onChanged: (val) {
                  setState(() {
                    DatabaseProvider.nameValue = val;
                  });
                },
                fillColor: Color(0xFFA9B7E2).withOpacity(0.5),
                hintText: 'Enter username',
                icon: SvgPicture.asset('assets/Profile.svg'),
                obscure: false,
              ),
              SizedBox(
                height: 20,
              ),
              MyEmailField(
                textInputType: TextInputType.number,
                onChanged: (val) {
                  setState(() {
                    DatabaseProvider.age = val;
                  });
                },
                fillColor: Color(0xFFA9B7E2).withOpacity(0.5),
                hintText: 'Enter age',
                icon: SvgPicture.asset('assets/Profile.svg'),
                obscure: false,
                lengthLimitingTextInputFormatter: [
                  LengthLimitingTextInputFormatter(2),
                ],
              ),
            ],
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: DefaultButton(
              press: () {
                FocusScope.of(context).requestFocus(FocusNode());
                widget.currentPageNotifier.value = widget.index;
                DatabaseProvider.nameValue.length <= 0 &&
                        DatabaseProvider.age.length >= 1
                    ? Container()
                    : widget.pageChanged(1);
              },
              btnHeight: widget.screenHeight * 0.08,
              btnWidth: widget.screenWidth * 0.8,
              text: 'continue'.toUpperCase(),
              txtColor: Colors.white,
              fontSize: 20,
              btnGradient: DatabaseProvider.nameValue.length <= 0 &&
                      DatabaseProvider.age.length >= 1
                  ? LinearGradient(
                      colors: [
                        Color(0xFFA9B7E2).withOpacity(0.4),
                        Color(0xFFA9B7E2).withOpacity(0.4),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : Constants().btnGrad,
            ),
          ),
        ],
      ),
    );
  }
}
