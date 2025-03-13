import 'package:chat/widgets/lawyer_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat/models/lawyer.dart';
import 'package:get/get.dart';

class BrowseLawyersScreen extends StatefulWidget {
  final String? search;

  const BrowseLawyersScreen(this.search, {super.key});

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

    // Improved Search Query for Partial Matching
    if (widget.search != null && widget.search!.isNotEmpty) {
      query = query
          .where('lawyerName', isGreaterThanOrEqualTo: widget.search)
          .where('lawyerName', isLessThanOrEqualTo: '${widget.search!}\uf8ff');
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF5EEDC),
        title: Text("Browse Lawyers"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Get.off(() => BrowseLawyersScreen(searchController.text));
                  },
                  color: Color.fromARGB(255, 72, 47, 0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: query.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                var lawyers = snapshot.data!.docs;
                if (lawyers.isEmpty) {
                  return Center(
                    child: Text(
                      'No lawyers found matching your search.',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: lawyers.length,
                  itemBuilder: (context, index) {
                    var lawyerData =
                        lawyers[index].data() as Map<String, dynamic>;

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
          ),
        ],
      ),
    );
  }
}
