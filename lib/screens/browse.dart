import 'package:chat/widgets/lawyer_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat/models/lawyer.dart';

class BrowseLawyersScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  BrowseLawyersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFFF5EEDC), title: Text("Browse Lawyers")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('account').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No lawyers available.'));
          }

          var lawyers = snapshot.data!.docs;

          return ListView.builder(
            itemCount: lawyers.length,
            itemBuilder: (context, index) {
              var lawyerData = lawyers[index].data() as Map<String, dynamic>;

              // Map Firestore data to Lawyer model
              Lawyer lawyer = Lawyer(
                uid: lawyers[index].id,
                name: lawyerData['name'] ?? 'unkown',
                email: lawyerData['email'] ?? 'unknown',
                specialization: lawyerData['specialization'] ?? 'unknown',
                rating: lawyerData['rating'] ?? 0,
                province: lawyerData['province'],
                number: lawyerData['number'],
              );

              return LawyerCard(lawyer: lawyer);
            },
          );
        },
      ),
    );
  }
}
