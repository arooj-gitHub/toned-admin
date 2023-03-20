import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:toned_australia/components/circular_progress.dart';
import 'package:toned_australia/providers/customers_provider.dart';
import 'package:toned_australia/screens/customers/components/add_new_customer.dart';
import 'package:toned_australia/screens/customers/components/item_customer.dart';

import '../../constants.dart';

class CustomersScreen extends StatefulWidget {
  @override
  _CustomersScreenState createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  Logger logger = Logger();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    final _provider = Provider.of<CustomersProvider>(context, listen: false);
    Future.delayed(Duration(milliseconds: 500)).then((_) {
      if (_provider.customersList.isEmpty) {
        _provider.clearCustomersList();
        _provider.getCustomers();
      }
    });
    super.initState();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        _provider.getCustomers();
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
                CustomerHeader(),
                SizedBox(height: defaultPadding),
                if (provider.customersList.length > 0) ...[
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
                          itemCount: provider.customersList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ItemCustomer(index: index, isNormalUser: true);
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
                        await provider.getCustomers();
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
