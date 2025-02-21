import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

final locationProvider = FutureProvider<LatLng?>((ref) async {
  Location locationController = Location();
  LatLng? currentPosition;
  bool serviceEnabled;
  PermissionStatus permissionGranted;

  // Step 1: Check if location services are enabled
  serviceEnabled = await locationController.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await locationController.requestService();
    if (!serviceEnabled) {
      log("User denied enabling location services");
      return null; // User denied enabling location services
    }
  }

  // Step 2: Check and request location permissions
  permissionGranted = await locationController.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await locationController.requestPermission();
    if (permissionGranted == PermissionStatus.denied) {
      log("User denied location permission");
      return null; // Permission denied
    }
  }

  // **Fix: Handle Permanently Denied Permission**
  if (permissionGranted == PermissionStatus.deniedForever) {
    log("Location permission is permanently denied. Ask the user to enable it in settings.");
    return null;
  }

  // Step 3: Fetch the current location
  LocationData currentLocation = await locationController.getLocation();
  if (currentLocation.latitude != null && currentLocation.longitude != null) {
    currentPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
    log("Current Location: $currentPosition");
  }
  
  return currentPosition;
});
