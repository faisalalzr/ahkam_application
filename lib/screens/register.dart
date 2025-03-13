import 'package:chat/screens/login.dart';
import 'package:chat/screens/new.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false; // To handle loading state

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordController != _confirmpasswordController) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Register the user with Firebase Authentication

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      var uidd = userCredential.user!.uid;

      // After registration, check user data in Firestore to determine if they are a lawyer
      DocumentSnapshot userDoc =
          await _firestore.collection('account').doc(uidd).get();

      if (!userDoc.exists) {
        // If user document doesn't exist in Firestore, create one
        await _firestore.collection('account').doc(uidd).set({
          'email': _emailController.text.trim(),
          'isLawyer': false, // Set initial user type, can be changed later
        });
      }

      Get.to(New(email: _emailController.text.trim(), uid: uidd));
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth errors
      String errorMessage = 'Registration failed!';
      if (e.code == 'email-already-in-use') {
        errorMessage = 'This email is already in use.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Password must be at least 6 characters.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email address.';
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      // Handle any other errors
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard
      child: Scaffold(
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 40),
                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(
                            size: 21,
                            Icons.email,
                            color: Color.fromARGB(255, 72, 47, 0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email cannot be empty.";
                          } else if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$")
                              .hasMatch(value)) {
                            return "Enter a valid email.";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),

                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color.fromARGB(255, 72, 47, 0),
                            size: 21,
                          ),
                          labelText: "Password",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password cannot be empty.";
                          } else if (value.length < 6) {
                            return "Password must be at least 6 characters.";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      // confirm Password Field
                      TextFormField(
                        controller: _confirmpasswordController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color.fromARGB(255, 72, 47, 0),
                            size: 21,
                          ),
                          labelText: "confirm password",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password cannot be empty.";
                          } else if (value.length < 6) {
                            return "Password must be at least 6 characters.";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),

                      // Register Button
                      ElevatedButton(
                        onPressed: _isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Color.fromARGB(255, 72, 47, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ), // Matching button color
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "Register",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                      SizedBox(height: 20),

                      // Sign In Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account?"),
                          TextButton(
                            onPressed: () {
                              Get.to(LoginScreen());
                            },
                            child: Text("Sign In"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
