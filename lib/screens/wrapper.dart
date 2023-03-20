import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toned_australia/components/circular_progress.dart';
import 'package:toned_australia/controllers/auth_service.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  void initState() {
    Provider.of<AuthService>(context, listen: false).checkCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Fetching user details',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
            ),
            CircularProgress(),
          ],
        ),
      ),
    );

    // final authService = Provider.of<AuthService>(context);
    // return StreamBuilder<User?>(
    //   stream: authService.user,
    //   builder: (_, AsyncSnapshot<User?> snapshot){
    //     if(snapshot.connectionState == ConnectionState.active){
    //       final User? user = snapshot.data;
    //       return user == null ? LoginScreen() : MainScreen();
    //     } else if(snapshot.connectionState == ConnectionState.waiting){
    //       return Scaffold(body: Center(child: CircularProgressIndicator(),),);
    //     } else{
    //       return Scaffold(body: Center(child: Text(snapshot.error.toString()),),);
    //     }
    //   },
    // );
  }
}
