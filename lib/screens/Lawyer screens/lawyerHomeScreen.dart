import 'package:chat/models/lawyer.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LawyerHomeScreen extends StatefulWidget {
  const LawyerHomeScreen({super.key, required this.lawyer});
  final Lawyer lawyer;

  @override
  State<LawyerHomeScreen> createState() => _LawyerHomeScreenState();
}

class _LawyerHomeScreenState extends State<LawyerHomeScreen> {
  final List<Map<String, String>> lawsuits = [
    {"title": "Corporate Fraud Case", "status": "Active"},
    {"title": "Divorce Settlement", "status": "Waiting"},
    {"title": "Criminal Defense", "status": "Finished"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu),
          color: Colors.black,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              /* backgroundImage: NetworkImage(
                          widget.lawyer['profileImage'] ??
                              "https://via.placeholder.com/150"),*/
            ),
            SizedBox(width: 12),
            Text(
              "Welcome, ${widget.lawyer.name ?? 'Lawyer'}",
              style: TextStyle(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 12),
            /* Text(
              widget.lawyer.specialization ?? "Legal Expert",
              style: TextStyle(
                  color: const Color.fromARGB(179, 0, 0, 0), fontSize: 16),
            ),*/
          ],
        ),
        backgroundColor: Color(0xFFF5EEDC),
        foregroundColor: Colors.white,
        centerTitle: false,
      ),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              // Status Section
              Text('Case Status',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatusBadge(
                      label: 'Finished',
                      color: Colors.green,
                      icon: LucideIcons.checkCircle),
                  StatusBadge(
                      label: 'Waiting',
                      color: Colors.orange,
                      icon: LucideIcons.timer),
                  StatusBadge(
                      label: 'Active',
                      color: Colors.blue,
                      icon: LucideIcons.briefcase),
                ],
              ),

              SizedBox(height: 20),

              // Lawsuits List
              Text('Your Cases',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Expanded(
                child: lawsuits.isEmpty
                    ? Center(child: Text("No active cases yet."))
                    : ListView.builder(
                        itemCount: lawsuits.length,
                        itemBuilder: (context, index) {
                          final caseData = lawsuits[index];
                          return LawsuitCard(
                              title: caseData["title"]!,
                              status: caseData["status"]!);
                        },
                      ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

// Custom Widget for Status Badges
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const StatusBadge(
      {super.key,
      required this.label,
      required this.color,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// Custom Widget for Lawsuit Card
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
          // Navigate to lawsuit details
          print('$title tapped');
        },
      ),
    );
  }
}
