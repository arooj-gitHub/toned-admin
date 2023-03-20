// import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:toned_australia/controllers/auth_service.dart';
import 'package:toned_australia/services/navigation_service.dart';

import '../locator.dart';

class NotificationsProvider extends ChangeNotifier {
  final NavigationService _navigationService = locator<NavigationService>();
  Logger logger = Logger();
  FirebaseApp secondaryApp = Firebase.app('secondaryApp');
  late FirebaseFirestore _secondaryFirestore;
  late FirebaseStorage _secondaryStorage;

  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController bodyTextEditingController = TextEditingController();
  XFile? imageFile;

  FocusNode titleFocusNode = FocusNode();
  FocusNode bodyFocusNode = FocusNode();

  // NotificationsProvider(){
  //   _secondaryFirestore = FirebaseFirestore.instanceFor(app: secondaryApp);
  // }

  Future<void> sendNotification() async {
    try {
      final _user = Provider.of<AuthService>(
              _navigationService.navigatorKey.currentContext!,
              listen: false)
          .currentUser;
      _secondaryFirestore = FirebaseFirestore.instanceFor(app: secondaryApp);
      // logger.i('_user!.config.bucketId -> ${_user!.config.bucketId}');
      // _secondaryStorage = FirebaseStorage.instanceFor(app: secondaryApp, bucket: _user.config.bucketId);
      logger.i('type : ${imageFile!.mimeType}');
      String? dUrl;

      if (imageFile != null) {
        try {
          late TaskSnapshot ff;

          final metadata = SettableMetadata(
              contentType: imageFile!.mimeType,
              customMetadata: {'picked-file-path': imageFile!.path});
          Reference dd =
              _secondaryStorage.ref('notifications/${imageFile!.name}');

          if (kIsWeb) {
            ff = await dd.putData(await imageFile!.readAsBytes(), metadata);
          } else {
            logger.wtf('Image Picker is not working on phone atm.');
            return;
            // ff = await _secondaryStorage.ref('notifications/').putFile(imageFile!);
          }

          logger.wtf('File Uploaded: ${ff.ref.toString()}');
          dUrl = await dd.getDownloadURL();
          logger.wtf('File URL: $dUrl');
        } on FirebaseException catch (e) {
          // e.g, e.code == 'canceled'
          logger.wtf(e);
        }
      }

      var body = {
        'title': titleTextEditingController.text,
        'body': bodyTextEditingController.text,
        'status': true,
        'doc': DateTime.now(),
      };
      if (imageFile != null && dUrl != null) {
        body.addAll({
          'imageUrl': dUrl,
        });
      }
      await _secondaryFirestore.collection('notifications').add(body);
      logger.i('Notification Sent');
    } catch (e) {
      logger.e(e);
    }
  }
}
