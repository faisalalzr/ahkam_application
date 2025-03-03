import 'package:chat/models/lawyer.dart';
import 'package:chat/screens/Lawyer%20screens/lawSuitDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../widgets/lawsuitcard.dart';

class LawyerHomeScreen extends StatefulWidget {
  const LawyerHomeScreen({super.key, required this.lawyer});
  final Lawyer lawyer;

  @override
  State<LawyerHomeScreen> createState() => _LawyerHomeScreenState();
}

class _LawyerHomeScreenState extends State<LawyerHomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var _selectedIndex = 3;

  final List<Map<String, String>> lawsuits = [
    {"title": "Corporate Fraud Case", "status": "Active"},
    {"title": "Divorce Settlement", "status": "Waiting"},
    {"title": "Criminal Defense", "status": "Finished"},
  ];

  Future<List<Map<String, dynamic>>> fetchRequests() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('requests')
        .where('lawyerId', isEqualTo: widget.lawyer.uid)
        .get();

    // Include the document id in the data
    return querySnapshot.docs
        .map((doc) => {
              'id': doc.id, // Store the document id
              ...doc.data() as Map<String, dynamic>, // Store the document data
            })
        .toList();
  }

  // Handle accepting a request
  Future<void> acceptRequest(String requestId) async {
    await _firestore.collection('requests').doc(requestId).update({
      'status': 'Accepted',
    });

    // Create a chat session (you can implement this logic)
    // For example, create a new document in the 'chats' collection
  }

  // Handle rejecting a request
  Future<void> rejectRequest(String requestId) async {
    await _firestore.collection('requests').doc(requestId).update({
      'status': 'Rejected',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
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
                  color: const Color.fromARGB(255, 72, 47, 0),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 12),
            ],
          ),
          backgroundColor: Color(0xFFF5EEDC),
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              // old Status Section
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
              Text('Consultation Requests',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              SizedBox(height: 10),
              Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                // Fetching Requests
                future: fetchRequests(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error fetching requests'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No requests yet.'));
                  }

                  List<Map<String, dynamic>> requests = snapshot.data!;

                  return ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final request = requests[index];

                      // Fetch the username asynchronously inside a FutureBuilder
                      return FutureBuilder<DocumentSnapshot>(
                        future: _firestore
                            .collection('account')
                            .doc(request['userId'])
                            .get(),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return ListTile(
                              title: Text('Loading user...'),
                              subtitle: CircularProgressIndicator(),
                            );
                          } else if (userSnapshot.hasError) {
                            return ListTile(
                              title: Text('Error fetching user'),
                              subtitle: Text(userSnapshot.error.toString()),
                            );
                          } else if (!userSnapshot.hasData ||
                              !userSnapshot.data!.exists) {
                            return ListTile(
                              title: Text('User not found'),
                              subtitle: Text('No user data available'),
                            );
                          }

                          // Debugging: Log the user document
                          print(
                              "Fetched user document: ${userSnapshot.data!.data()}");

                          // Safely access the "name" field
                          String username =
                              userSnapshot.data!['name'] ?? 'Unknown User';

                          return ListTile(
                            title: Text('Request from $username'),
                            subtitle: Text(
                                'Date: ${request['date']}, Time: ${request['time']}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (request['status'] == 'Pending')
                                  IconButton(
                                    icon:
                                        Icon(Icons.check, color: Colors.green),
                                    onPressed: () async {
                                      acceptRequest(request['id']);
                                      setState(
                                          () {}); // Rebuild UI after updating the request
                                    },
                                  ),
                                if (request['status'] == 'Pending')
                                  IconButton(
                                    icon: Icon(Icons.close, color: Colors.red),
                                    onPressed: () async {
                                      rejectRequest(request['id']);
                                      setState(
                                          () {}); // Rebuild UI after updating the request
                                    },
                                  ),
                                Text(
                                  request['status'],
                                  style: TextStyle(
                                    color: request['status'] == 'Accepted'
                                        ? Colors.green
                                        : request['status'] == 'Rejected'
                                            ? Colors.red
                                            : Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              )),

              ////////////////////////////////////////////////

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
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color.fromARGB(255, 0, 0, 0),
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.bell),
              label: "Notifications",
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.wallet),
              label: "Wallet",
            ),
            BottomNavigationBarItem(
                icon: Icon(LucideIcons.messageCircle), label: "Chat"),
            BottomNavigationBarItem(
                icon: Icon(LucideIcons.home), label: "Home"),
          ],
        ),
      )
    ]);
  }

  void _onItemTapped(int value) {
    setState(() {
      _selectedIndex = value;
    });
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
