import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:toned_australia/components/circular_progress.dart';
import 'package:toned_australia/providers/customers_provider.dart';

import '../../constants.dart';
import '../screens/dashboard/components/header.dart';
import 'inappCustomers_item.dart';

class AppUsers extends StatefulWidget {
  @override
  AppUserState createState() => AppUserState();
}

class AppUserState extends State<AppUsers> {
  Logger logger = Logger();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    final _provider = Provider.of<CustomersProvider>(context, listen: false);
    Future.delayed(Duration(milliseconds: 500)).then((_) {
      if (_provider.appCustomers.isEmpty) {
        _provider.clearCustomersList();
        _provider.getAppCustomers();
      }
    });
    super.initState();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        _provider.getAppCustomers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomersProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                Header(title: 'App Users'),
                SizedBox(height: defaultPadding),
                if (provider.appCustomers.length > 0) ...[
                  Expanded(
                    child: RefreshIndicator(
                      color: Theme.of(context).primaryColor,
                      child: Container(
                        padding: EdgeInsets.all(defaultPadding),
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: ListView.separated(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: provider.appCustomers.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return inappCustomersItem(index: index, isNormalUser: true);
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
                      onRefresh: () async {
                        provider.clearCustomersList();
                        await provider.getAppCustomers();
                      },
                    ),
                  ),
                ],
                if (provider.customersList.length == 0) ...[
                  if (!provider.customersLoading)
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
                if (provider.customersLoading)
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
