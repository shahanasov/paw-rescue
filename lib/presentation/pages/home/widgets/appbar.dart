import 'package:flutter/material.dart';
import 'package:paw_catcher_admin/presentation/pages/notification/notification_page.dart';

AppBar customAppBar(
    GlobalKey<ScaffoldState> scaffoldKey, BuildContext context) {
  return AppBar(
    actions: [
      SizedBox(
        width: 10,
      ),
      IconButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NotificationPage()));
          },
          icon: Icon(Icons.notification_important_rounded))
    ],
    leading: Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          scaffoldKey.currentState?.openDrawer();
        },
        child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/profiledog.jpg')),
      ),
    ),
    title: Text(
      'Paw Rescue',
    ),
  );
}
