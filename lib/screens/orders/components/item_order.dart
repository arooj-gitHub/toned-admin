import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:toned_australia/constants.dart';
import 'package:toned_australia/controllers/secondary_app_provider.dart';
import 'package:toned_australia/models/order.dart';

class ItemOrder extends StatelessWidget {
  final int index;

  const ItemOrder({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SecondaryAppProvider>(
      builder: (context, provider, widget) {
        OrderModel order = provider.ordersList[index];
        String timeAgo = timeago.format(
          order.doc!,
          locale: 'en_short',
          allowFromNow: true,
        );
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: ListTile(
            title: Tooltip(
              child: Text(
                "${provider.getPaymentMethodName(order.paymentGatewayId)}",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              message: '${order.id}',
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${NumberFormat.simpleCurrency(decimalDigits: 0).format(order.amount)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Order No. ',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      order.orderIdS!.isNotEmpty
                          ? '${order.orderIdS}'
                          : '_______',
                      style: TextStyle(
                        fontSize: 11,
                        color: order.orderIdS!.isNotEmpty
                            ? Colors.white70
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Ref No. ',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                      ),
                    ),
                    SelectableText(
                      '${order.id}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                if (order.test)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Card(
                      color: errorColor,
                      margin: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        child: Text(
                          'Test Order',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "${timeAgo.contains('now') ? timeAgo : (timeAgo + ' ago')}",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                provider.getStatusText(order.financialStatus),
              ],
            ),
            onTap: () {
              if (order.orderIdS != null) {
                provider.launchOrderURL(context, order.orderIdS!);
              }
            },
          ),
        );
      },
    );
  }
}
