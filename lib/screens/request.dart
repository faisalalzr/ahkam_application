import 'package:chat/models/account.dart';
import 'package:chat/screens/home.dart';
import 'package:chat/screens/messages.dart';
import 'package:chat/screens/notification.dart';
import 'package:chat/screens/wallet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key, required this.account});
  final Account account;

  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  final FirebaseFirestore _lawyerDb = FirebaseFirestore.instance;
  int _selectedIndex = 3;

  /// Fetch lawyer requests specific to the user
  Future<List<Map<String, dynamic>>> fetchLawyerRequests() async {
    try {
      QuerySnapshot querySnapshot = await _lawyerDb
          .collection('requests')
          .where('userId', isEqualTo: widget.account.uid) // Filter requests
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      debugPrint("Error fetching requests: $e");
      return [];
    }
  }

  /// Handles bottom navigation
  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    Widget nextScreen;
    switch (index) {
      case 0:
        nextScreen = NotificationsScreen(account: widget.account);
        break;
      case 1:
        nextScreen = WalletScreen(account: widget.account);
        break;
      case 2:
        nextScreen = MessagesScreen(account: widget.account);
        break;
      case 3:
        return; // Prevent reloading the same screen
      case 4:
      default:
        nextScreen = HomeScreen(account: widget.account);
        break;
    }

    Get.offAll(() => nextScreen, transition: Transition.noTransition);
  }

  /// Creates a request card widget
  Widget getRequestCard(
      {required String title,
      required String lawyerName,
      required String status}) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lawyerName,
                style: const TextStyle(fontWeight: FontWeight.normal)),
            Text(
              "Status: $status",
              style: TextStyle(
                color: status == 'pending'
                    ? Colors.amber
                    : status == 'Accepted'
                        ? Colors.green
                        : Colors.red,
              ),
            ),
          ],
        ),
        trailing: status == 'Accepted'
            ? GestureDetector(
                child: SizedBox(
                  width: 90, // Prevent overflow
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text('Start Chat', style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                ),
              )
            : null,
        onTap: () {
          if (status == 'Accepted') {
            Get.to(() =>
                MessagesScreen(account: widget.account)); // Navigate to chat
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
        toolbarHeight: 70,
        title: Text("Requests",
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                fontSize: 40,
                color: Color.fromARGB(255, 72, 47, 0),
              ),
            )),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF5EEDC),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchLawyerRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text("Error fetching requests"));
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text("No requests sent."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final request = snapshot.data![index];
              return getRequestCard(
                title: request['title'] ?? 'Unknown title',
                lawyerName: request['lawyerName'] ?? 'Lawyer\'s Name',
                status: request['status'] ?? 'Unknown Status',
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
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
