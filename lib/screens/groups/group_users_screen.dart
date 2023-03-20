import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:toned_australia/components/circular_progress.dart';
import 'package:toned_australia/providers/groups_provider.dart';
import 'package:toned_australia/screens/customers/components/item_customer.dart';

import '../../constants.dart';
import 'components/groups_header.dart';

class GroupUsersScreen extends StatefulWidget {
  @override
  _GroupUsersScreenState createState() => _GroupUsersScreenState();
}

class _GroupUsersScreenState extends State<GroupUsersScreen> {
  Logger logger = Logger();

  @override
  void initState() {
    final _provider = Provider.of<GroupsProvider>(context, listen: false);
    Future.delayed(Duration(milliseconds: 500)).then((_) {
      _provider.getGroupUsers();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupsProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                GroupsHeader(
                    title:
                        'Users of ${provider.groupsList[provider.selectedGroup].title}',
                    isGroup: 5),
                SizedBox(height: defaultPadding),
                if (provider.groupUsersList.length > 0) ...[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(defaultPadding),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: provider.groupUsersList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ItemCustomer(
                              index: index, isNormalUser: false);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            height: 0,
                            indent: 12,
                            endIndent: 12,
                          );
                        },
                      ),
                    ),
                  ),
                ],
                if (provider.groupUsersList.length == 0) ...[
                  if (!provider.groupUsersLoading)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('No users for now'),
                          ],
                        ),
                      ),
                    ),
                ],
                if (provider.groupUsersLoading)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 2),
                    child: LinearProgress(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
