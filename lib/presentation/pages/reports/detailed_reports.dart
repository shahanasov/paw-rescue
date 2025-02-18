import 'package:flutter/material.dart';
import 'package:paw_catcher_admin/core/theme.dart';
import 'package:paw_catcher_admin/services/data/report.dart';
import 'package:paw_catcher_admin/services/model/report_model.dart';

class DetailPage extends StatelessWidget {
  final ReportModel reportModel;
  const DetailPage({super.key, required this.reportModel});

  @override
  Widget build(BuildContext context) {
    final time = getFormattedTimestamp(reportModel.time);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Paw Rescue',
          // style: Fonts.poppins,
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
                  color: AppTheme().softPink,
                  borderRadius: BorderRadius.circular(10)),
              height: 180,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('place'), Text(time)],
            ),
            SizedBox(
              height: 10,
            ),
            Text(reportModel.report),
            SizedBox(
              height: 10,
            ),
            // option for valandiar if some one taken show that too
          ],
        ),
      ),
    );
  }
}
