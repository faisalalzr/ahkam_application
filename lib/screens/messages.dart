import 'package:chat/models/account.dart';
import 'package:chat/screens/chat.dart';
import 'package:chat/screens/home.dart';
import 'package:chat/screens/notification.dart';
import 'package:chat/screens/request.dart';
import 'package:chat/screens/wallet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../models/account.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key, required this.account});
  final Account account;

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var _selectedIndex = 2;
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
        switch (_selectedIndex) {
          case 0:
            Get.to(NotificationsScreen(
              account: widget.account,
            ));
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

    return Scaffold(
      appBar: AppBar(
        title: Text("Messages"),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFF5EEDC),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('chats').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          var chats = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              var chat = chats[index].data() as Map<String, dynamic>;
              var chatId = chats[index].id; // Accessing the document ID here
              return ListTile(
                title: Text(chat['lastMessage'] ?? 'No message'),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            ChatScreen(chatId: chatId))), // Pass the chatId
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
              icon: Icon(LucideIcons.bell), label: "notifications"),
          BottomNavigationBarItem(
              icon: Icon(LucideIcons.wallet), label: "wallet"),
          BottomNavigationBarItem(
              icon: Icon(LucideIcons.messageCircle), label: "Chat"),
          BottomNavigationBarItem(
              icon: Icon(LucideIcons.clipboardList), label: "Requests"),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.home),
            label: "Home",
          ),
        ],
      ),
    );
  }
}
