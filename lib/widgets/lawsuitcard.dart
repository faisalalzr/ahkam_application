import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../screens/Lawyer screens/lawSuitDetails.dart';

class LawsuitCard extends StatelessWidget {
  final String title;
  final String status;

  const LawsuitCard({super.key, required this.title, required this.status});

  @override
  Widget build(BuildContext context) {
    Color statusColor = status == 'Finished'
        ? Colors.green
        : status == 'Waiting'
            ? Colors.orange
            : Colors.blue;

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Status: $status", style: TextStyle(color: statusColor)),
        trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: () {
          Get.to(Lawsuit());
        },
      ),
    );
  }
}
