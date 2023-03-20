import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toned_australia/components/se_text_field.dart';
import 'package:toned_australia/controllers/auth_service.dart';

class ForgetPassScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<ForgetPassScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  FocusNode _emailNode = FocusNode();

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
            const Text(
              'Forgot Password',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 55),
                child: Column(
                  children: [
                    SeTextField(
                      controller: _email,
                      textInputType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autoFocus: true,
                      hintText: 'Email',
                      focusNode: _emailNode,
                      validator: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: IconButton(onPressed: () => onForgetPassPress(), icon: Icon(Icons.login_rounded)),
    );
  }

  Future onForgetPassPress() async {
    var _authService = Provider.of<AuthService>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      await _authService.sendChangePasswordLink(_email.text);
    }
  }
}
