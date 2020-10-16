import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tinder_clone/constants/constants.dart';
import 'package:tinder_clone/providers/database_provider.dart';
import 'package:tinder_clone/widgets/custom_btn.dart';

class BuildAboutMe extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final PageController pageController;
  final ValueNotifier<int> currentPageNotifier;
  final int index;
  final Function pageChanged;

  const BuildAboutMe({
    this.screenWidth,
    this.screenHeight,
    this.pageController,
    this.currentPageNotifier,
    this.index,
    this.pageChanged,
  });

  @override
  _BuildAboutMeState createState() => _BuildAboutMeState();
}

class _BuildAboutMeState extends State<BuildAboutMe> {
  TextEditingController aboutEditingController = TextEditingController();

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
              'Tell about yourself',
              style: TextStyle(fontSize: 40),
            ),
          ),
          TextFormField(
            controller: aboutEditingController,
            onChanged: (val) {
              setState(() {
                DatabaseProvider.about = val;
              });
            },
            keyboardType: TextInputType.text,
            maxLines: 10,
            cursorWidth: 3,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 26.0, horizontal: 10),
              filled: true,
              fillColor: Color(0xFFA9B7E2).withOpacity(0.5),
              border: new OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: const BorderRadius.all(
                  const Radius.circular(20.0),
                ),
              ),
              hintText: 'Write about you',
              suffix: Text(aboutEditingController.text.length.toString() + '/ 20 words'),
              suffixStyle: TextStyle(color: Colors.grey, fontSize: 16),
              hintStyle: TextStyle(
                color: Colors.black,
                fontSize: 17,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: DefaultButton(
              press: () {
                FocusScope.of(context).requestFocus(FocusNode());
                widget.currentPageNotifier.value = widget.index;
                DatabaseProvider.about.length <= 20
                    ? Container()
                    : widget.pageChanged(2);
              },
              btnHeight: widget.screenHeight * 0.08,
              btnWidth: widget.screenWidth * 0.8,
              text: 'continue'.toUpperCase(),
              txtColor: Colors.white,
              fontSize: 20,
              btnGradient: DatabaseProvider.about.length <= 20
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
