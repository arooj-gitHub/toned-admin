import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:toned_australia/components/circular_progress.dart';
import 'package:toned_australia/controllers/secondary_app_provider.dart';
import 'package:toned_australia/screens/dashboard/components/header.dart';

import '../../app_router.dart';
import '../../constants.dart';
import '../../locator.dart';
import '../../services/navigation_service.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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

  FirebaseAuth _auth = FirebaseAuth.instance;
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return Consumer<SecondaryAppProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                Header(title: 'Settings'),
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
                          // return ItemOrder(index: index);
                          return Text('ABC');
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
                            // TODO: Image here
                            TextButton(
                              onPressed: () async {
                                // await signUpUserWithEmail("", "");
                                await _auth.signOut();
                                _navigationService.navigateReplace(AppRoute.loginScreen);
                              },
                              child: Text(
                                "Sign Out",
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              ),
                            ),
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

  Future<User?> signUpUserWithEmail(String email, password) async {
    return null;

    /*   try {
      final credential = await _auth.createUserWithEmailAndPassword(email: "ab6482843@gmail.com", password: "12345678");
      if (credential.user != null) {
        logger.i('user -> ${credential.user!.uid}');
      }
      return credential.user;
    } catch (e) {
      print(e);
    }
    return null; */
    /*  CollectionReference userCollectionRef = FirebaseFirestore.instance.collection('user');

    await userCollectionRef.get().then((value) async {
      for (var i in value.docs) {
        await userCollectionRef.doc(i.id).delete();
      }
    });
    return null; */
  }
}
