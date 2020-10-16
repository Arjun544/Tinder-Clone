import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tinder_clone/Utils/Utilities.dart';
import 'package:tinder_clone/constants/constants.dart';
import 'package:tinder_clone/providers/database_provider.dart';
import 'package:tinder_clone/screens/home_screen/home_screen.dart';
import 'package:tinder_clone/services/database_methods.dart';
import 'package:tinder_clone/widgets/custom_btn.dart';

class BuildAddPhotos extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final PageController pageController;
  final BuildContext context;
  final ValueNotifier<int> currentPageNotifier;
  final int index;

  const BuildAddPhotos(
      {this.screenHeight,
      this.screenWidth,
      this.pageController,
      this.context,
      this.currentPageNotifier,
      this.index});
  @override
  _BuildAddPhotosState createState() => _BuildAddPhotosState();
}

class _BuildAddPhotosState extends State<BuildAddPhotos> {
  final String prof_Url =
      'https://www.insane.net.au/wp-content/uploads/2019/11/placeholder-profile-male.jpg';

  bool _isLoading = false;

  String nameValue = '';
  String downloadPic = DatabaseProvider.profilePhoto;

  File profilepath;
  File picOnepath;
  File picTwopath;

  StorageReference profile =
      FirebaseStorage.instance.ref().child('profilepics');

  Future<String> uploadimage() async {
    StorageUploadTask storageUploadTask = profile
        .child(DatabaseProvider.emailController.text)
        .putFile(profilepath);
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    String downloadurl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadurl;
  }

  Future<void> _addUserToDb() async {
    setState(() {
      _isLoading = true;
    });
    try {
      downloadPic = profilepath == null ? prof_Url : await uploadimage();
      await DatabaseMethods.addUserDetails(
        uid: FirebaseAuth.instance.currentUser.uid,
        aboutUser: DatabaseProvider.about,
        addedOn: Timestamp.now(),
        email: DatabaseProvider.emailController.text,
        passWord: DatabaseProvider.passController.text,
        age: DatabaseProvider.age,
        userName: DatabaseProvider.nameValue.toString(),
        gender: DatabaseProvider.selectedGender,
        profilePhoto: downloadPic,
        interets: DatabaseProvider.tags,
      );
    } catch (e) {
      print(e);
    }
    setState(() {
      _isLoading = true;
    });
  }

  pickImageDialogue(BuildContext context) {
    return showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text("Select Source"),
              content: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        pickimage(ImageSource.camera);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.camera,
                            size: 30,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Camera',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        pickimage(ImageSource.gallery);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.image,
                            size: 30,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Gallery',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Close',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  Future<File> pickimage(ImageSource imageSource) async {
    Navigator.pop(context);
    File imagefile = await ImagePicker
        // ignore: deprecated_member_use
        .pickImage(source: imageSource);
    setState(() {
      profilepath = File(imagefile.path);
    });
    return Utils.compressImage(imagefile);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
              child: Align(
                alignment: Alignment.topLeft,
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 2,
            child: Text(
              'Add Profile',
              style: TextStyle(fontSize: 40),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 2,
            child: Text(
              'Add at least 2 photos to continue',
              style: TextStyle(fontSize: 20, color: Colors.blueGrey),
            ),
          ),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              InkWell(
                onTap: () {
                  pickImageDialogue(context);
                },
                child: SizedBox(
                  height: screenHeight * 0.25,
                  width: screenWidth * 0.5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: profilepath == null
                        ? Image.network(prof_Url)
                        : Image(
                            image: FileImage(profilepath),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              profilepath == null
                  ? Positioned(
                      bottom: 18,
                      right: 10,
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: Constants().btnGrad,
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Container(
                      height: 30,
                      width: 30,
                    ),
            ],
          ),
          Flexible(
            fit: FlexFit.loose,
            flex: 8,
            child: Container(
              height: widget.screenHeight,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  _imageTile(picOnepath, 1),
                  _imageTile(picTwopath, 2),
                ],
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 4,
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : DefaultButton(
                    press: () async {
                      await _addUserToDb();
                      widget.currentPageNotifier.value = widget.index;
                      Navigator.pushReplacementNamed(
                          context, HomeScreen.routeName);
                    },
                    btnHeight: widget.screenHeight * 0.08,
                    btnWidth: widget.screenWidth * 0.8,
                    text: 'Finish'.toUpperCase(),
                    txtColor: Colors.white,
                    fontSize: 20,
                    btnGradient: Constants().btnGrad,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _imageTile(File imagePath, int index) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        InkWell(
          onTap: () {
            pickImageDialogue(context);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              height: widget.screenHeight * 0.25,
              width: widget.screenWidth * 0.4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: imagePath == null
                    ? Container(
                        height: widget.screenHeight * 0.25,
                        width: widget.screenWidth * 0.4,
                        color: Color(0xFFA9B7E2).withOpacity(0.5),
                      )
                    : Image(
                        image: FileImage(imagePath),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
        ),
        imagePath == null
            ? Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: Constants().btnGrad,
                ),
                child: InkWell(
                  onTap: () {},
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
