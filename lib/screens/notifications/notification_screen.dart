import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toned_australia/components/se_text_field.dart';
import 'package:toned_australia/controllers/notifications_provider.dart';
import 'package:toned_australia/screens/dashboard/components/header.dart';

import '../../constants.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationsProvider>(
      builder: (_, _provider, child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Header(title: 'Notifications'),
                  SizedBox(height: defaultPadding),
                  SeTextField(
                    controller: _provider.titleTextEditingController,
                    hintText: 'Title',
                    focusNode: _provider.titleFocusNode,
                    validator: 0,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  SeTextField(
                    controller: _provider.bodyTextEditingController,
                    hintText: 'Body',
                    focusNode: _provider.bodyFocusNode,
                    validator: 0,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                  ),
                  IconButton(
                    onPressed: () async {
                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        _provider.imageFile = image;
                      }
                    },
                    icon: Icon(Icons.image_rounded),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await _provider.sendNotification();
              }
            },
            label: Text('Send'),
          ),
        );
      },
    );
  }
}
