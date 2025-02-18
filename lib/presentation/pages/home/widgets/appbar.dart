
import 'package:flutter/material.dart';

AppBar customAppBar(
    GlobalKey<ScaffoldState> scaffoldKey, BuildContext context) {
  return AppBar(
    actions: [SizedBox(width: 10,),
      IconButton(onPressed: (){

    }, icon: Icon(Icons.chat))],
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
    title: Text('Paw Rescue', ),
    
  );
}
