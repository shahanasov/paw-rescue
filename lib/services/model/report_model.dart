import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  String title;
  String report;
  String reportId;
  String image;
  String auther;
  DateTime time;
  GeoPoint location;
  bool? volunteer;
  String? volunteerId;
  ReportModel({
    required this.title,
    required this.reportId,
    required this.report,
    required this.auther,
    required this.time,
    required this.location,
    this.volunteer,
    this.volunteerId,
    required this.image
  });

  //  Convert Firestore document snapshot to UserModel
  static ReportModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Timestamp timestamp = snapshot.get('time') as Timestamp;
    GeoPoint location = snapshot.get('location') as GeoPoint;
    return ReportModel(
      image: snapshot.get('image')as String,
        reportId: snapshot.get('reportId') as String,
        auther: snapshot.get('auther') as String,
        title: snapshot.get('title') as String,
        report: snapshot.get('report') as String,
        // imagePath: snapshot.get('imagePath') as String,
        volunteerId: snapshot.data()?.containsKey('volunteerId') == true
        ? snapshot.get('volunteerId') as String?
        : null,
    volunteer: snapshot.data()?.containsKey('volunteer') == true
        ? snapshot.get('volunteer') as bool?
        : null,
          location: location,
        time: timestamp.toDate());
  }

  // Convert UserModel to JSON for storing in Firestore
  Map<String, dynamic> toJson() {
    return {
      'auther': auther,
      'title': title,
      'report': report,
      'reportId': reportId,
      'image': image,
      'volunteer': volunteer,
      'time': time,
      'location': location,
      'volunteerId': volunteerId,
    };
  }
}
