import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_view_indicators/page_view_indicators.dart';
import 'package:tinder_clone/constants/constants.dart';
import 'package:tinder_clone/providers/database_provider.dart';
import 'package:tinder_clone/screens/add_interests_screen/components/add_about_me.dart';
import 'package:tinder_clone/screens/add_interests_screen/components/buildAddGender.dart';
import 'package:tinder_clone/screens/add_interests_screen/components/buildName.dart';
import 'package:tinder_clone/screens/add_interests_screen/components/buildPhotos.dart';
import 'package:tinder_clone/screens/add_interests_screen/components/buildSelectInterests.dart';

class AddInterestsScreen extends StatefulWidget {
  static const String routeName = 'add interests screen';

  @override
  _AddInterestsScreenState createState() => _AddInterestsScreenState();
}

class _AddInterestsScreenState extends State<AddInterestsScreen> {
  TextEditingController nameEditingController = TextEditingController();

  List<String> tags = DatabaseProvider.tags;

  int index = 0;
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  final _currentPageNotifier = ValueNotifier<int>(0);

  DateTime selectedDate = DateTime.now();

  String formattedDateTime = DateFormat("hh:mm a").format(DateTime.now());

  int noOfTags;

  void pageChanged(int index) {
    setState(() {
      // use this to animate to the page
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 100), curve: Curves.ease);
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    nameEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressPageIndicator(
              itemCount: 5,
              currentPageNotifier: _currentPageNotifier,
              progressColor: Constants.primaryColor,
              backgroundColor: Colors.white,
              width: screenWidth,
              height: 10,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
                child: PageView(
                  controller: pageController,
                  onPageChanged: (index) {
                    _currentPageNotifier.value = index;
                    pageChanged(index);
                  },
                  children: [
                    BuildNameWidget(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      index: index,
                      currentPageNotifier: _currentPageNotifier,
                      pageChanged: pageChanged,
                      pageController: pageController,
                    ),
                    BuildAboutMe(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      index: index,
                      currentPageNotifier: _currentPageNotifier,
                      pageChanged: pageChanged,
                      pageController: pageController,
                    ),
                    BuildAddGender(
                        context: context,
                        currentPageNotifier: _currentPageNotifier,
                        index: index,
                        pageChanged: pageChanged,
                        pageController: pageController,
                        screenHeight: screenHeight,
                        screenWidth: screenWidth),
                    BuildSelectInterets(
                      context: context,
                      currentPageNotifier: _currentPageNotifier,
                      index: index,
                      pageChanged: pageChanged,
                      pageController: pageController,
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                    ),
                    BuildAddPhotos(
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      pageController: pageController,
                      context: context,
                      currentPageNotifier: _currentPageNotifier,
                      index: index,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
