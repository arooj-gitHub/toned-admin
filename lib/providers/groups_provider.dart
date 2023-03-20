import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:toned_australia/components/se_text_field.dart';
import 'package:toned_australia/models/exercise.dart';
import 'package:toned_australia/models/exercise_item.dart';
import 'package:toned_australia/models/group.dart';
import 'package:toned_australia/models/program.dart';
import 'package:toned_australia/models/user_model.dart';
import 'package:toned_australia/services/navigation_service.dart';

import '../constants.dart';
import '../locator.dart';

class GroupsProvider extends ChangeNotifier {
  final NavigationService _navigationService = locator<NavigationService>();
  Logger logger = Logger();
  late FirebaseFirestore _firestore;

  late int selectedGroup;
  late int selectedProgram;
  late int selectedExercise;
  String groupName = "";

  GroupsProvider() {
    _firestore = FirebaseFirestore.instance;
  }

  //! GROUPS PAGINATION

  //#region

  List<Group> groupsList = [];

  bool hasMoreGroups = true; // flag for more docs available or not
  DocumentSnapshot? lastGroupDocument;

  bool groupsLoading = false;

  void clearGroupsList() {
    hasMoreGroups = true;
    groupsList = [];
    lastGroupDocument = null;
  }

  getGroupName(title) {
    groupName = title;
    notifyListeners();
  }

  Future getGroups() async {
    try {
      if (groupsLoading || !hasMoreGroups) {
        logger.wtf('Loading or No More Groups');
        return;
      }
      groupsLoading = true;
      notifyListeners();

      Query query = _firestore.collection('groups').orderBy('doc', descending: true).where('status', isEqualTo: 1).limit(10);
      QuerySnapshot querySnapshot;
      if (lastGroupDocument == null)
        querySnapshot = await query.get();
      else
        querySnapshot = await query.startAfterDocument(lastGroupDocument!).get();
      if (querySnapshot.docs.isNotEmpty) {
        if (querySnapshot.docs.length < 10) hasMoreGroups = false;
        lastGroupDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
        querySnapshot.docs.forEach((doc) {
          logger.wtf('Group Doc -> ${doc.data()}');
          groupsList.add(Group.fromJson(doc));
        });
      } else {
        hasMoreGroups = false;
      }
      groupsLoading = false;
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

  Widget getPublicFieldText(bool isPublic) {
    String name = '';
    Color color = getPublicGroupStatusColor(isPublic);
    switch (isPublic) {
      case true:
        name = 'Public';
        break;
      case false:
        name = 'Private';
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

  Color getPublicGroupStatusColor(status) {
    Color color = errorColor;
    switch (status) {
      case false:
        color = errorColor;
        break;
      case true:
        color = successColor;
        break;
      default:
        color = errorColor;
        break;
    }
    return color;
  }

  TextEditingController newGroupNameTec = TextEditingController();

  Future createGroup() async {
    try {
      EasyLoading.show(status: 'Loading...');
      var value = await _firestore.collection('groups').add({
        'title': newGroupNameTec.text,
        'status': 1,
        'doc': DateTime.now(),
        'isPublic': false,
        'isCurrentUserAssigngroup': false,
      });
      var documentRef = value.path.split('/');
      await _firestore.collection('group_users').doc(documentRef[1]).set({
        'users': null,
      });
      clearGroupsList();
      await getGroups();
      EasyLoading.dismiss();
      newGroupNameTec.text = "";
      _navigationService.goBack();
    } catch (e) {
      EasyLoading.dismiss();
      logger.e(e);
    }
  }

  Future deleteGroupProgramExercise(String id, isGroup) async {
    try {
      EasyLoading.show(status: 'Loading...');
      String collectionName = 'groups';
      if (isGroup == 2) {
        collectionName = 'programs';
      } else if (isGroup == 3) {
        collectionName = 'exercises';
      }
      await _firestore.collection(collectionName).doc(id).update({
        'status': 2,
      });
      if (isGroup == 1) {
        clearGroupsList();
        await getGroups();
      } else if (isGroup == 2) {
        clearProgramsList();
        await getPrograms();
      } else {
        clearExercisesList();
        await getExercises();
      }
      EasyLoading.dismiss();
      _navigationService.goBack();
    } catch (e) {
      EasyLoading.dismiss();
      logger.e(e);
    }
  }

//#endregion

//! PROGRAMS PAGINATION

  //#region
  List<Program> programsList = [];

  bool hasMorePrograms = true; // flag for more docs available or not
  DocumentSnapshot? lastProgramsDocument;

  bool programsLoading = false;

  void clearProgramsList() {
    hasMorePrograms = true;
    programsList = [];
    lastProgramsDocument = null;
  }

  Future getPrograms() async {
    try {
      if (programsLoading || !hasMorePrograms) {
        logger.wtf('Loading or No More Groups');
        return;
      }
      programsLoading = true;
      notifyListeners();

      Query query = _firestore.collection('programs').where('group_id', isEqualTo: groupsList[selectedGroup].id).where('status', isEqualTo: 1).orderBy('doc', descending: true).limit(10);
      QuerySnapshot querySnapshot;
      if (lastProgramsDocument == null)
        querySnapshot = await query.get();
      else
        querySnapshot = await query.startAfterDocument(lastProgramsDocument!).get();
      if (querySnapshot.docs.isNotEmpty) {
        if (querySnapshot.docs.length < 10) hasMorePrograms = false;
        lastProgramsDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
        querySnapshot.docs.forEach((doc) {
          logger.wtf('Program Doc -> ${doc.data()}');
          programsList.add(Program.fromJson(doc));
        });
      } else {
        hasMorePrograms = false;
      }
      programsLoading = false;
      notifyListeners();
    } catch (err) {
      logger.e('$err');
    }
  }

  TextEditingController newProgramNameTec = TextEditingController();

  Future createProgram() async {
    try {
      EasyLoading.show(status: 'Loading...');
      await _firestore.collection('programs').add({
        'title': newProgramNameTec.text,
        'status': 1,
        'doc': DateTime.now(),
        'group_id': groupsList[selectedGroup].id,
      });
      EasyLoading.showSuccess("Program added successfuly");

      clearProgramsList();
      await getPrograms();
      EasyLoading.dismiss();
      newProgramNameTec.text = "";
      _navigationService.goBack();
    } catch (e) {
      EasyLoading.dismiss();
      logger.e(e);
    }
  }

//#endregion

//! EXERCISE PAGINATION

  //#region
  List<Exercise> exercisesList = [];

  bool hasMoreExercises = true; // flag for more docs available or not
  DocumentSnapshot? lastExerciseDocument;
  bool exercisesLoading = false;

  TextEditingController newExerciseTitleTec = TextEditingController();

  void clearExercisesList() {
    hasMoreExercises = true;
    exercisesList = [];
    lastExerciseDocument = null;
  }

  Future getExercises() async {
    try {
      if (exercisesLoading || !hasMoreExercises) {
        logger.wtf('Loading or No More Groups');
        return;
      }
      exercisesLoading = true;
      notifyListeners();

      Query query = _firestore.collection('exercises').where('program_id', isEqualTo: programsList[selectedProgram].id).where('status', isEqualTo: 1).orderBy('doc', descending: true).limit(10);
      QuerySnapshot querySnapshot;
      if (lastExerciseDocument == null)
        querySnapshot = await query.get();
      else
        querySnapshot = await query.startAfterDocument(lastExerciseDocument!).get();
      if (querySnapshot.docs.isNotEmpty) {
        if (querySnapshot.docs.length < 10) hasMoreExercises = false;
        lastExerciseDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
        querySnapshot.docs.forEach((doc) {
          logger.wtf('Program Doc -> ${doc.data()}');
          exercisesList.add(Exercise.fromJson(doc));
        });
      } else {
        hasMoreExercises = false;
      }
      exercisesLoading = false;
      notifyListeners();
    } catch (err) {
      logger.e('$err');
    }
  }

  List<ExerciseItem> exerciseFieldsList = [];

  void addNewField(int type) {
    // 0=space, 1=text, 2=video
    switch (type) {
      case 0:
        exerciseFieldsList.add(
          ExerciseItem(
            text: null,
            videoLink: null,
            isSpace: true,
            isVideo: false,
          ),
        );
        break;
      case 1:
        exerciseFieldsList.add(
          ExerciseItem(
            text: TextEditingController(),
            videoLink: null,
            isSpace: false,
            isVideo: false,
          ),
        );
        break;
      case 2:
        exerciseFieldsList.add(
          ExerciseItem(
            text: TextEditingController(),
            videoLink: TextEditingController(),
            isSpace: true,
            isVideo: true,
          ),
        );
        break;
    }
    notifyListeners();
  }

  GlobalKey<FormState> addExerciseFormKey = GlobalKey<FormState>();

  Future addNewExercise() async {
    if (addExerciseFormKey.currentState!.validate()) {
      EasyLoading.show(status: 'Loading...');
      List<Map<String, dynamic>> _finalList = [];
      for (int i = 0; i < exerciseFieldsList.length; i++) {
        String? _text, _video;
        if (exerciseFieldsList[i].text == null) {
          _text = null;
        } else {
          _text = exerciseFieldsList[i].text!.text;
        }
        if (exerciseFieldsList[i].videoLink == null) {
          _video = null;
        } else {
          _video = exerciseFieldsList[i].videoLink!.text;
        }

        _finalList.add(
          ExerciseItemFirestore(
            text: _text,
            videoLink: _video,
            isSpace: exerciseFieldsList[i].isSpace,
            isVideo: exerciseFieldsList[i].isVideo,
          ).toMap(),
        );
      }
      debugPrint('_finalList=> ${_finalList.toString()}');

      try {
        var value = await _firestore.collection('exercises').add({
          "program_id": programsList[selectedProgram].id,
          "title": newExerciseTitleTec.text,
          // "body": _finalList,
          "status": 1,
          "doc": DateTime.now(),
        });

        var documentRef = value.path.split('/');
        await _firestore.collection('exercises').doc(documentRef[1]).collection('body').doc('body').set({
          "body": _finalList,
        });

        EasyLoading.dismiss();
        newExerciseTitleTec.text = "";
        exerciseFieldsList.clear();
        clearExercisesList();
        getExercises();
        _navigationService.goBack();
      } catch (err) {
        EasyLoading.dismiss();
        print("exception catched: ${err.toString()}");
        EasyLoading.showError('Network error');
      }
    }
  }

  TextEditingController editTitleTec = TextEditingController();

  showEditDialog(BuildContext context, int isGroup, dynamic model) async {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    FocusNode _focusNode = FocusNode();
    editTitleTec.text = model.title;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(_getEditTitle(isGroup)),
            content: Form(
              key: _formKey,
              child: SeTextField(
                controller: editTitleTec,
                hintText: _getEditHint(isGroup),
                focusNode: _focusNode,
                autoFocus: true,
                isForm: true,
                validator: 0,
                onFieldSubmitted: (val) {
                  _editDoc(_formKey, isGroup, model);
                },
              ),
              // child: TextFormField(
              //   controller: _provider.newGroupNameTec,
              //   textInputAction: TextInputAction.go,
              //   keyboardType: TextInputType.numberWithOptions(),
              //   decoration: InputDecoration(hintText: "Group Name"),
              // ),
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text('Submit'),
                onPressed: () => _editDoc(_formKey, isGroup, model),
              )
            ],
          );
        });
  }

  String _getEditTitle(int isGroup) {
    String _title = 'What is the group name';
    switch (isGroup) {
      case 1:
        _title = 'Edit group name';
        break;
      case 2:
        _title = 'Edit program name';
        break;
      case 3:
        _title = 'Edit exercise name';
        break;
      default:
        _title = 'Edit group name';
        break;
    }
    return _title;
  }

  String _getEditHint(int isGroup) {
    String _title = 'Group name';
    switch (isGroup) {
      case 1:
        _title = 'Group name';
        break;
      case 2:
        _title = 'Program name';
        break;
      case 3:
        _title = 'Exercise name';
        break;
      default:
        _title = 'Group name';
        break;
    }
    return _title;
  }

  Future _editDoc(GlobalKey<FormState> _formKey, int isGroup, dynamic model) async {
    if (_formKey.currentState!.validate()) {
      await editGroupAndProgram(isGroup, model);
    }
  }

  Future editGroupAndProgram(int isGroup, dynamic model) async {
    try {
      EasyLoading.show(status: 'Loading...');
      String collectionName = 'groups';
      if (isGroup == 2) {
        collectionName = 'programs';
      }
      await _firestore.collection(collectionName).doc(model.id).update({
        'title': editTitleTec.text,
      });
      if (isGroup == 1) {
        clearGroupsList();
        await getGroups();
      } else {
        clearProgramsList();
        await getPrograms();
      }
      EasyLoading.dismiss();
      editTitleTec.text = "";
      _navigationService.goBack();
    } catch (e) {
      EasyLoading.dismiss();
      logger.e(e);
    }
  }

  TextEditingController newGroupUserTec = TextEditingController();

  showGroupUserAssigneeDialog(BuildContext context, dynamic model) async {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter existing user email'),
            content: Form(
              key: _formKey,
              child: SeTextField(
                controller: newGroupUserTec,
                hintText: 'Email',
                focusNode: FocusNode(),
                autoFocus: true,
                isForm: true,
                validator: 1,
                onFieldSubmitted: (val) {
                  assignUserToGroup(_formKey, model);
                },
              ),
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text('Submit'),
                onPressed: () => assignUserToGroup(_formKey, model),
              )
            ],
          );
        });
  }

  Future assignUserToGroup(GlobalKey<FormState> _formKey, dynamic model) async {
    if (_formKey.currentState!.validate()) {
      try {
        EasyLoading.show(status: 'Loading...');

        var userData = await _firestore.collection('user').where('email', isEqualTo: newGroupUserTec.text.toLowerCase()).get();
        if (userData.docs.isNotEmpty) {
          if (userData.docs.first.data()['group'] == null) {
            if (userData.docs.first.data()['group'] != model.id) {
              await finalAssignUserToGroup(model.id, userData.docs.first.id);
            } else {
              EasyLoading.dismiss();
              EasyLoading.showError('User already exists');
            }
          } else {
            //? First delete the old then add new
            bool _isDone = await deleteUserFromGroup(userData.docs.first.data()['group'], userData.docs.first.id);
            if (_isDone) {
              await finalAssignUserToGroup(model.id, userData.docs.first.id);
            } else {
              EasyLoading.dismiss();
              EasyLoading.showError('Something went wrong');
            }
          }
        } else {
          EasyLoading.dismiss();
          EasyLoading.showError('User not found');
        }
        EasyLoading.dismiss();
        newGroupUserTec.text = "";
        _navigationService.goBack();
      } catch (e) {
        EasyLoading.dismiss();
        EasyLoading.showError('Something went wrong');
        logger.e(e);
      }
    }
  }

  Future finalAssignUserToGroup(String groupId, userId) async {
    try {
      DocumentReference groupRef = _firestore.collection('groups').doc(groupId);
      DocumentReference userRef = _firestore.collection('user').doc(userId);
      DocumentReference groupUsersRef = _firestore.collection('group_users').doc(groupId);

      WriteBatch writeBatch = _firestore.batch();
      writeBatch.update(groupRef, {'total_users': FieldValue.increment(1), 'isCurrentUserAssigngroup': true});

      writeBatch.update(userRef, {'group': groupId});

      writeBatch.update(groupUsersRef, {
        'users': FieldValue.arrayUnion([userId])
      });

      await writeBatch.commit();

      EasyLoading.showSuccess('User added ✅');
      print(userId);
      var userDoc = await _firestore.collection('user').doc(userId).get();
      print(userDoc);

      //  await sendPushNotification("fWhn-bVaT9aNem9TC0nD1J:APA91bGGXKlLe8xUFdso55k2aCeI-YClH_Zk5f4OSIX7BvXUl2p5H5KKaKWTVXIODWKX5Qtwkv3UA9i5zIMarcNTMjZh0plI0SEcv6N5cdh3R4iPpuKfp4u0TctGxpyqjbvNcjnD_9-a", "New Member added", "${userDoc.get("username")} you are assigned $groupName by the admin");

      var userToken = userDoc.get("token") ?? "";
      print(userDoc.get("token"));
      if (userToken != "") {
        EasyLoading.show(status: "Notification send successfully to ${userDoc.get("username")}");
        await sendPushNotification(userToken, "New Member added", "${userDoc.get("username")} you are assigned $groupName by the admin");
        EasyLoading.showSuccess('Notification sent to user ✅');
      } else {
        EasyLoading.showError('User token is Empty ✅');
      }

      EasyLoading.dismiss();

      clearGroupsList();
      getGroups();
    } catch (e) {
      EasyLoading.showError('Something went wrong');
      logger.e(e);
    }
  }

  Future<bool> deleteUserFromGroup(String groupId, userId) async {
    try {
      DocumentReference groupRef = _firestore.collection('groups').doc(groupId);
      DocumentReference userRef = _firestore.collection('user').doc(userId);
      DocumentReference groupUsersRef = _firestore.collection('group_users').doc(groupId);

      WriteBatch writeBatch = _firestore.batch();
      writeBatch.update(groupRef, {'total_users': FieldValue.increment(-1)});

      writeBatch.update(userRef, {'group': null});

      writeBatch.update(groupUsersRef, {
        'users': FieldValue.arrayRemove([userId])
      });
      await writeBatch.commit();
      return true;
    } catch (e) {
      EasyLoading.showError('Something went wrong');
      logger.e(e);
      return false;
    }
  }

  //! Group Users

  List<UserModel> groupUsersList = [];
  bool groupUsersLoading = false;

  Future getGroupUsers() async {
    try {
      groupUsersList = [];
      groupUsersLoading = true;
      notifyListeners();
      logger.i('_groupUserIdsList -> startttt');
      var groupUsersDoc = await _firestore.collection('group_users').doc(groupsList[selectedGroup].id).get();
      if (groupUsersDoc.exists) {
        if (groupUsersDoc.data() != null) {
          List _groupUserIdsList = groupUsersDoc.data()!['users'];
          logger.i('_groupUserIdsList -> ${_groupUserIdsList.toString()}');
          for (int i = 0; i < _groupUserIdsList.length; i++) {
            var _userDoc = await _firestore.collection('user').doc(_groupUserIdsList[i]).get();
            if (_userDoc.exists) {
              groupUsersList.add(UserModel.fromJson(_userDoc));
            }
          }
          if (!kDebugMode) {
            FirebaseAnalytics.instance.logEvent(
              name: 'Active Groups Count',
              parameters: {"Active Groups": _groupUserIdsList.length},
            );
          }
        } else {
          logger.e('empty list');
          EasyLoading.showInfo('No users for now');
        }
      }
      groupUsersLoading = false;
      notifyListeners();
    } catch (err) {
      groupUsersLoading = false;
      logger.e('$err');
      notifyListeners();
    }
  }

  updateGroupPublicStatusFromDb(id, status) async {
    await _firestore.collection('groups').doc(id).update({
      'isPublic': status,
    });
    for (var i in groupsList) {
      if (i.id == id) {
        i.isPublic = status;
      }
    }
    notifyListeners();
  }

  sendPushNotification(token, title, body) async {
    var result = await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Authorization": "key=AAAA9dWE0zI:APA91bGsSeGipVsT5kEw_0axrZeerVuiGEbe_787Vvkcm94ptUdRpudXRZ03pXtpTeOuxvRGMeNlVe7JUnDbqjMCcaNCvc1TZ2TcAaez3rcEV7euEcmV6byWdy-DTRM7nu2JznSc-P8i",
        },
        body: jsonEncode(
          <String, dynamic>{
            "to": token,
            "collapse_key": "type_a",
            "notification": {"body": body, "title": title}
          },
        ));
    log('test: :  ${result.body}');
  }

//! If the video is a file
/*
onTap: () async {
  XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
  if(video != null){
    provider.exerciseFieldsList[index].fileResource = video;
    provider.exerciseFieldsList[index].file!.text = video.mimeType!;
    await provider.uploadFile(video);
    print('******** HEYYYY *******');
    print('******** VIDEO UPLOADED *******');
  }
},
*/
//   Future uploadFile(XFile? file) async {
//     if (file == null) {
//       return null;
//     }

//     firebase_storage.UploadTask uploadTask;

//     // Create a Reference to the file
//     firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
//         .ref()
//         .child('videos')
//         .child(file.name);

//     final metadata = firebase_storage.SettableMetadata(
//         contentType: file.mimeType!,
//         customMetadata: {'picked-file-path': file.path});

//     if (kIsWeb) {
//       firebase_storage.Reference _reference = firebase_storage
//           .FirebaseStorage.instance
//           .ref()
//           .child('videos/${file.name}');
//       await _reference
//           .putData(
//         await file.readAsBytes(),
//         firebase_storage.SettableMetadata(contentType: file.mimeType),
//       )
//           .whenComplete(() async {
//         await _reference.getDownloadURL().then((value) {
//           print('URL : ${value}');
//         });
//       });
//     }

// // await ref.putFile(io.File(file.path), metadata);
//     // if (kIsWeb) {
//     //   // uploadTask = ref.putData(await file.readAsBytes(), metadata);
//     //   Stream<firebase_storage.TaskSnapshot> abc = ref.putData(await file.readAsBytes(), metadata).asStream();
//     // } else {
//     //   uploadTask = ref.putFile(io.File(file.path), metadata);
//     // }
//     return '';
//   }

//#endregion
}
