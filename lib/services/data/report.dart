import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:paw_catcher_admin/services/model/report_model.dart';
import 'package:timeago/timeago.dart' as timeago; 
import 'package:http/http.dart' as http;
import 'dart:convert';


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



//  to fetch only nearby reports
// Fetch user location using new locationSettings approach
// Fetch user location
final locationProvider = FutureProvider<Position>((ref) async {
  LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10, // Min distance before an update
  );

  return await Geolocator.getCurrentPosition(
      locationSettings: locationSettings);
});

// Fetch and filter nearby reports **without modifying ReportModel**
final nearbyReportsProvider =
    StreamProvider.autoDispose<List<ReportModel>>((ref) async* {
  final position = await ref.watch(locationProvider.future);
  const double maxDistance = 5.0; // Max distance in km

  yield* FirebaseFirestore.instance
      .collection('Reports')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => ReportModel.fromSnapshot(doc))
        .where((report) {
      // Calculate distance dynamically
      final distance = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            report.location.latitude,
            report.location.longitude,
          ) /
          1000; // Convert meters to km



      return distance <= maxDistance; // Keep only nearby reports
    }).toList();
  });
});





Future<String> fetchPlaceName(GeoPoint location) async {
  final apiKey = "AIzaSyBzyHjj4QgqqdYjFmX3pcnfpgZ1Uc_NqYo";
  final url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${location.latitude},${location.longitude}&key=$apiKey";
 try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data["status"] == "OK") {
        return data["results"][0]["formatted_address"];
      }
    }
    return "Unknown Location";
  } catch (e) {
    log("Error fetching location: $e");
    return "Error fetching location";
  }
}

// Create a Riverpod FutureProvider
final placeNameProvider = FutureProvider.family<String, GeoPoint>((ref, location) async {
  return await fetchPlaceName(location);
});
