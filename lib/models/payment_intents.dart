import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:toned_australia/services/datetime_converter.dart';

class PaymentIntents {
  final String? clientSecret, currency, storeName, storeType, transferGroup;
  final num? amount;
  final DateTime created;

  PaymentIntents({
    required this.clientSecret,
    required this.currency,
    required this.storeName,
    required this.storeType,
    required this.transferGroup,
    required this.amount,
    required this.created,
  });

  factory PaymentIntents.fromJson(DocumentSnapshot documentSnapshot) {
    var doc = documentSnapshot['data']['object'];
    num amount = doc['amount']/100;
    DateFormat();
    return PaymentIntents(
      clientSecret: doc['client_secret'],
      currency: doc['currency'],
      storeName: doc['metadata']['store'],
      storeType: doc['metadata']['type'],
      transferGroup: doc['transfer_group'],
      amount: amount,
      created: DateTimeConverter().convertIntTimestamp(doc['created']),
    );
  }
}
