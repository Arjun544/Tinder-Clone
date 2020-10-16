import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tinder_clone/Utils/Utilities.dart';
import 'package:tinder_clone/enums/user_state.dart';
import 'package:tinder_clone/models/user_model.dart';

class AuthMethods {
  String signInError = 'User is not registered.';
  String signUpError = 'Please use different email.';

  var _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    static final CollectionReference _userCollection =
      _firestore.collection('users');

    static Future<User> getCurrentUser() async {
    User currentUser;
    currentUser = FirebaseAuth.instance.currentUser;
    return currentUser;
  }

   static Future<UserModel> getUserDetails() async {
    User currentUser = await getCurrentUser();

    DocumentSnapshot documentSnapshot =
        await _userCollection.doc(currentUser.uid).get();

    return UserModel.fromMap(documentSnapshot.data());
  }

 static Future<UserModel> getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _userCollection.doc(id).get();
      return UserModel.fromMap(documentSnapshot.data());
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      final user = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      ) ;
      return user;
    }on FirebaseAuthException catch (e) {
      signUpError = 'user not found';
      throw e;
    } catch (e) {
      print(e);
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final user = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return user;
    } on FirebaseAuthException catch (e) {
      signInError = 'user not found';
      throw e;
    } catch (e) {
      print(e);
    }
  }

  Future signOut() async {
    await _auth.signOut();
  }

 static void setUserState({@required String userId, @required UserState userState}) {
    int stateNum = Utils.stateToNum(userState);

    _userCollection.doc(userId).update({
      "state": stateNum,
    });
  }

  Stream<DocumentSnapshot> getUserStream({@required String uid}) =>
      _userCollection.doc(uid).snapshots();
}
