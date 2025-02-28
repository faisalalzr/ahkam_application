import 'package:chat/models/account.dart';
import 'package:chat/screens/browse.dart';
import 'package:chat/screens/chat.dart';
import 'package:chat/screens/messages.dart';
import 'package:chat/screens/notification.dart';
import 'package:chat/screens/profile.dart';
import 'package:chat/screens/request.dart';
import 'package:chat/screens/wallet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:get/get.dart';
import '../widgets/lawyer_card.dart';
import '../widgets/category.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.account});
  final Account account;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool isSideBarOpen = false;
  int _selectedIndex = 4;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: -250, end: 0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  void _toggleSidebar() {
    setState(() {
      if (isSideBarOpen) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
      isSideBarOpen = !isSideBarOpen;
    });
  }

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
    return Stack(children: [
      Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xFFF5EEDC),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.menu, color: const Color.fromARGB(255, 0, 0, 0)),
            onPressed: _toggleSidebar,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Welcome",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0))),
              Text(widget.account.name ?? "User",
                  style: TextStyle(
                      fontSize: 16, color: const Color.fromARGB(179, 0, 0, 0))),
            ],
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            spreadRadius: 1)
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search, color: Colors.black54),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      onTap: () => Get.to(BrowseLawyersScreen()),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Categories",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.3,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return CategoryCard(category: categories[index]);
                    },
                  ),
                  SizedBox(height: 20),
                  Text("Top Lawyers",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Column(
                    children:
                        lawyers.map((e) => LawyerCard(lawyer: e)).toList(),
                  ),
                ],
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              left: isSideBarOpen ? 0 : -250,
              top: 0,
              bottom: 0,
              child: Container(
                width: 250,
                color: Color(0xFFF5EEDC),
                padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Menu",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    ListTile(
                      leading: Icon(Icons.person, color: Colors.white),
                      title: Text("Profile",
                          style: TextStyle(color: Colors.white)),
                      onTap: () =>
                          Get.to(ProfileScreen(account: widget.account!)),
                    ),
                    ListTile(
                      leading: Icon(Icons.settings, color: Colors.white),
                      title: Text("Settings",
                          style: TextStyle(color: Colors.white)),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFFF5EEDC),
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
                icon: Icon(LucideIcons.bell), label: "Notifications"),
            BottomNavigationBarItem(
                icon: Icon(LucideIcons.wallet), label: "Wallet"),
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
      ),
    ]);
  }
}
