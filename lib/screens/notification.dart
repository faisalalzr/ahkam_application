import 'package:chat/models/account.dart';
import 'package:chat/screens/home.dart';
import 'package:chat/screens/messages.dart';
import 'package:chat/screens/request.dart';
import 'package:chat/screens/wallet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key, required this.account});
  final Account account;
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> notifications = [
    {
      'type': 'like',
      'user': 'john_doe',
      'time': '2h',
      'profileImage': 'https://via.placeholder.com/50',
    },
    {
      'type': 'comment',
      'user': 'alex_99',
      'comment': 'Nice post!',
      'time': '3h',
      'profileImage': 'https://via.placeholder.com/50',
    },
    {
      'type': 'follow',
      'user': 'sarah_l',
      'time': '5h',
      'profileImage': 'https://via.placeholder.com/50',
    },
  ];

  var _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          Get.to(NotificationsScreen(account: widget.account),
              transition: Transition.noTransition);
          break;
        case 1:
          Get.to(WalletScreen(account: widget.account),
              transition: Transition.noTransition);
          break;
        case 2:
          Get.to(MessagesScreen(account: widget.account),
              transition: Transition.noTransition);
          break;
        case 3:
          Get.to(RequestsScreen(account: widget.account),
              transition: Transition.noTransition);
          break;
        case 4:
          Get.to(HomeScreen(account: widget.account),
              transition: Transition.noTransition);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
        toolbarHeight: 70,
        title: Text("Notifications",
            style: TextStyle(
              fontSize: 40,
              fontFamily: 'Times New Roman',
              color: Color.fromARGB(255, 72, 47, 0),
            )),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF5EEDC),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(notification['profileImage']),
            ),
            title: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: notification['user'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: _getNotificationText(notification)),
                ],
              ),
            ),
            trailing: _getTrailingWidget(notification),
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

  String _getNotificationText(Map<String, dynamic> notification) {
    switch (notification['type']) {
      case 'like':
        return ' liked your post.';
      case 'comment':
        return ' commented: "${notification['comment']}"';
      case 'follow':
        return ' started following you.';
      default:
        return '';
    }
  }

  Widget? _getTrailingWidget(Map<String, dynamic> notification) {
    if (notification['type'] == 'follow') {
      return ElevatedButton(
        onPressed: () {},
        child: Text("Follow"),
      );
    }
    return null;
  }
}
