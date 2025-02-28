import 'package:chat/models/account.dart';
import 'package:chat/screens/home.dart';
import 'package:chat/screens/messages.dart';
import 'package:chat/screens/notification.dart';
import 'package:chat/screens/wallet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../models/account.dart';

class requestsScreen extends StatefulWidget {
  const requestsScreen({super.key, required this.account});
  final Account account;

  @override
  _requestsScreenState createState() => _requestsScreenState();
}

class _requestsScreenState extends State<requestsScreen> {
  final FirebaseFirestore _lawyerDb = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchLawyerRequests() async {
    QuerySnapshot querySnapshot =
        await _lawyerDb.collection('lawyerRequest').get();

    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          Get.to(NotificationsScreen(account: widget.account));
          break;
        case 1:
          Get.to(WalletScreen(account: widget.account));
          break;
        case 2:
          Get.to(MessagesScreen(account: widget.account));
          break;
        case 3:
          Get.to(requestsScreen(account: widget.account));
          break;
        case 4:
          Get.to(HomeScreen(account: widget.account));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lawyer Requests"),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFF5EEDC),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchLawyerRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error fetching requests"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No requests sent."));
          }

          List<Map<String, dynamic>> lawyerRequests = snapshot.data!;

          return ListView.builder(
            itemCount: lawyerRequests.length,
            itemBuilder: (context, index) {
              final request = lawyerRequests[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(request['profileImage']),
                ),
                title: Text(request['name'],
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(request['specialization']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                    if (request['status'] == 'Pending')
                      IconButton(
                        icon: Icon(Icons.cancel, color: Colors.red),
                        onPressed: () async {
                          await _lawyerDb
                              .collection('lawyerRequest')
                              .doc(request['id'])
                              .delete();
                          setState(() {});
                        },
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(LucideIcons.bell), label: "Notifications"),
          BottomNavigationBarItem(
              icon: Icon(LucideIcons.wallet), label: "Wallet"),
          BottomNavigationBarItem(
              icon: Icon(LucideIcons.messageCircle), label: "Chat"),
          BottomNavigationBarItem(
              icon: Icon(LucideIcons.clipboardList), label: "Requests"),
          BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: "Home"),
        ],
      ),
    );
  }
}
