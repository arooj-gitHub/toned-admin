import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:toned_australia/components/se_text_field.dart';
import 'package:toned_australia/controllers/auth_service.dart';

import '../app_router.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  FocusNode _emailNode = FocusNode();
  FocusNode _passwordNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 55),
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    SeTextField(
                      controller: _email,
                      textInputType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autoFocus: true,
                      hintText: 'Email',
                      focusNode: _emailNode,
                      validator: 1,
                    ),
                    SeTextField(
                      controller: _password,
                      textInputType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      hintText: 'Password',
                      focusNode: _passwordNode,
                      validator: 0,
                      obscure: true,
                      onFieldSubmitted: (val) {
                        _onLoginTap();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoute.forgotScreen),
                child: Container(
                  margin: EdgeInsets.only(right: 50, top: 25),
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: IconButton(onPressed: () => _onLoginTap(), icon: Icon(Icons.login_rounded)),
    );
  }

  Future _onLoginTap() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    EasyLoading.show(status: 'Loading...');
    var _authService = Provider.of<AuthService>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      await _authService.signInUserWithEmail(_email.text, _password.text);
      EasyLoading.dismiss();
    }
    CollectionReference userCollectionRef = FirebaseFirestore.instance.collection('user');
    /*  final credential = await _auth.createUserWithEmailAndPassword(email: "adminEmail@gmail.com", password: "123456");
    CollectionReference userCollectionRef = FirebaseFirestore.instance.collection('user');
    await userCollectionRef.doc(credential.user!.uid).set({
      'uid': credential.user!.uid,
      'email': "adminEmail@gmail.com",
      'username': "admin",
      'status': 1,
      'isAdmin': true,
      'CreatedAt': DateTime.now(),
      "isCreatedByAdmin": true,
    }); */
    /*  await userCollectionRef.get().then((value) async {
      for (var i in value.docs) {
        await userCollectionRef.doc(i.id).delete();
      }
    }); */
    await userCollectionRef.get().then((value) {
      print(value.docs.length);
      for (var i in value.docs) {
        print(i.get("email"));
      }
    });
  }

  /*  final credential = await _auth.createUserWithEmailAndPassword(email: "ab6482843@gmail.com", password: "12345678");
    if (credential.user != null) {}
 */
}
