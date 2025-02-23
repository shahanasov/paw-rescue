import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:paw_catcher_admin/core/fonts.dart';
import 'package:paw_catcher_admin/presentation/pages/chat/chat_page.dart';
import 'package:paw_catcher_admin/services/data/chat_services.dart';
import 'package:paw_catcher_admin/services/data/report_services.dart';

class MessagedUsersScreen extends ConsumerWidget {
  const MessagedUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    //  messagedUsersProvider with the currentUserId
    if (userId == null) {
      return Container();
    }
    final messagedUsersAsync = ref.watch(messagedUsersProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Messaged Users'),
      ),
      body: messagedUsersAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (messagedUsers) {
          if (messagedUsers.isEmpty) {
            return Center(child: Text('No messaged users found.'));
          }
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView.builder(
              itemCount: messagedUsers.length,
              itemBuilder: (context, index) {
                final user = messagedUsers[index];
                //  need to fetch userdetails to show here
                final String lastMessage =
                    user['lastMessage'] ?? 'No messages yet';
                final Timestamp timestamp =
                    user['lastMessageTimestamp'] ?? Timestamp(0, 0);

                // Convert timestamp to a readable time format
                final String formattedTime = timestamp.toDate().millisecondsSinceEpoch == 0
                    ? 'No timestamp'
                    : getFormattedTimestamp(timestamp.toDate());
                return Card(
                  child: ListTile(
                    title: Text(user['name'] ?? 'No Name',style: Fonts.poppins,),
                    subtitle: Text(lastMessage),
                    trailing: Text(formattedTime),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            recieverId: user['userId'] ?? '',
                            reporterName: user['name'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
