import 'package:flutter/material.dart';
import 'package:tinder_clone/constants/constants.dart';
import 'package:tinder_clone/providers/database_provider.dart';
import 'package:tinder_clone/widgets/custom_btn.dart';

// enum Genders { male, female }

class BuildAddGender extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final PageController pageController;
  final BuildContext context;
  final ValueNotifier<int> currentPageNotifier;
  final int index;
  final Function pageChanged;

  const BuildAddGender(
      {this.screenHeight,
      this.screenWidth,
      this.pageController,
      this.context,
      this.currentPageNotifier,
      this.index,
      this.pageChanged});

  @override
  _BuildAddGenderState createState() => _BuildAddGenderState();
}

class _BuildAddGenderState extends State<BuildAddGender> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
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
          SizedBox(
            height: widget.screenHeight * 0.05,
          ),
          Text(
            "Select a gender",
            style: TextStyle(
              fontSize: 40,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: widget.screenHeight * 0.25,
          ),
          Theme(
            data: Theme.of(context).copyWith(
              unselectedWidgetColor: Colors.grey,
            ),
            child: Column(
              children: [
                ListTile(
                  title: const Text(
                    'Male',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  leading: Radio(
                    activeColor: Colors.green,
                    focusColor: Colors.red,
                    value: 'Male',
                    groupValue: DatabaseProvider.selectedGender,
                    onChanged: (value) {
                      setState(() {
                       DatabaseProvider.selectedGender = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text(
                    'Female',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  leading: Radio(
                    activeColor: Colors.green,
                    value: 'Female',
                    groupValue:DatabaseProvider.selectedGender,
                    onChanged: (value) {
                      setState(() {
                        DatabaseProvider.selectedGender = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: widget.screenHeight * 0.2,
          ),
          DefaultButton(
            press: () {
              setState(() {
                if (DatabaseProvider.selectedGender != null) {
                  widget.currentPageNotifier.value = widget.index;
                  widget.pageChanged(3);
                } else {
                  print('please select gender');
                }
              });
            },
            btnHeight: widget.screenHeight * 0.08,
            btnWidth: widget.screenWidth * 0.8,
            text: 'continue'.toUpperCase(),
            txtColor: Colors.white,
            fontSize: 20,
            btnGradient: DatabaseProvider.selectedGender == null
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
        ],
      ),
    );
  }
}
