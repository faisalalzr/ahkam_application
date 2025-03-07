import 'package:chat/widgets/lawyer_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat/models/lawyer.dart';
import 'package:get/get.dart';

class BrowseLawyersScreen extends StatefulWidget {
  final String? search;

  BrowseLawyersScreen(this.search, {super.key});

  @override
  State<BrowseLawyersScreen> createState() => _BrowseLawyersScreenState();
}

class _BrowseLawyersScreenState extends State<BrowseLawyersScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Query query =
        _firestore.collection('account').where('isLawyer', isEqualTo: true);

    // Apply search filter only if `search` is not null or empty
    if (widget.search != null && widget.search!.isNotEmpty) {
      query = query.where('lawyerName', isEqualTo: widget.search);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF5EEDC),
        title: Text("Browse Lawyers"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
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
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream: query.snapshots(),
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
                  var lawyerData =
                      lawyers[index].data() as Map<String, dynamic>;

                  // Map Firestore data to Lawyer model
                  Lawyer lawyer = Lawyer(
                    uid: lawyers[index].id,
                    name: lawyerData['name'] ?? 'Unknown',
                    email: lawyerData['email'] ?? 'Unknown',
                    specialization: lawyerData['specialization'] ?? 'Unknown',
                    rating: lawyerData['rating'] ?? 0,
                    province: lawyerData['province'] ?? 'Unknown',
                    number: lawyerData['number'] ?? 'N/A',
                  );

                  return LawyerCard(lawyer: lawyer);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
