import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:toned_australia/components/ask_action.dart';
import 'package:toned_australia/models/program.dart';
import 'package:toned_australia/providers/groups_provider.dart';

import '../../../app_router.dart';

class ItemProgram extends StatelessWidget {
  final int index;

  const ItemProgram({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupsProvider>(
      builder: (context, provider, widget) {
        Program program = provider.programsList[index];
        String timeAgo = timeago.format(
          program.doc!,
          locale: 'en_short',
          allowFromNow: true,
        );
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: ListTile(
            title: Text(
              "${program.title}",
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
                      text:
                          'Do you want to delete ${program.title}?',
                      context: context,
                      func: () async {
                        provider.deleteGroupProgramExercise(program.id, 2);
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
                    provider.showEditDialog(context, 2, program);
                  },
                ),
              ],
            ), 
            onTap: () {
              provider.selectedProgram = index;
              Navigator.pushNamed(context, AppRoute.exerciseScreen);
            },
          ),
        );
      },
    );
  }
}
