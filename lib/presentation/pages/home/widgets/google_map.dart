import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:paw_catcher_admin/core/theme.dart';
import 'package:paw_catcher_admin/services/data/map_services.dart';
import 'package:shimmer/shimmer.dart';

class MyGoogleMap extends ConsumerWidget {
  final GeoPoint? selectedLocation;
  const MyGoogleMap({super.key, this.selectedLocation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsyncValue = ref.watch(locationProvider);
    LatLng kerala = LatLng(10.850516, 76.271080);
    return locationAsyncValue.when(
      data: (currentPosition) {
        Set<Marker> markers = {};

        // Add current location marker
        if (currentPosition != null) {
          markers.add(
            Marker(
              markerId: MarkerId("currentLocation"),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
              position: currentPosition,
              infoWindow: InfoWindow(title: "You are here"),
            ),
          );
        }

        // Add selected location marker
        if (selectedLocation != null) {
          LatLng reportedPlace =
              LatLng(selectedLocation!.latitude, selectedLocation!.longitude);
          markers.add(
            Marker(
              markerId: MarkerId("Reported Area"),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
              position: reportedPlace,
              infoWindow: InfoWindow(title: "Reported Area"),
            ),
          );
        }

        return GoogleMap(
            initialCameraPosition:
                CameraPosition(target: currentPosition ?? kerala, zoom: 13),
            zoomGesturesEnabled: true,
            markers: markers,
            circles: {
              if (currentPosition != null)
                Circle(
                    circleId: CircleId("nearby_radius"),
                    center: currentPosition,
                    radius: 500,
                    fillColor: AppTheme.yellow,
                    strokeColor: AppTheme.yellow,
                    strokeWidth: 1)
            });
      },
      loading: () {
        // loading just like gpay
        return Shimmer.fromColors(
          baseColor: AppTheme.softPink,
          highlightColor: AppTheme.softPink,
          child: Container(
            color: AppTheme.softPink,
            child: Center(
              child: CircularProgressIndicator(
                color: AppTheme.softPink,
              ),
            ),
          ),
        );
      },
      error: (error, stack) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error: $error'),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(locationProvider); // Retry permission request
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
