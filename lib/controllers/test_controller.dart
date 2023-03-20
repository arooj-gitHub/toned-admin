// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:logger/logger.dart';
//
// class TestController extends ChangeNotifier {
//   var logger = Logger();
//
//
//   TestController(){
//     initTest();
//   }
//
//   Future initTest() async {
//
//     print('*** initTest Called ***');
//     logger.i('*** initTest Called ***');
//     await Future.delayed(Duration(seconds: 10));
//     logger.i('*** START ***');
//
//     await Firebase.initializeApp(
//       name: 'SnackEzy',
//       options: FirebaseOptions(
//         apiKey: 'AIzaSyAOs2x_2pMxMaDHXr-I59egX8CoWZ86JgI',
//         appId: '1:943737813073:android:d611425e97d1cf4cba2070',
//         messagingSenderId: '943737813073',
//         projectId: 'snackezy-f6ae9',
//       ),
//     );
//     logger.i('Firebase Initialized');
//     FirebaseApp secondaryApp = Firebase.app('SnackEzy');
//     logger.i('going for firestore -> ${secondaryApp.toString()}');
//     FirebaseFirestore firestore = FirebaseFirestore.instanceFor(app: secondaryApp);
//     await firestore.collection('config').doc('config').get().then((value) {
//       logger.i('value.id -> ${value.id}');
//       logger.wtf('value -> ${value.data()}');
//     });
//
//     List<FirebaseApp> apps = Firebase.apps;
//
//     apps.forEach((app) {
//       logger.e('App name: ${app.name}');
//     });
//
//     await secondaryApp.delete();
//
//     logger.i('*** END ***');
//   }
// }
