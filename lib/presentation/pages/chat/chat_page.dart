import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paw_catcher_admin/core/theme.dart';
import 'package:paw_catcher_admin/services/data/chat_services.dart';

// ignore: must_be_immutable
class ChatPage extends StatelessWidget {
  // final String recieverEmail;
  final String recieverId;
  final String? message;
  final String? reporterName;
  ChatPage(
      {super.key,
      this.message,
      required this.recieverId,
      this.reporterName
      });

  TextEditingController messageController = TextEditingController();
  final ChatServices chatServices = ChatServices();
  // final Authentication auth = Authentication();

  //send message
  void sendMessage() async {
// if there is something inside the textfield
    if (messageController.text.isNotEmpty) {
      // send the message
      await chatServices.sendMessage(recieverId, messageController.text);
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (message != null) {
      messageController = TextEditingController(text: message);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("$reporterName "),
      ),
      body: Column(
        children: [
          //display all messages
          Expanded(child: _buildMessageList()),
          buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderId = FirebaseAuth.instance.currentUser!.uid;
    String? previousDate;
    return StreamBuilder(
        stream: chatServices.getMessages(senderId, recieverId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading..');
          }
          var messages = snapshot.data!.docs;
          return ListView.builder(
            itemCount: messages.length,
            reverse: false,
            itemBuilder: (context, index) {
              var data = messages[index].data() as Map<String, dynamic>;
              DateTime timestamp = (data['timestamp'] as Timestamp).toDate();
              String currentDate = DateFormat('yyyy-MM-dd').format(timestamp);

              // Show date label if current message date differs from previous message date
              bool showDateLabel = (previousDate != currentDate);
              previousDate = currentDate; // Update after check
              return Column(children: [
                if (showDateLabel) buildDateLabel(currentDate),
                buildMessageItem(data, context)
              ]);
            },
            // children: snapshot.data!.docs
            //     .map((doc) => buildMessageItem(doc, context))
            //     .toList(),
          );
        });
  }

  Widget buildMessageItem(Map<String, dynamic> data, context) {
    // Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // is current user align to right is the current user,otherwise left
    bool isCurrentUser =
        data['senderId'] == FirebaseAuth.instance.currentUser!.uid;
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    DateTime timestamp = (data['timestamp'] as Timestamp).toDate();
    String formattedTime = DateFormat('h:mm a').format(timestamp);

    return ConstrainedBox(
      constraints: BoxConstraints(
        // maxWidth: MediaQuery.of(context).size.width *
        //     0.7, // Limit the width to 70% of the screen
      ),
      child: Container(
          alignment: alignment,
          child: Column(
            crossAxisAlignment: isCurrentUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              // showDateLabel ? buildDateLabel(currentDate) : SizedBox(),
              IntrinsicWidth(
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12),
                          topRight: const Radius.circular(12),
                          bottomLeft: isCurrentUser
                              ? const Radius.circular(12)
                              : Radius.zero,
                          bottomRight: isCurrentUser
                              ? Radius.zero
                              : const Radius.circular(12)),
                      color: isCurrentUser ? Colors.blueGrey : Colors.grey),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 15),
                  margin: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data["message"],
                        softWrap: true,
                      ),
                      const SizedBox(),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            formattedTime,
                            style: const TextStyle(fontSize: 12),
                          ))
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0, left: 10, right: 10),
      child: Row(
        children: [
          // textfield should take up most of the space
          Expanded(
              child: TextFormField(
            autocorrect: true,
            // scrollPadding: EdgeInsets.all(10),
            style: TextStyle(color: AppTheme.textPrimary),
            maxLines: 5,
            minLines: 1,
            decoration: InputDecoration(
                focusColor: AppTheme.backgroundColor,
                filled: true,
                fillColor: AppTheme.backgroundColor,
                hintText: 'message....',
                hintStyle: TextStyle(color: AppTheme.textSecondary),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15))),
            controller: messageController,
            obscureText: false,
          )),
          const SizedBox(
            width: 10,
          ),
          Container(
            decoration: BoxDecoration(color: AppTheme.alertRed, shape: BoxShape.circle),
            child: IconButton(
                onPressed: () {
                  if (message != null) {
                    // UserDatabaseFunctions().requestedService(user.id);
                  }
                  sendMessage();
                },
                icon: Icon(
                  Icons.arrow_upward,
                  
                )),
          )
        ],
      ),
    );
  }

  Widget buildDateLabel(String date) {
    DateTime dateTime = DateFormat('yyyy-MM-dd').parse(date);
    String formattedDate = DateFormat('EEE, MMM d, yyyy').format(dateTime);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            formattedDate,
            style: const TextStyle(color: Colors.black87, fontSize: 12),
          ),
        ),
      ),
    );
  }
}

