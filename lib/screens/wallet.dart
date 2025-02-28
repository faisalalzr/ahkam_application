import 'package:chat/models/account.dart';
import 'package:chat/screens/chat.dart';
import 'package:chat/screens/messages.dart';
import 'package:chat/screens/notification.dart';
import 'package:chat/screens/request.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'home.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key, required this.account});
  final Account account;

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  var _selectedIndex = 1;
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
        automaticallyImplyLeading: false,
        title: Text(
          'Wallet',
          style: TextStyle(fontSize: 40),
        ),
        backgroundColor: Color(0xFFF5EEDC),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 50),
        child: Center(
          child: SizedBox(
            height: 150,
            width: 150,
            child: Column(
              children: [
                Icon(
                  LucideIcons.wallet2,
                  size: 50,
                ),
                Text('balance:  540,132.44'),
              ],
            ),
          ),
        ),
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

          /* BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.brown, shape: BoxShape.circle),
                  child: Icon(Icons.add, color: Colors.white),
                ),
                label: ""),*/
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
