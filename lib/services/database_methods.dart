import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tinder_clone/models/user_model.dart';
import 'package:tinder_clone/providers/image_msg_provider.dart';
import 'package:tinder_clone/services/chat_methods.dart';

class DatabaseMethods {
  //user class
  static UserModel user = UserModel();
  static StorageReference _storageReference;



  static Future addUserDetails(
      {String uid,
      String aboutUser,
      String email,
      String age,
      var passWord,
      String userName,
      Timestamp addedOn,
      String gender,
      List<String> interets,
      profilePhoto}) async {
    user = UserModel(
      uid: uid,
      aboutUser: aboutUser,
      email: email,
      addedOn: addedOn,
      password: passWord,
      profilePhoto: profilePhoto,
      username: userName,
      age: age,
      gender: gender,
      interets: interets,
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(user.toMap(user));
  }

   static Future<String> uploadImageToStorage(File imageFile) async {
    // mention try catch later on

    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');
      StorageUploadTask storageUploadTask =
          _storageReference.putFile(imageFile);
      var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
      // print(url);
      return url;
    } catch (e) {
      return null;
    }
  }

  static void uploadImage({
    @required File image,
    @required String receiverId,
    @required String senderId,
    @required ImageMsgProvider imageUploadProvider,
  }) async {
    final ChatMethods chatMethods = ChatMethods();
    // Set some loading value to db and show it to user
    imageUploadProvider.setToLoading();

    // Get url from the image bucket
    String url = await uploadImageToStorage(image);

    // Hide loading
    imageUploadProvider.setToIdle();

    chatMethods.setImageMsg(url, receiverId, senderId);
  }

  
}
