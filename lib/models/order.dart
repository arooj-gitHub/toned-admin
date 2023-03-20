import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toned_australia/services/datetime_converter.dart';

class OrderModel {
  String id, paymentGatewayOrderId;
  String? customerIdS, orderIdS;
  num amount;
  int financialStatus, paymentGatewayId;
  bool test;
  DateTime? doc, dop;

  OrderModel({
    required this.id,
    required this.customerIdS,
    required this.orderIdS,
    required this.paymentGatewayOrderId,
    required this.amount,
    required this.financialStatus,
    required this.paymentGatewayId,
    required this.test,
    required this.doc,
    required this.dop,
  });

  factory OrderModel.fromJson(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      customerIdS: '${map['customer_id'] ?? ''}'.toString(),
      orderIdS: '${map['order_id'] ?? ''}'.toString(),
      paymentGatewayOrderId: map['payment_gateway_id'].toString(),
      amount: map['amount'],
      financialStatus: map['financial_status'] ?? 0,
      paymentGatewayId: map['payment_gateway_id'],
      test: map['test'],
      doc: DateTimeConverter().convert(map['doc']),
      dop: map['dop'] == null ? null : DateTimeConverter().convert(map['dop']),
    );
  }
}
