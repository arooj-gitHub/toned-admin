import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:toned_australia/constants.dart';
import 'package:toned_australia/models/order.dart';
import 'package:toned_australia/services/navigation_service.dart';

import '../locator.dart';

class SecondaryAppProvider extends ChangeNotifier {
  final NavigationService _navigationService = locator<NavigationService>();
  Logger logger = Logger();
  late FirebaseApp secondaryApp;
  late FirebaseFirestore _secondaryFirestore;

  Future<void> getConfig() async {
    try {
      secondaryApp = Firebase.app('secondaryApp');
      _secondaryFirestore = FirebaseFirestore.instanceFor(app: secondaryApp);
      var doc =
          await _secondaryFirestore.collection('config').doc('config').get();
      if (doc.exists) {
        logger.wtf('config -> ${doc.data()}');
        getOrders();
        return;
      }
    } catch (e) {
      logger.e(e);
    }
  }

  /// ORDERS PAGINATION

  //#region

  List<OrderModel> ordersList = [];

  bool hasMoreOrders = true; // flag for more docs available or not
  DocumentSnapshot? lastOrderDocument;

  bool ordersLoading = false;

  void clearOrdersList() {
    hasMoreOrders = true;
    ordersList = [];
    lastOrderDocument = null;
  }

  Future getOrders() async {
    try {
      if (ordersLoading || !hasMoreOrders) {
        logger.wtf('Loading or No More Orders');
        return;
      }
      ordersLoading = true;
      notifyListeners();

      Query query = _secondaryFirestore
          .collection('shopify_orders')
          .orderBy('doc', descending: true)
          .limit(10);
      QuerySnapshot querySnapshot;
      if (lastOrderDocument == null)
        querySnapshot = await query.get();
      else
        querySnapshot =
            await query.startAfterDocument(lastOrderDocument!).get();
      if (querySnapshot.docs.isNotEmpty) {
        if (querySnapshot.docs.length < 10) hasMoreOrders = false;
        lastOrderDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
        querySnapshot.docs.forEach((doc) {
          logger.wtf('Order Doc -> ${doc.data()}');
          ordersList.add(OrderModel.fromJson(doc) );
        });
      } else {
        hasMoreOrders = false;
      }
      ordersLoading = false;
      notifyListeners();
    } catch (err) {
      logger.e('$err');
    }
  }

  String getPaymentMethodName(num paymentGatewayId) {
    String name = 'Undefined';
    switch (paymentGatewayId) {
      case 1:
        name = 'LayBuy';
        break;
      case 2:
        name = 'PayPal';
        break;
      case 3:
        name = 'Card';
        break;
      case 4:
        name = 'AfterPay';
        break;
      case 5:
        name = 'ZipPay';
        break;
      default:
        break;
    }
    return name;
  }

  Widget getStatusText(int status) {
    String name = 'Undefined';
    Color color = getColor(status);
    switch (status) {
      case 0:
        name = 'Pending';
        break;
      case 1:
        name = 'Paid';
        break;
      default:
        break;
    }
    return Card(
      color: color,
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Text(
          name,
          style: TextStyle(color: Colors.white, fontSize: 10),
        ),
      ),
    );
  }

  Color getColor(int status) {
    Color color = errorColor;
    switch (status) {
      case 0:
        color = errorColor;
        break;
      case 1:
        color = successColor;
        break;
      default:
        color = errorColor;
        break;
    }
    return color;
  }

//#endregion

  void launchOrderURL(BuildContext context, String orderNo) async {
    //   var _provider = Provider.of<AuthService>(context, listen: false);
    //   String url = '';
    //   switch (_provider.currentUser!.config.storeType) {
    //     case 'shopify':
    //       url = '${_provider.currentUser!.config.storeLink}/admin/orders/$orderNo';
    //       break;
    //     case 'woo':
    //       url = '${_provider.currentUser!.config.storeLink}/admin/orders/$orderNo';
    //       break;
    //     default:
    //       break;
    //   }
    //   await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }
}
