import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  String title;
  String report;
  // String imagePath;
  String auther;
  DateTime time;
  ReportModel(
      {required this.title,
      required this.report,
      required this.auther,
      required this.time,
      // required this.imagePath
      });

  //  Convert Firestore document snapshot to UserModel
  static ReportModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Timestamp timestamp = snapshot.get('time') as Timestamp;
    return ReportModel(
        auther: snapshot.get('auther') as String,
        title: snapshot.get('title') as String,
        report: snapshot.get('report') as String,
        // imagePath: snapshot.get('imagePath') as String,
        time: timestamp.toDate());
  }

  // Convert UserModel to JSON for storing in Firestore
  Map<String, dynamic> toJson() {
    return {
      'auther': auther,
      'title': title,
      'report': report,
      // 'imagePath': imagePath,
      'time': time
    };
  }
}
