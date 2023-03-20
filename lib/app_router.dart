import 'package:flutter/material.dart';
import 'package:toned_australia/screens/forget_pass_screen.dart';
import 'package:toned_australia/screens/groups/exercise_screen.dart';
import 'package:toned_australia/screens/groups/group_users_screen.dart';
import 'package:toned_australia/screens/login_screen.dart';
import 'package:toned_australia/screens/wrapper.dart';

import 'screens/groups/add_exercise_screen.dart';
import 'screens/groups/programs_screen.dart';
import 'screens/main/main_screen.dart';
import 'screens/orders/orders_screen.dart';

class PageViewTransition<T> extends MaterialPageRoute<T> {
  PageViewTransition({required WidgetBuilder builder, RouteSettings? settings}) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
//    if (settings.isInitialRoute) return child;
    if (animation.status == AnimationStatus.reverse) return super.buildTransitions(context, animation, secondaryAnimation, child);
    return FadeTransition(opacity: animation, child: child);
  }
}

class AppRoute {
  static const String wrapperScreen = '/';
  static const String loginScreen = '/login';
  static const String mainScreen = '/main';
  static const String ordersScreen = '/orders';
  static const String storesScreen = '/stores';
  static const String notificationsScreen = '/notifications';
  static const String profileScreen = '/profile';
  static const String settingsScreen = '/settings';
  static const String programsScreen = '/programs';
  static const String exerciseScreen = '/exercise';
  static const String addExerciseScreen = '/addExercise';
  static const String groupsUserScreen = '/groupsUser';
  static const String forgotScreen = '/forget';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case wrapperScreen:
        return PageViewTransition(builder: (_) => Wrapper());
      case mainScreen:
        return PageViewTransition(builder: (_) => MainScreen());
      case loginScreen:
        return PageViewTransition(builder: (_) => LoginScreen());
      case ordersScreen:
        return PageViewTransition(builder: (_) => OrdersScreen());
      case programsScreen:
        return PageViewTransition(builder: (_) => ProgramsScreen());
      case exerciseScreen:
        return PageViewTransition(builder: (_) => ExerciseScreen());
      case addExerciseScreen:
        return PageViewTransition(builder: (_) => AddExerciseScreen());
      case groupsUserScreen:
        return PageViewTransition(builder: (_) => GroupUsersScreen());
      case forgotScreen:
        return PageViewTransition(builder: (_) => ForgetPassScreen());
      default:
        return PageViewTransition(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
