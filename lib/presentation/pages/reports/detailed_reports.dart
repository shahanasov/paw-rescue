import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paw_catcher_admin/core/fonts.dart';
import 'package:paw_catcher_admin/core/theme.dart';
import 'package:paw_catcher_admin/presentation/pages/home/home.dart';
import 'package:paw_catcher_admin/presentation/pages/reports/widget/volunteer.dart';
import 'package:paw_catcher_admin/services/data/report_services.dart';
import 'package:paw_catcher_admin/services/model/report_model.dart';

class DetailPage extends ConsumerWidget {
  final ReportModel reportModel;
  const DetailPage({super.key, required this.reportModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final time = getFormattedTimestamp(reportModel.time);
    final placeAsync = ref.watch(placeNameProvider(reportModel.location));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Paw Rescue',
          style: Fonts.poppins,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            // show location here and can go to map in app also give a rootmap here
            Text(reportModel.title),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  color: AppTheme.softPink,
                  borderRadius: BorderRadius.circular(10)),
              height: 180,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                placeAsync.when(
                  data: (place) => SizedBox(
                      width: 200,
                      child: GestureDetector(
                          onTap: () {
                            // Navigate to HomePage with location data
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(
                                  location: reportModel.location,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            place,
                            overflow: TextOverflow.ellipsis,
                          ))),
                  loading: () => Text(
                    "Loading...",
                    style: Fonts.poppins,
                  ),
                  error: (err, stack) => Text(
                    "Location error",
                    style: Fonts.poppins,
                  ),
                ),
                Text(time)
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(reportModel.report),
            SizedBox(
              height: 10,
            ),
            // option for valandiar if some one taken show that too
            volunteerButton(context: context,reportId:  reportModel.reportId)
          ],
        ),
      ),
    );
  }


}
