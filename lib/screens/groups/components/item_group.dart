import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:toned_australia/app_router.dart';
import 'package:toned_australia/components/ask_action.dart';
import 'package:toned_australia/models/group.dart';
import 'package:toned_australia/providers/groups_provider.dart';

class ItemGroup extends StatelessWidget {
  final int index;

  const ItemGroup({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupsProvider>(
      builder: (context, provider, widget) {
        Group group = provider.groupsList[index];
        String timeAgo = timeago.format(
          group.doc!,
          locale: 'en_short',
          allowFromNow: true,
        );
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: ListTile(
            title: Text(
              "${group.title}",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            subtitle: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                // provider.getStatusText(group.status),

                // Text(
                //   "${timeAgo.contains('now') ? timeAgo : (timeAgo + ' ago')}",
                //   style: TextStyle(
                //     fontSize: 10,
                //     color: Colors.grey,
                //   ),
                //   overflow: TextOverflow.ellipsis,
                //   maxLines: 1,
                // ),
                InkWell(
                  onTap: () {
                    provider.selectedGroup = index;
                    Navigator.pushNamed(context, AppRoute.groupsUserScreen);
                  },
                  child: Text(
                    "${group.totalUsers} users",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  group.isPublic ? 'Public' : 'Private',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
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
                      text: 'Do you want to delete ${group.title}?',
                      context: context,
                      func: () async {
                        provider.deleteGroupProgramExercise(group.id, 1);
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
                    provider.showEditDialog(context, 1, group);
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
                    Icons.person_add_alt_1_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    provider.getGroupName(group.title);
                    await provider.showGroupUserAssigneeDialog(context, group);
                  },
                ),
                Container(
                  height: 30,
                  width: 1,
                  color: Colors.grey,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                ),
                Container(
                  height: 30,
                  child: CupertinoSwitch(
                    activeColor: provider.groupsList[index].isPublic ? Colors.green : Colors.red,
                    thumbColor: Colors.grey.shade200,
                    value: provider.groupsList[index].isPublic ? true : false,
                    onChanged: (bool value) async {
                      if (provider.groupsList[index].isPublic) {
                        //    provider.updateBlockSwitchValue(false);
                        EasyLoading.show(status: 'Loading...');
                        await provider.updateGroupPublicStatusFromDb(provider.groupsList[index].id, false);
                        EasyLoading.showSuccess("Group status set to Private");
                      } else {
                        // provider.updateBlockSwitchValue(true);
                        EasyLoading.show(status: 'Loading...');
                        print("group id");
                        print(group.id);
                        await provider.updateGroupPublicStatusFromDb(provider.groupsList[index].id, true);
                        EasyLoading.showSuccess("Group status set to Public");
                      }
                    },
                  ),
                )
              ],
            ),
            onTap: () {
              provider.selectedGroup = index;
              Navigator.pushNamed(context, AppRoute.programsScreen);
            },
          ),
        );
      },
    );
  }
}
