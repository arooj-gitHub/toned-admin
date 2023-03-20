import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:toned_australia/components/ask_action.dart';
import 'package:toned_australia/models/exercise.dart';
import 'package:toned_australia/providers/groups_provider.dart';

class ItemExercise extends StatelessWidget {
  final int index;

  const ItemExercise({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupsProvider>(
      builder: (context, provider, widget) {
        Exercise exercise = provider.exercisesList[index];
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
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                "${timeAgo.contains('now') ? timeAgo : (timeAgo + ' ago')}",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
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
                      text: 'Do you want to delete ${exercise.title}?',
                      context: context,
                      func: () async {
                        provider.deleteGroupProgramExercise(exercise.id, 3);
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
                    // TODO: edit feature
                  },
                ),
              ],
            ),
            onTap: () {},
          ),
        );
      },
    );
  }
}
