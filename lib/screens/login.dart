import 'package:chat/screens/Lawyer%20screens/lawyerHomeScreen.dart';
import 'package:chat/screens/home.dart';
import 'package:chat/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/account.dart';
import '../models/lawyer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? AnyUser = userCredential.user;

      QuerySnapshot userQuery = await _firestore
          .collection('account')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty)
        throw Exception("User not found in Firestore");

      DocumentSnapshot userDoc = userQuery.docs.first;
      bool isLawyer =
          (userDoc.data() as Map<String, dynamic>?)?['isLawyer'] ?? false;

      if (userDoc.exists) {
        if (isLawyer == true) {
          Get.offAll(
              () => LawyerHomeScreen(lawyer: Lawyer(email: AnyUser!.email!)));
        } else {
          Get.to(() => HomeScreen(account: Account(email: AnyUser!.email!)));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
        toolbarHeight: 100,
        title: Text("AHKAM",
            style: TextStyle(
              fontSize: 40,
              fontFamily: 'Times New Roman',
              color: Color.fromARGB(255, 255, 255, 255),
            )),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 72, 47, 0),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Welcome Back!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Login to continue",
                style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            SizedBox(height: 30),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(
                  size: 21,
                  Icons.email,
                  color: Color.fromARGB(255, 72, 47, 0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(
                  size: 21,
                  Icons.lock,
                  color: Color.fromARGB(255, 72, 47, 0),
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Color.fromARGB(255, 72, 47, 0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Get.to(RegisterScreen());
                  },
                  child: Text("sign up"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
