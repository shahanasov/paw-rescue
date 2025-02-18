
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paw_catcher_admin/core/theme.dart';
import 'package:paw_catcher_admin/presentation/pages/reports/widget/reports_show.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:paw_catcher_admin/services/data/report.dart';

// Riverpod provider to control the sheet height
final sheetHeightProvider = StateProvider<double>((ref) => 0.3);

class CostumDraggableScrollableSheet extends ConsumerWidget {
  const CostumDraggableScrollableSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sheetHeight = ref.watch(sheetHeightProvider);
    final reports = ref.watch(reportsProvider);
    final connectivity = ref.watch(connectivityProvider).value;
// !should change from here i completely block everything
    if (connectivity == ConnectivityResult.none) {
      return const Center(
        child: Text(
          "No internet connection",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
        ),
      );
    }
    return DraggableScrollableSheet(
        expand: true,
        initialChildSize: sheetHeight, // 30% of screen height initially
        minChildSize: 0.2, // Minimum 20% when dragged down
        maxChildSize: 0.95, // Expandable to 90% when dragged up
        builder: (BuildContext context, ScrollController scrollController) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
            ),
            child: Column(
              children: [
                // Drag Indicator (like Instagram)
                GestureDetector(
                  behavior: HitTestBehavior.opaque, // Ensures touch is detected
                  onVerticalDragUpdate: (details) {
                    final newSize = sheetHeight - details.primaryDelta! / 400;
                    ref.read(sheetHeightProvider.notifier).state =
                        newSize.clamp(0.2, 0.9);
                  },
                  onVerticalDragEnd: (details) {
                    // Snap to nearest state (collapsed or expanded)
                    ref.read(sheetHeightProvider.notifier).state =
                        sheetHeight > 0.5 ? 0.9 : 0.3;
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: reports.when(
                      data: (reportsList) {
                        if (reportsList.isEmpty) {
                          return const Center(
                            child: Text(
                              "No reports available",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          );
                        }
                        return ReportsPage(reportsList: reportsList,scrollController:scrollController);
                      },
                      error: (err, stack) => Center(child: Text("Error: $err")),

                      loading: () => Center(
                            child: CircularProgressIndicator(
                              color: AppTheme().softPink,
                            ),
                          )),
                )
              ],
            ),
          );
        });
  }
}
