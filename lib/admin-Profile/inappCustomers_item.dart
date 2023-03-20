import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:toned_australia/components/ask_action.dart';
import 'package:toned_australia/models/user_model.dart';
import 'package:toned_australia/providers/customers_provider.dart';
import 'package:toned_australia/providers/groups_provider.dart';

class inappCustomersItem extends StatelessWidget {
  final int index;
  final bool isNormalUser;

  inappCustomersItem({Key? key, required this.index, required this.isNormalUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _groupProvider = Provider.of<GroupsProvider>(context);
    return Consumer<CustomersProvider>(
      builder: (context, provider, widget) {
        UserModel customer;
        if (isNormalUser) {
          customer = provider.appCustomers[index];
        } else {
          customer = _groupProvider.groupUsersList[index];
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: ListTile(
            title: Text(
              "${customer.name}",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            subtitle: Text(
              "${customer.email}",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isNormalUser) ...[
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      askAction(
                        actionText: 'Yes',
                        cancelText: 'No',
                        text: 'Do you want to remove ${customer.name} from ${_groupProvider.groupsList[_groupProvider.selectedGroup].title}?',
                        context: context,
                        func: () async {
                          // provider.deleteEvent(event.id);
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
                  SizedBox(width: 25),
                ],
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        provider.getStatusText(customer.status),
                        SizedBox(width: 15),
                        customer.isAdmin
                            ? Container()
                            : Container(
                                height: 30,
                                child: CupertinoSwitch(
                                  activeColor: customer.status == 2 ? Colors.red : Colors.grey.shade700,
                                  thumbColor: Colors.grey.shade200,
                                  value: customer.status == 2 ? true : false,
                                  onChanged: (bool value) async {
                                    if (customer.status == 2) {
                                      //    provider.updateBlockSwitchValue(false);
                                      EasyLoading.show(status: 'Loading...');
                                      await provider.UnBlockCustomer(customer.uId);
                                      EasyLoading.showSuccess("Customer UnBlocked");
                                    } else {
                                      // provider.updateBlockSwitchValue(true);
                                      EasyLoading.show(status: 'Loading...');
                                      await provider.updateCustomerBlockStatus(customer.uId);
                                      EasyLoading.showSuccess("Customer Blocked");
                                    }
                                  },
                                ),
                              )
                        /*  customer.status != 2
                            ? GestureDetector(
                                onTap: () async {
                                  EasyLoading.show(status: 'Loading...');
                                  await provider.updateCustomerBlockStatus(customer.uId);
                                  EasyLoading.showSuccess("Customer Blocked");
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Card(
                                    color: Colors.red,
                                    margin: EdgeInsets.all(0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      child: Text(
                                        "Block",
                                        style: TextStyle(color: Colors.white, fontSize: 10),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Card(
                                color: Colors.red,
                                margin: EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  child: Text(
                                    "Already Blocked",
                                    style: TextStyle(color: Colors.white, fontSize: 10),
                                  ),
                                ),
                              ), */
                      ],
                    ),
                  ],
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
