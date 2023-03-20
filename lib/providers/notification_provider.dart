import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:toned_australia/models/notificationsModel.dart';

class NotificationProvider extends ChangeNotifier {
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
  CollectionReference userCollectionRef = FirebaseFirestore.instance.collection('notifications');
  Logger logger = Logger();
  late FirebaseFirestore _firestore;
  FirebaseAuth _auth = FirebaseAuth.instance;

  List<NotificationModel> notificationList = [];

  Future addNewNotifications(context) async {
    if (title.text != "" && body.text != "") {
      EasyLoading.show(status: 'Loading...');
      try {
        await userCollectionRef.add({
          'title': title.text,
          'body': body.text,
          'sentTo': "all users",
          'CreatedAt': DateTime.now(),
        }).then((value) async {
          await sendPushNotification(title.text, body.text);
          EasyLoading.showSuccess('Notification Added Successfully');
          notificationList.add(NotificationModel(
            title: title.text,
            body: body.text,
            createdAt: DateTime.now(),
          ));
          title.clear();
          body.clear();

          Navigator.pop(context);
        });
      } catch (e) {
        print(e.toString());
        EasyLoading.showError(e.toString());
      }
    } else {
      EasyLoading.showError("Fields cannot be null");
    }

    notifyListeners();
  }

  sendPushNotification(title, body) async {
    var result = await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Authorization": "key=AAAA9dWE0zI:APA91bGsSeGipVsT5kEw_0axrZeerVuiGEbe_787Vvkcm94ptUdRpudXRZ03pXtpTeOuxvRGMeNlVe7JUnDbqjMCcaNCvc1TZ2TcAaez3rcEV7euEcmV6byWdy-DTRM7nu2JznSc-P8i",
        },
        body: jsonEncode(
          <String, dynamic>{
            "to": "/topics/all",
            "collapse_key": "type_a",
            "notification": {"body": body, "title": title}
          },
        ));
    log('test: :  ${result.body}');
  }
}
