import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Authentication
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) {
    return _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  // Save User Data to Firestore
  Future<void> saveUserData(User user) async {
    await _firestore.collection('users').doc(user.uid).set({
      'name': user.displayName ?? '', // Use displayName instead
      'email': user.email,
      'profileImage': user.photoURL ?? '', // Use photoURL instead
    });
  }

  // Retrieve User Data from Firestore
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    }
    return null;
  }

  // Retrieve List of Lawyers
  /*
  Future<List<Lawyer>> getLawyers() async {
    QuerySnapshot snapshot = await _firestore.collection('lawyers').get();
    return snapshot.docs
        .map((doc) => Lawyer.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }*/
}
