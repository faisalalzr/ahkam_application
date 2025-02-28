import 'package:chat/models/lawyer.dart';
import 'package:flutter/material.dart';

class LawyerCard extends StatelessWidget {
  final Lawyer lawyer;
  const LawyerCard({super.key, required this.lawyer});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          /* ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(..assets/images/brad.webp,
                width: 50, height: 50, fit: BoxFit.cover),
          ),*/
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lawyer.name!,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: 18),
                    Text("${lawyer.rating} (${lawyer.rating} Reviews)",
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Dummy Lawyer Data
List<Lawyer> lawyers = [
  Lawyer(
    uid: '',
    name: "Lawyer . faisal",
    email: 'nadine@gmail.com',

    specialization: 'civil',
    rating: 4.7,
    // image: "assets/images/brad.webp",
    province: 'amman',
    number: '077',
  ),
  Lawyer(
    uid: '',
    name: "Lawyer . Nadine",
    email: 'nadine@gmail.com',

    specialization: '',
    rating: 4.6,
    // image: "assets/images/ang.jpg",
    province: 'amman',
    number: '077',
  )
];
