import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:paw_catcher_admin/core/theme.dart';
import 'package:paw_catcher_admin/presentation/pages/reports/detailed_reports.dart';
import 'package:paw_catcher_admin/services/data/report.dart';

class NotificationPage extends ConsumerWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(nearbyReportsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Nearby Reports",
          style: TextStyle(color: AppTheme.backgroundColor),
        ),
        backgroundColor: AppTheme.alertRed,
      ),
      body: reportsAsync.when(
        data: (reports) {
          return reports.isEmpty
              ? const Center(child: Text("No nearby reports found"))
              : ListView.builder(
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final report = reports[index];

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  DetailPage(reportModel: report)));
                        },
                        leading:
                            const Icon(Icons.location_on, color: Colors.red),
                        title: Text(report.title,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: FutureBuilder<double>(
                          future: _calculateDistance(report.location.latitude,
                              report.location.longitude),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text("Calculating distance...");
                            } else if (snapshot.hasError) {
                              return const Text("Error getting distance");
                            } else {
                              return Text(
                                  "Distance: ${snapshot.data!.toStringAsFixed(2)} km");
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text("Error: $error")),
      ),
    );
  }

  // Function to calculate distance dynamically
  Future<double> _calculateDistance(double lat, double lon) async {
    Position position = await Geolocator.getCurrentPosition();
    return Geolocator.distanceBetween(
            position.latitude, position.longitude, lat, lon) /
        1000; // Convert to km
  }
}
