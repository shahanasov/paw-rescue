import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:paw_catcher_admin/core/theme.dart';
import 'package:paw_catcher_admin/services/data/map_services.dart';

class MyGoogleMap extends ConsumerWidget {
  const MyGoogleMap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsyncValue = ref.watch(locationProvider);
    LatLng kerala = LatLng(10.850516, 76.271080);
    return locationAsyncValue.when(
      data: (currentPosition) {
        return GoogleMap(
            initialCameraPosition:
                CameraPosition(target: currentPosition ?? kerala, zoom: 13),
            zoomGesturesEnabled: true,
            markers: {
              if (currentPosition != null)
                Marker(
                    markerId: MarkerId("currentLocation"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: currentPosition),
            },
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
        return Container(
          color: AppTheme.softPink,
          child: Center(
            child: CircularProgressIndicator(
              color: AppTheme.softPink,
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
