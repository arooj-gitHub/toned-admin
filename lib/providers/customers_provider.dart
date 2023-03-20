import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:toned_australia/models/user_model.dart';
import 'package:toned_australia/services/navigation_service.dart';

import '../constants.dart';
import '../locator.dart';

class CustomersProvider extends ChangeNotifier {
  final NavigationService _navigationService = locator<NavigationService>();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  CollectionReference userCollectionRef = FirebaseFirestore.instance.collection('user');
  Logger logger = Logger();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirebaseAuth _auth = FirebaseAuth.instance;

  CustomersProvider() {
    if (customersList.isEmpty) {
      clearCustomersList();
      getCustomers();
    }
  }

  List<UserModel> customersList = [];
  List<UserModel> appCustomers = [];

  bool hasMoreCustomers = true; // flag for more docs available or not
  DocumentSnapshot? lastCustomerDocument;

  bool customersLoading = false;

  void clearCustomersList() {
    hasMoreCustomers = true;
    customersList = [];
    appCustomers = [];
    lastCustomerDocument = null;
    notifyListeners();
  }

  Future addNewCustomer(context) async {
    if (email.text != "" && password.text != "" && username.text != "") {
      EasyLoading.show(status: 'Loading...');
      try {
        final credential = await _auth.createUserWithEmailAndPassword(email: email.text, password: password.text);
        if (credential.user != null) {
          await firestore.collection("user").doc(credential.user!.uid).set({
            'uid': credential.user!.uid,
            'email': email.text,
            'username': username.text,
            'status': 1,
            'isAdmin': false,
            'CreatedAt': DateTime.now(),
            "isCreatedByAdmin": true,
            "token": "",
          }).then((value) {
            EasyLoading.showSuccess('Customer Added Successfully');
            customersList.add(UserModel(
              uId: credential.user!.uid,
              email: email.text,
              name: username.text,
              status: 1,
              createAt: DateTime.now(),
              isAdmin: false,
            ));
            email.clear();
            username.clear();
            password.clear();
            Navigator.pop(context);
          });
        }
      } catch (e) {
        print(e.toString());
        EasyLoading.showError(e.toString());
      }
    } else {
      EasyLoading.showError("Fields cannot be null");
    }

    notifyListeners();
  }

  Future getCustomers() async {
    customersList.clear();
    try {
      Query query = userCollectionRef.where("isCreatedByAdmin", isEqualTo: true).orderBy('CreatedAt', descending: true);
      QuerySnapshot querySnapshot;
      if (lastCustomerDocument == null)
        querySnapshot = await query.get();
      else
        querySnapshot = await query.startAfterDocument(lastCustomerDocument!).get();
      print('count ${querySnapshot.docs.length}');

      if (querySnapshot.docs.isNotEmpty) {
        if (querySnapshot.docs.length < 10) hasMoreCustomers = false;
        lastCustomerDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
        querySnapshot.docs.forEach((doc) {
          logger.wtf('Users Doc -> ${doc.data()}');
          customersList.add(UserModel.fromJson(doc));
        });
      } else {
        hasMoreCustomers = false;
      }
      customersLoading = false;
    } catch (err) {
      logger.e('$err');
    }
    notifyListeners();
  }

  Future getAppCustomers() async {
    customersList.clear();
    appCustomers.clear();
    try {
      Query query = userCollectionRef.where("isCreatedByAdmin", isEqualTo: false).orderBy('CreatedAt', descending: true).limit(10);
      QuerySnapshot querySnapshot;
      if (lastCustomerDocument == null)
        querySnapshot = await query.get();
      else
        querySnapshot = await query.startAfterDocument(lastCustomerDocument!).get();
      print('count ${querySnapshot.docs.length}');

      if (querySnapshot.docs.isNotEmpty) {
        if (querySnapshot.docs.length < 10) hasMoreCustomers = false;
        lastCustomerDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
        querySnapshot.docs.forEach((doc) {
          logger.wtf('App Users Doc -> ${doc.data()}');
          appCustomers.add(UserModel.fromJson(doc));
        });
      } else {
        hasMoreCustomers = false;
      }
      customersLoading = false;
    } catch (err) {
      logger.e('$err');
    }
    notifyListeners();
  }

  Widget getStatusText(int status) {
    String name = 'Blocked';
    Color color = getColor(status);
    switch (status) {
      case 0:
        name = 'NEW';
        break;
      case 1:
        name = 'Paid User';
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
          style: TextStyle(color: status == 0 ? Colors.black : Colors.white, fontSize: 10),
        ),
      ),
    );
  }

  Color getColor(int status) {
    Color color = errorColor;
    switch (status) {
      case 0:
        color = Colors.yellow;
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

  updateCustomerBlockStatus(id) async {
    await userCollectionRef.doc(id).update({
      "status": 2,
    });
    for (var i in customersList) {
      if (i.uId == id) {
        i.status = 2;
      }
    }
    notifyListeners();
  }

  UnBlockCustomer(id) async {
    await userCollectionRef.doc(id).update({
      "status": 1,
    });
    for (var i in customersList) {
      if (i.uId == id) {
        i.status = 1;
      }
    }
    notifyListeners();
  }

//#endregion
}
