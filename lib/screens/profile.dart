import 'package:chat/models/account.dart';
import 'package:chat/screens/home.dart';
import 'package:chat/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  final Account account;

  const ProfileScreen({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.to(HomeScreen(
                account: account,
              ));
            },
            icon: Icon(Icons.arrow_back)),
        title: Text("Profile"),
        backgroundColor: Color(0xFFF5EEDC),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                  // account.photoURL ??
                  "https://via.placeholder.com/150", // Default placeholder image
                ),
                backgroundColor: Colors.grey[300],
              ),
              SizedBox(height: 20),

              // User Name
              Text(
                account.name ?? "No Name",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),

              // User Email
              Text(
                account.email ?? "No Email",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 30),

              // User Details Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Phone Number (Example)
                      ListTile(
                        leading: Icon(Icons.phone,
                            color: Color.fromARGB(255, 0, 0, 0)),
                        title: Text("Phone Number"),
                        subtitle: Text(
                          account.number ?? "Not provided",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      Divider(),

                      // Joined Date (Example)
                      ListTile(
                        leading: Icon(
                          Icons.calendar_today,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        title: Text("Joined Date"),
                        subtitle: Text(
                          "January 2023", // Replace with actual joined date
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Get.to(LoginScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Red color for logout
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Logout",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
