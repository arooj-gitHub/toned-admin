import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:toned_australia/components/ask_action.dart';
import 'package:toned_australia/models/exercise_library.dart';
import 'package:toned_australia/providers/exercise_library_provider.dart';

class ItemExerciseLibrary extends StatelessWidget {
  final int index;

  const ItemExerciseLibrary({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseLibraryProvider>(
      builder: (context, provider, widget) {
        ExerciseLibrary exercise = provider.exerciseLibList[index];
        String timeAgo = timeago.format(
          exercise.doc!,
          locale: 'en_short',
          allowFromNow: true,
        );
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: ListTile(
            title: Text(
              "${exercise.title}",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            subtitle: GestureDetector(
              onTap: (){
                if(exercise.url.isNotEmpty){
                  provider.launchURL(exercise.url);
                } else{
                  EasyLoading.showError('No link exists');
                }
              },
              child: Text(
                "Exercise Link",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    askAction(
                      actionText: 'Yes',
                      cancelText: 'No',
                      text:
                          'Do you want to delete ${exercise.title}?',
                      context: context,
                      func: () async {
                        provider.deleteExercise(exercise.id);
                      },
                      cancelFunc: () => Navigator.pop(context),
                    );
                  },
                ),
                Container(
                  height: 30,
                  width: 1,
                  color: Colors.grey,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                ),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    provider.showExerciseLibraryDialog(context, false, model: exercise);
                  },
                ),
              ],
            ),
            
            onTap: (){
              
            },
          ),
        );
      },
    );
  }
}
