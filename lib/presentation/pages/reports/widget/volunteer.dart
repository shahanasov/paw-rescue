import 'package:flutter/material.dart';
import 'package:paw_catcher_admin/core/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paw_catcher_admin/services/data/report_services.dart';

Widget volunteerButton({
  required BuildContext context,
  required String reportId,
}) {
  // Fetch the volunteer status from Firestore
  return StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance
        .collection('Reports')
        .doc(reportId)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // Show a loading indicator while fetching data
        return CircularProgressIndicator();
      }

      if (snapshot.hasError) {
        // Handle errors
        return Text('Error: ${snapshot.error}');
      }

      // Get the volunteer status from the document
      final bool isVolunteerTaken = snapshot.data?['volunteer'] ?? false;

      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          fixedSize: Size(327, 48),
          backgroundColor: isVolunteerTaken ? Colors.grey : AppTheme.softPink,
        ),
        onPressed: isVolunteerTaken
            ? null // Disable the button if volunteer is already taken
            : () {
                // Call the function to update the volunteer status
                updateVolunteerStatus(reportId).then((_) {
                  // Show a snackbar to inform the user
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('You have successfully volunteered!'),
                    ),
                  );
                }).catchError((error) {
                  // Handle errors
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to update volunteer status: $error'),
                    ),
                  );
                });
              },
        child: Text(
          isVolunteerTaken ? 'Already took volunteer' : 'Take volunteer',
          style: TextStyle(
            color: AppTheme.textPrimary,
          ),
        ),
      );
    },
  );
}
