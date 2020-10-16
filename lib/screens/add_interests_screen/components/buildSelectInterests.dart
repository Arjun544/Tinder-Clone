import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:tinder_clone/constants/constants.dart';
import 'package:tinder_clone/providers/database_provider.dart';

// ignore: must_be_immutable
class BuildSelectInterets extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final PageController pageController;
  final BuildContext context;
  final ValueNotifier<int> currentPageNotifier;
  final int index;
  final Function pageChanged;

  BuildSelectInterets({
    this.screenHeight,
    this.screenWidth,
    this.pageController,
    this.context,
    this.currentPageNotifier,
    this.index,
    this.pageChanged,
  });

  @override
  _BuildSelectInteretsState createState() => _BuildSelectInteretsState();
}

class _BuildSelectInteretsState extends State<BuildSelectInterets> {
  List<String> options = [
    'News',
    'Entertainment',
    'Politics',
    'Automotive',
    'Sports',
    'Education',
    'Fashion',
    'Travel',
    'Food',
    'Tech',
    'Science',
    'Running',
    'Surfing',
    'Cycling',
    'Comedy',
    'House Parties',
    'Dog lover',
    'Gamer',
    'Hiking',
    'Movies',
    'Cat lover',
    'Music',
    'Writer',
    'Dancing',
    'Outdoors',
    'Gardening',
    'Cricket',
    'Coding',
    'Coffee',
    'Road trips',
    'Instagram',
    'Reading',
    'Blogging',
    'Politics',
  ];

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: myFloatingButton(screenHeight, screenWidth),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 15, bottom: 80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        'Passions',
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Let everyone know what you're passionate about by adding it to your profile.",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueGrey),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ChipsChoice<String>.multiple(
                    value: DatabaseProvider.tags,
                    options: ChipsChoiceOption.listFrom<String, String>(
                      source: options,
                      value: (i, v) => v,
                      label: (i, v) => v,
                    ),
                    onChanged: (val) {
                      setState(() {
                        DatabaseProvider.tags = val;
                      });
                    },
                    isWrapped: true,
                    itemConfig: ChipsChoiceItemConfig(
                      labelStyle: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                      unselectedColor: Colors.blueGrey,
                      selectedColor: Constants.primaryColor,
                      showCheckmark: false,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget myFloatingButton(double screenHeight, double screenWidth) {
    return InkWell(
      onTap: () {
        setState(() {
          if (DatabaseProvider.tags.length >= 5) {
            widget.currentPageNotifier.value = widget.index;
            widget.pageChanged(4);
          } else {
            print('please select more than 3 interets');
          }
        });
      },
      child: Container(
        height: widget.screenHeight * 0.1,
        width: widget.screenWidth * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: DatabaseProvider.tags.length >= 3
              ? Constants().btnGrad
              : LinearGradient(
                  colors: [
                    Color(0xFFA9B7E2).withOpacity(0.8),
                    Color(0xFFA9B7E2).withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'continue'.toUpperCase(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              '(' + '${DatabaseProvider.tags.length}' + '/5' + ')',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
