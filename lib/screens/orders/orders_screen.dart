import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:toned_australia/components/circular_progress.dart';
import 'package:toned_australia/controllers/secondary_app_provider.dart';
import 'package:toned_australia/screens/dashboard/components/header.dart';

import '../../constants.dart';
import 'components/item_order.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Logger logger = Logger();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    final _provider = Provider.of<SecondaryAppProvider>(context, listen: false);
    // Future.delayed(Duration(milliseconds: 500)).then((_) {
    //   _provider.clearOrdersList();
    //   _provider.getOrders();
    // });
    super.initState();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        _provider.getOrders();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SecondaryAppProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                Header(title: 'Orders'),
                SizedBox(height: defaultPadding),
                if (provider.ordersList.length > 0) ...[
                  Expanded(
                    child: RefreshIndicator(
                      color: Theme.of(context).primaryColor,
                      child: ListView.separated(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: provider.ordersList.length,
                        itemBuilder: (context, index) {
                          return ItemOrder(index: index);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            height: 0,
                            indent: 12,
                            endIndent: 12,
                          );
                        },
                      ),
                      onRefresh: () async {
                        provider.clearOrdersList();
                        await provider.getOrders();
                      },
                    ),
                  ),
                ],
                if (provider.ordersList.length == 0) ...[
                  if (!provider.ordersLoading)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /// TODO: Image here
                            Text('No notifications for now'),
                          ],
                        ),
                      ),
                    ),
                ],
                if (provider.ordersLoading)
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
