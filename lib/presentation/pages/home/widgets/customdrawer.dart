import 'dart:developer';
import 'package:paw_catcher_admin/presentation/pages/chat/chat_rooms.dart';
import 'package:paw_catcher_admin/services/data/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paw_catcher_admin/core/theme.dart';
import 'package:paw_catcher_admin/presentation/auth/sign_in.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetails = ref.watch(userDetailsProvider);
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/images/profiledog.jpg'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            userDetails.when(
              data: (user) {
                log(user?.email ?? '');
                return ListTile(
                  title: Text("Hi ${user?.name ?? ''} 👋"),
                );
              },
              loading: () => ListTile(
                  title: Center(
                      child: LinearProgressIndicator(
                color: AppTheme.softPink,
              ))),
              error: (err, stack) => ListTile(
                  title: Center(
                      child: LinearProgressIndicator(
                color: AppTheme.softPink,
              ))),
            ),
            Card(
                color: AppTheme.softPink,
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MessagedUsersScreen(
                            
                            )));
                  },
                  leading: Icon(Icons.chat),
                  title: Text('Chats'),
                )),
            Card(
              color: AppTheme.softPink,
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
            ),
            Card(
              color: AppTheme.softPink,
              child: ListTile(
                onTap: () {
                  final navigatorContext = Navigator.of(context);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Do you wanna log out'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel')),
                            TextButton(
                                onPressed: () {
                                  signOut();
                                  // Future.delayed(const Duration(seconds: 2),
                                  // () {
                                  navigatorContext.pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => SignInScreen()),
                                  );
                                  // });
                                },
                                child: const Text('Log out'))
                          ],
                        );
                      });
                },
                leading: Icon(Icons.logout),
                title: Text('Log out'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
