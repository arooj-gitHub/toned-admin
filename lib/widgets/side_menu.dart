import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:toned_australia/controllers/menu_controller.dart';

import '../constants.dart';
import '../responsive.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Center(
              child: Text(
                'Toned AU',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 33),
          ),
          DrawerListTile(
            title: "In App Customers",
            svgSrc: "assets/icons/menu_store.svg",
            screenNo: 0,
          ),
          DrawerListTile(
            title: "Groups",
            svgSrc: "assets/icons/menu_tran.svg",
            screenNo: 1,
          ),
          DrawerListTile(
            title: "Admin-Created-Customer",
            svgSrc: "assets/icons/menu_store.svg",
            screenNo: 2,
          ),
          DrawerListTile(
            title: "Exercise Library",
            svgSrc: "assets/icons/menu_notification.svg",
            screenNo: 3,
          ),
          DrawerListTile(
            title: "Events",
            svgSrc: "assets/icons/menu_profile.svg",
            screenNo: 4,
          ),
          // DrawerListTile(
          //   title: "Chat",
          //   svgSrc: "assets/icons/menu_task.svg",
          //   screenNo: 5,
          // ),
          DrawerListTile(
            title: "Notifications",
            svgSrc: "assets/icons/menu_profile.svg",
            screenNo: 5,
          ),
          DrawerListTile(
            title: "Settings",
            svgSrc: "assets/icons/menu_setting.svg",
            screenNo: 6,
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.screenNo,
  }) : super(key: key);

  final String title, svgSrc;
  final int screenNo;

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<CMenuController>(context);
    return ListTile(
      onTap: () {
        _provider.currentIndex = screenNo;
        if (!Responsive.isDesktop(context)) {
          Navigator.pop(context);
        }
      },
      horizontalTitleGap: 0.0,
      selectedTileColor: bgColor,
      selected: _provider.currentIndex.compareTo(screenNo) == 0 ? true : false,
      leading: SvgPicture.asset(
        svgSrc,
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
