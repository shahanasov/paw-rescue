import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paw_catcher_admin/presentation/pages/home/widgets/appbar.dart';
import 'package:paw_catcher_admin/presentation/pages/home/widgets/custom_draggable.dart';
import 'package:paw_catcher_admin/presentation/pages/home/widgets/customdrawer.dart';
import 'package:paw_catcher_admin/presentation/pages/home/widgets/google_map.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final reports = ref.watch(reportsProvider);
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      appBar: customAppBar(scaffoldKey, context),
      drawer: CustomDrawer(),
      body: Stack(
          fit: StackFit.expand,
          children: [MyGoogleMap(), CostumDraggableScrollableSheet()],
        )
      // reports.when(
      //     data: (reportsList) {
      //       if (reportsList.isEmpty) {
      //         return const Center(
      //           child: Text(
      //             "No reports available",
      //             style: TextStyle(
      //                 fontSize: 16,
      //                 fontWeight: FontWeight.bold,
      //                 color: Colors.grey),
      //           ),
      //         );
      //       }
      //       return CustomGrid(reportsList: reportsList);
      //     },
      //     error: (err, stack) => Center(child: Text("Error: $err")),
      //     loading: () => Center(
      //           child: CircularProgressIndicator(
      //             color: AppTheme().softPink,
      //           ),
      //         )),
    );
  }
}
