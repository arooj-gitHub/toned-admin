import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:toned_australia/constants.dart';
import 'package:toned_australia/controllers/menu_controller.dart';
import 'package:toned_australia/controllers/notifications_provider.dart';
import 'package:toned_australia/controllers/secondary_app_provider.dart';
import 'package:toned_australia/providers/customers_provider.dart';
import 'package:toned_australia/providers/events_provider.dart';
import 'package:toned_australia/providers/exercise_library_provider.dart';
import 'package:toned_australia/providers/groups_provider.dart';
import 'package:toned_australia/providers/notification_provider.dart';
import 'package:toned_australia/services/navigation_service.dart';

import 'app_router.dart';
import 'controllers/auth_service.dart';
import 'locator.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

late final FirebaseMessaging _messaging;

// const firebaseConfig = {
//   apiKey: "AIzaSyDpl4v0Z6xq8yb0EV9UYCZ_yQyJiRaKCxI",
//   authDomain: "toned-australia.firebaseapp.com",
//   projectId: "toned-australia",
//   storageBucket: "toned-australia.appspot.com",
//   messagingSenderId: "1055849239346",
//   appId: "1:1055849239346:web:5e2354453dca0fcce33d2b",
//   measurementId: "G-N4LRK7WN6M"
// };
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDpl4v0Z6xq8yb0EV9UYCZ_yQyJiRaKCxI",
      authDomain: "toned-australia.firebaseapp.com",
      projectId: "toned-australia",
      storageBucket: "toned-australia.appspot.com",
      messagingSenderId: "1055849239346",
      appId: "1:1055849239346:web:5e2354453dca0fcce33d2b",
      measurementId: "G-N4LRK7WN6M",
    ),
  );
  setupLocator();
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp());
  configLoading();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  _messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await _messaging.requestPermission(
    alert: true,
    badge: true,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
    // TODO: handle the received notifications
  } else {
    print('User declined or has not accepted permission');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => EventsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ExerciseLibraryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => GroupsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CustomersProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CMenuController(),
        ),
        // ChangeNotifierProvider(
        //   create: (context) => TestController(),
        //   lazy: false,
        // ),
        ChangeNotifierProvider(
          create: (context) => NotificationsProvider(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationProvider(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => SecondaryAppProvider(),
        ),
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Toned Australia',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: bgColor,
          // textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
          //     .apply(bodyColor: Colors.white),
          canvasColor: secondaryColor,
        ),
        initialRoute: AppRoute.wrapperScreen,
        onGenerateRoute: AppRoute.generateRoute,
        navigatorKey: locator<NavigationService>().navigatorKey,
        builder: EasyLoading.init(),
        // home: LoginScreen(),
      ),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 1200)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.black38
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..dismissOnTap = false
    ..userInteractions = false;
  // ..customAnimation = CustomAnimation();
}
