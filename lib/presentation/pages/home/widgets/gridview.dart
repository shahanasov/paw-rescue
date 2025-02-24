import 'package:flutter/material.dart';
import 'package:paw_catcher_admin/core/theme.dart';
import 'package:paw_catcher_admin/presentation/pages/reports/detailed_reports.dart';
import 'package:paw_catcher_admin/services/model/report_model.dart';

class CustomGrid extends StatelessWidget {
  final List<ReportModel> reportsList;

  const CustomGrid({
    super.key,
    required this.reportsList,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.8, crossAxisCount: 2),
        itemCount: reportsList.length,
        itemBuilder: (context, index) {
          final report = reportsList[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailPage(
                        reportModel: report,
                      )));
            },
            child: SizedBox(
                height: 450,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    spacing: 3,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(report.image),
                              fit: BoxFit.cover,
                            ),
                            color: AppTheme.softPink,
                            borderRadius: BorderRadius.circular(10)),
                        height: 80,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text(report.title), Text('')],
                      ),
                      Text(
                        report.report,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                            height: 25,
                            width: 90,
                            decoration: BoxDecoration(
                              color: AppTheme.safeGreen,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text('progress'),
                            )),
                      )
                    ],
                  ),
                )),
          );
        });
  }
}
