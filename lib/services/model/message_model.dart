import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String senderEmail;
  final String recieverId;
  final String message;
  final Timestamp timestamp;

  MessageModel(
      {required this.senderId,
      required this.senderEmail,
      required this.recieverId,
      required this.message,
      required this.timestamp});

  //convert to map
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'recieverId': recieverId,
      'message': message,
      'timestamp': timestamp
    };
  }

 static MessageModel fromMap(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return MessageModel(
      senderId: snapshot.get('senderId') as String,
      senderEmail: snapshot.get('senderEmail') as String,
      recieverId: snapshot.get('recieverId') as String,
      message: snapshot.get('message') as String,
      timestamp: snapshot.get('timestamp') as Timestamp,
    );
  }
}
