import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paw_catcher_admin/services/model/message_model.dart';

class ChatServices {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> sendMessage(String recieverId,String message) async {
    //get current user info

    final String userEmailId = FirebaseAuth.instance.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
    
    // String name =await getSenderDetails(userId);
    //create a new message
    MessageModel newMessage = MessageModel(
      senderId: userId,
      senderEmail: userEmailId,
      recieverId: recieverId,
      message: message,
      timestamp: timestamp,
    );
    //  construct chat room id for 2 users(sorted to ensure uniqueness)
    List<String> ids = [userId, recieverId];
    ids.sort(); //sort the ids (to ensure chatroomid is the same for any 2 people)
    String chatroomId = ids.join('_');
    await FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(chatroomId)
        .set(
            {
          'participants': ids, // Ensure both participants are listed
          'lastMessageTimestamp':
              timestamp, // Optionally, track when the last message was sent
              'lastMessage':message,
              
        },
            SetOptions(
                merge:
                    true)); // Merge to prevent overwriting any existing fields

    // Add the new message to the messages sub-collection
    await FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(chatroomId)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // add new message to database
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    //construct a chatroom id for the two users
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatroomId = ids.join('_');
    return FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatroomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Fetch chat rooms for the current user


  // Function to fetch messaged users
  Future<List<String>> getMessagedUsers(String currentUserId) async {
    List<String> messagedUserIds = [];

    // Query chat_rooms collection where the current user is a participant
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('chat_rooms')
        .where('participants', arrayContains: currentUserId)
        .get();

    // Iterate through the chat rooms and extract the other user IDs
    for (var doc in querySnapshot.docs) {
      List<String> participants = List<String>.from(doc['participants']);
      // Remove the current user from the participants list to get the other user
      participants.remove(currentUserId);
      if (participants.isNotEmpty) {
        messagedUserIds.add(participants.first); // Add the other user ID
      }
    }

    return messagedUserIds;
  }


      Future<List<Timestamp>> lastMessaged(String currentUserId) async {
    List<Timestamp> messagedTime = [];
    
    // Query chat_rooms collection where the current user is a participant
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('chat_rooms')
        .where('participants', arrayContains: currentUserId)
        .get();

    // Iterate through the chat rooms and extract the last message timestamp
    for (var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>?;  // Safely cast to a Map
      if (data != null && data.containsKey('lastMessageTimestamp')) {
        Timestamp time = data['lastMessageTimestamp'];
        messagedTime.add(time);
      }
    }

    // Return the list of message timestamps sorted in descending order (latest first)
    messagedTime.sort((a, b) => b.compareTo(a));
    
    return messagedTime;
  }


      Future<Map<String, dynamic>?> getSenderDetails(String senderId) async {
    try {
      final document = await FirebaseFirestore.instance.collection('Users').doc(senderId).get();
      if (document.exists) {
        return document.data();
      } else {
        return null;
      }
    } catch (e) {
      log('Error fetching volunteer details: $e');
      rethrow;
    }
  }


  Future<List<Map<String, dynamic>>> getMessagedUsersWithDetails(String currentUserId) async {
  try {
    // Step 1: Fetch messaged user IDs
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('chat_rooms')
        .where('participants', arrayContains: currentUserId)
        .get();

    List<Map<String, dynamic>> messagedUsersWithDetails = [];

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      List<String> participants = List<String>.from(data['participants']);
      participants.remove(currentUserId); // Get the other user
      String otherUserId = participants.first;

      // Fetch sender details
      Map<String, dynamic>? userDetails = await getSenderDetails(otherUserId);
      if (userDetails != null) {
        messagedUsersWithDetails.add({
          'userId': otherUserId,
          'name': userDetails['name'] ?? 'Unknown User',
          'profilePic': userDetails['profilePic'] ?? '', // Optional
          'lastMessage': data['lastMessage'] ?? 'No messages yet',
          'lastMessageTimestamp': data['lastMessageTimestamp'] ?? Timestamp(0, 0),
        });
      }
    }

    // Sort the list by lastMessageTimestamp (latest first)
    messagedUsersWithDetails.sort((a, b) {
      Timestamp timeA = a['lastMessageTimestamp'];
      Timestamp timeB = b['lastMessageTimestamp'];
      return timeB.compareTo(timeA); // Descending order
    });

    return messagedUsersWithDetails;
  } catch (e) {
    log('Error fetching messaged users with details: $e');
    rethrow;
  }
}

}

 
//  final messagedUsersProvider = StreamProvider.family<List<Map<String, dynamic>>, String>((ref, userId) {
//   return FirebaseFirestore.instance
//       .collection('chat_rooms')
//       .where('participants', arrayContains: userId) // Fetch all rooms where user is a participant
//       .snapshots()
//       .map((snapshot) {
//         return snapshot.docs.map((doc) {
//           final data = doc.data();
//           return {
//             'chatRoomId': doc.id,
//             'lastMessage': data['lastMessage'] ?? '',
//             'lastMessageTimestamp': data['lastMessageTimestamp'],
//             'participants': data['participants'],
//           };
//         }).toList();
//       });
// });

final chatRoomService = ChatServices();
// Define the FutureProvider globally


final messagedUsersProvider = FutureProvider.family<List<Map<String, dynamic>>, String>(
  (ref, currentUserId) async {
    return chatRoomService.getMessagedUsersWithDetails(currentUserId);
  },
);