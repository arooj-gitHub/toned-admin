import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toned_australia/controllers/menu_controller.dart';
import 'package:toned_australia/responsive.dart';
import 'package:toned_australia/screens/customers/customers_screen.dart';
import 'package:toned_australia/screens/events/events_screen.dart';
import 'package:toned_australia/screens/exercises_library/exercises_library_screen.dart';
import 'package:toned_australia/screens/groups/groups_screen.dart';
import 'package:toned_australia/screens/settings/settings_screen.dart';
import 'package:toned_australia/widgets/side_menu.dart';

import '../../Notification/notifications.dart';
import '../../admin-Profile/appUsers.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CMenuController>(
      builder: (context, provider, child) {
        return Scaffold(
          key: context.read<CMenuController>().scaffoldKey,
          drawer: SideMenu(),
          body: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // We want this side menu only for large screen
                if (Responsive.isDesktop(context))
                  Expanded(
                    // default flex = 1
                    // and it takes 1/6 part of the screen
                    child: SideMenu(),
                  ),
                Expanded(
                  // It takes 5/6 part of the screen
                  flex: 5,
                  child: currentTab[provider.currentIndex],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

var currentTab = [
  AppUsers(),
  GroupsScreen(),
  CustomersScreen(),
  ExercisesLibraryScreen(),
  EventsScreen(),
  Notifications(),
  // ChatScreen(),
  SettingsScreen(),
];
