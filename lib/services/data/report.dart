import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paw_catcher_admin/services/model/report_model.dart';
import 'package:timeago/timeago.dart' as timeago; 
final reportsProvider = StreamProvider.autoDispose<List<ReportModel>>((ref) {
  return FirebaseFirestore.instance
      .collection('Reports')
      .snapshots() // Listen for real-time updates
      .map((snapshot) => snapshot.docs
          .map((doc) => ReportModel.fromSnapshot(doc))
          .toList()); // Convert to List<ReportModel>
});

 String getFormattedTimestamp(DateTime timestamp) {
  return timeago.format(timestamp, locale: 'en');
}

final connectivityProvider = StreamProvider<ConnectivityResult>((ref) {
  return Connectivity().onConnectivityChanged.map((results) => results
      .first); // Convert List<ConnectivityResult> to a single ConnectivityResult
});