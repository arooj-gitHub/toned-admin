import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toned_australia/components/se_text_field.dart';
import 'package:toned_australia/models/exercise_item.dart';
import 'package:toned_australia/providers/groups_provider.dart';

import '../../constants.dart';
import 'components/groups_header.dart';

class AddExerciseScreen extends StatefulWidget {
  @override
  _AddExerciseScreenState createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  
  final ImagePicker _picker = ImagePicker();
  XFile? video;

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupsProvider>(builder: (context, provider, child) {
      return WillPopScope(
        onWillPop: () async{
          if(provider.exerciseFieldsList.isEmpty){
            Navigator.pop(context);
          } else{
            showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Are you sure you want to go back?'),
            actions: <Widget>[
              TextButton(
                child: new Text('No'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: new Text('Yes'),
                onPressed: () {
                  Navigator.pop(context);
                  provider.exerciseFieldsList = [];
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
          }
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          persistentFooterButtons: [
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => provider.addNewField(0),
                      child: Container(
                        child: Center(
                          child: Text('Add Space'),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => provider.addNewField(1),
                      child: Container(
                        child: Center(
                          child: Text('Add Text'),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    color: Theme.of(context).primaryColor,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => provider.addNewField(2),
                      child: Container(
                        child: Center(
                          child: Text('Add Video'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          body: Scrollbar(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SingleChildScrollView(
                child: Form(
                  key: provider.addExerciseFormKey,
                  child: Column(
                    children: [
                      GroupsHeader(title: 'New Exercise for ${provider.programsList[provider.selectedProgram].title}', isGroup: 4),
                      SizedBox(height: defaultPadding),
                      SeTextField(
                        controller: provider.newExerciseTitleTec,
                        hintText: 'Exercise Title',
                        focusNode: FocusNode(),
                        autoFocus: true,
                        isForm: true,
                        validator: 0,
                        // onFieldSubmitted: (val) {
                        // },
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: provider.exerciseFieldsList.length,
                        itemBuilder: (context, index) {
                          if (!provider.exerciseFieldsList[index].isVideo && !provider.exerciseFieldsList[index].isSpace) {
                            return SeTextField(
                              controller: provider.exerciseFieldsList[index].text!,
                              hintText: 'Text',
                              focusNode: FocusNode(),
                              autoFocus: true,
                              isForm: true,
                              validator: 0,
                              // onFieldSubmitted: (val) {
                              // },
                            );
                          } else if (provider.exerciseFieldsList[index].isVideo){
                            return Row(
                              children: [
                                Expanded(
                                  child: SeTextField(
                                    controller: provider.exerciseFieldsList[index].text!,
                                    hintText: 'Text',
                                    focusNode: FocusNode(),
                                    autoFocus: true,
                                    isForm: true,
                                    validator: 0,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: SeTextField(
                                    controller: provider.exerciseFieldsList[index].videoLink!,
                                    hintText: 'Video Link',
                                    focusNode: FocusNode(),
                                    autoFocus: true,
                                    isForm: true,
                                    validator: 0,
                                    // onTap: () => startWebFilePicker(index: index),
                                    // onTap: () => startWebFilePicker(index: index),
                                  ),
                                ),
                              ],
                            );
                          } else{
                            return Divider();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

}
