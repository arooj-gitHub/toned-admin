import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

import '../components/se_text_field.dart';
import '../constants.dart';
import '../screens/dashboard/components/header.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(title: 'Notifications'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () async {
                      _displayDialog(context);
                    },
                    child: Text("New"))
              ],
            ),
            SizedBox(height: defaultPadding),
            SizedBox(height: 15),
            Text(
              "",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  sendPushNotification(title, body) async {
    print(title);

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

  _displayDialog(BuildContext context) async {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    FocusNode titlenode = FocusNode();
    FocusNode bodynode = FocusNode();
    TextEditingController titleTextEditingController = TextEditingController();
    TextEditingController bodyTextEditingController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 400,
                height: 400,
                child: AlertDialog(
                  title: Text('Add New Customer'),
                  content: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SeTextField(
                          controller: titleTextEditingController,
                          hintText: 'Title',
                          focusNode: titlenode,
                          autoFocus: true,
                          isForm: true,
                          validator: 0,
                        ),
                        SeTextField(
                          controller: bodyTextEditingController,
                          hintText: 'Body',
                          focusNode: bodynode,
                          autoFocus: true,
                          isForm: true,
                          validator: 0,
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    new TextButton(
                      child: new Text('Submit'),
                      onPressed: () async {
                        EasyLoading.show(status: "Loading ...");
                        await sendPushNotification(titleTextEditingController.text, bodyTextEditingController.text);
                        EasyLoading.showSuccess('Notification Added Successfully');
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }
}
