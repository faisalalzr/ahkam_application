import 'package:chat/models/account.dart';
import 'package:chat/screens/browse.dart';
import 'package:chat/screens/messages.dart';
import 'package:chat/screens/notification.dart';
import 'package:chat/screens/profile.dart';
import 'package:chat/screens/request.dart';
import 'package:chat/screens/wallet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  TextEditingController searchController = TextEditingController();
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
    return Stack(children: [
      Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xFFF5EEDC),
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Color.fromARGB(255, 72, 47, 0),
            ),
            onPressed: _toggleSidebar,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Welcome, ${widget.account.name ?? 'user'}',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 72, 47, 0),
                    ),
                  )),
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
                            color: Color.fromARGB(255, 72, 47, 0),
                            blurRadius: 5,
                            spreadRadius: 1)
                      ],
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search",
                        prefixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            Get.to(BrowseLawyersScreen(searchController.text),
                                transition: Transition.noTransition);
                          },
                          color: Color.fromARGB(255, 72, 47, 0),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Categories",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 30,
                          color: Color.fromARGB(255, 72, 47, 0),
                        ),
                      )),
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
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 30,
                          color: Color.fromARGB(255, 72, 47, 0),
                        ),
                      )),
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
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 25,
                            color: Color.fromARGB(255, 72, 47, 0),
                          ),
                        )),
                    SizedBox(height: 20),
                    ListTile(
                      leading: Icon(
                        Icons.person,
                        color: Color.fromARGB(255, 72, 47, 0),
                      ),
                      title: Text("Profile",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 17,
                              color: Color.fromARGB(255, 72, 47, 0),
                            ),
                          )),
                      onTap: () => Get.to(
                          ProfileScreen(account: widget.account),
                          transition: Transition.noTransition),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.settings,
                        color: Color.fromARGB(255, 72, 47, 0),
                      ),
                      title: Text("Settings",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 17,
                              color: Color.fromARGB(255, 72, 47, 0),
                            ),
                          )),
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
          selectedItemColor: Color.fromARGB(255, 72, 47, 0),
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
                icon: Icon(LucideIcons.clipboardList), label: "Requests"),
            BottomNavigationBarItem(
                icon: Icon(LucideIcons.home), label: "Home"),
          ],
        ),
      ),
    ]);
  }
}
