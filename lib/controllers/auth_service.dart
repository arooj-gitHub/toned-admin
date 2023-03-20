import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:toned_australia/app_router.dart';
import 'package:toned_australia/models/user_model.dart';
import 'package:toned_australia/services/navigation_service.dart';

import '../locator.dart';

class AuthService extends ChangeNotifier {
  final NavigationService _navigationService = locator<NavigationService>();
  Logger logger = Logger();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? currentUser;

  Stream<User?> get user {
    return _auth.authStateChanges().map((User? user) {
      return user;
    });
  }

  Future<User?> signInUserWithEmail(String email, password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        await getUserInfo(credential.user!);
        logger.i('user -> ${credential.user!.uid}');
      }
      return credential.user;
    } catch (e) {
      EasyLoading.showError(e.toString());
      print(e);
    }
    return null;
  }

  Future sendChangePasswordLink(String email) async {
    try {
      EasyLoading.show(status: 'Loading...');
      await _auth.sendPasswordResetEmail(email: email);
      EasyLoading.dismiss();
      EasyLoading.showSuccess('Email sent');
      _navigationService.goBack();
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Something went wrong');
      logger.e(e);
    }
  }

  Future<void> getUserInfo(User user) async {
    try {
      var doc = await _firestore.collection('user').doc(user.uid).get();
      print("user id");
      print(user.uid);
      if (doc.exists) {
        if (doc.get("isAdmin")) {
          currentUser = UserModel.fromJson(doc);
          logger.wtf('currentUser -> ${currentUser!.email}');
          _navigationService.navigateReplace(AppRoute.mainScreen);
        } else {
          EasyLoading.showError('This account not belong to Admin');
        }
      }
    } catch (e) {
      EasyLoading.showError(e.toString());
      print("this is called");
      logger.e(e);
    }
  }

  Future<void> signOutUser() async {
    try {
      _auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  Future checkCurrentUser() async {
    try {
      await Future.delayed(Duration(seconds: 1));

      User? _cUser = _auth.currentUser;
      if (_cUser != null) {
        await getUserInfo(_cUser);
      } else {
        // _navigationService.navigateReplace(AppRoute.mainScreen);
        _navigationService.navigateReplace(AppRoute.loginScreen);
      }
    } catch (e) {
      logger.e('$e');
    }
  }
}
