import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:toned_australia/components/se_text_field.dart';
import 'package:toned_australia/models/exercise_library.dart';
import 'package:toned_australia/services/navigation_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../locator.dart';

class ExerciseLibraryProvider extends ChangeNotifier {
  final NavigationService _navigationService = locator<NavigationService>();
  Logger logger = Logger();
  late FirebaseFirestore _firestore;

  ExerciseLibraryProvider() {
    _firestore = FirebaseFirestore.instance;
  }

  //! EXERCISE LIBRARY PAGINATION

  //#region

  List<ExerciseLibrary> exerciseLibList = [];

  bool hasMoreExercises = true; // flag for more docs available or not
  DocumentSnapshot? lastExerciseDocument;

  bool exerciseLibLoading = false;

  void clearExerciseLibraryList() {
    hasMoreExercises = true;
    exerciseLibList = [];
    lastExerciseDocument = null;
  }

  Future getExercises() async {
    try {
      if (exerciseLibLoading || !hasMoreExercises) {
        logger.wtf('Loading or No More Exercises');
        return;
      }
      exerciseLibLoading = true;
      notifyListeners();

      Query query = _firestore
          .collection('library')
          .orderBy('title', descending: false)
          .where('status', isEqualTo: 1)
          .limit(10);
      QuerySnapshot querySnapshot;
      if (lastExerciseDocument == null)
        querySnapshot = await query.get();
      else
        querySnapshot =
            await query.startAfterDocument(lastExerciseDocument!).get();
      if (querySnapshot.docs.isNotEmpty) {
        if (querySnapshot.docs.length < 10) hasMoreExercises = false;
        lastExerciseDocument =
            querySnapshot.docs[querySnapshot.docs.length - 1];
        querySnapshot.docs.forEach((doc) {
          logger.wtf('ExerciseLibrary Doc -> ${doc.data()}');
          exerciseLibList.add(ExerciseLibrary.fromJson(doc));
        });
      } else {
        hasMoreExercises = false;
      }
      exerciseLibLoading = false;
      notifyListeners();
    } catch (err) {
      logger.e('$err');
    }
  }

  Widget getStatusText(int status) {
    String name = 'Undefined';
    Color color = getColor(status);
    switch (status) {
      case 0:
        name = 'In-Active';
        break;
      case 1:
        name = 'Active';
        break;
      default:
        break;
    }
    return Card(
      color: color,
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Text(
          name,
          style: TextStyle(color: Colors.white, fontSize: 10),
        ),
      ),
    );
  }

  Color getColor(int status) {
    Color color = errorColor;
    switch (status) {
      case 0:
        color = errorColor;
        break;
      case 1:
        color = successColor;
        break;
      default:
        color = errorColor;
        break;
    }
    return color;
  }

//#endregion

  Future deleteExercise(String id) async {
    try {
      EasyLoading.show(status: 'Loading...');
      await _firestore.collection('library').doc(id).update({
        'status': 2,
      });
      clearExerciseLibraryList();
      await getExercises();
      EasyLoading.dismiss();
      _navigationService.goBack();
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Something went wrong');
      logger.e(e);
    }
  }

  showExerciseLibraryDialog(BuildContext context, bool isNew,
      {ExerciseLibrary? model}) async {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    FocusNode _focusNode1 = FocusNode();
    FocusNode _focusNode2 = FocusNode();
    if (!isNew && model != null) {
      newExerciseTitleTec.text = model.title;
      newExerciseUrlTec.text = model.url;
    }

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Exercise Details'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SeTextField(
                    controller: newExerciseTitleTec,
                    hintText: 'Exercise Name',
                    focusNode: _focusNode1,
                    autoFocus: true,
                    isForm: true,
                    validator: 0,
                    onFieldSubmitted: (val) {
                      _focusNode2.requestFocus();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  SeTextField(
                    controller: newExerciseUrlTec,
                    hintText: 'YouTube Video URL',
                    focusNode: _focusNode2,
                    isForm: true,
                    validator: 0,
                    onFieldSubmitted: (val) {
                      if (_formKey.currentState!.validate()) {
                        if (isNew) {
                          createNewExercise();
                        } else {
                          editExerciseLib(model!.id);
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text('Submit'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (isNew) {
                      createNewExercise();
                    } else {
                      editExerciseLib(model!.id);
                    }
                  }
                },
              )
            ],
          );
        });
  }

  TextEditingController newExerciseTitleTec = TextEditingController();
  TextEditingController newExerciseUrlTec = TextEditingController();

  Future createNewExercise() async {
    try {
      EasyLoading.show(status: 'Loading...');
      await _firestore.collection('library').add({
        'title': newExerciseTitleTec.text,
        'url': newExerciseUrlTec.text,
        'status': 1,
        'doc': DateTime.now(),
      });
      clearExerciseLibraryList();
      await getExercises();
      EasyLoading.dismiss();
      newExerciseTitleTec.text = "";
      newExerciseUrlTec.text = "";
      _navigationService.goBack();
    } catch (e) {
      EasyLoading.dismiss();
      logger.e(e);
    }
  }

  Future editExerciseLib(String id) async {
    try {
      EasyLoading.show(status: 'Loading...');
      await _firestore.collection('library').doc(id).update({
        'title': newExerciseTitleTec.text,
        'url': newExerciseUrlTec.text,
      });
      clearExerciseLibraryList();
      await getExercises();
      EasyLoading.dismiss();
      newExerciseTitleTec.text = "";
      newExerciseUrlTec.text = "";
      _navigationService.goBack();
    } catch (e) {
      EasyLoading.dismiss();
      logger.e(e);
    }
  }

  void launchURL(String url) async {
    Uri uri = Uri.parse(url);
    await canLaunchUrl(uri)
        ? await launchUrl(uri)
        : throw 'Could not launch $url';
  }
}
