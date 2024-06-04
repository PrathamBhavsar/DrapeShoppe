import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/constants/sales_fetch.dart';
import 'package:my_app/models/bill.dart';
import 'package:my_app/screens/edit_bill_screen.dart';
import 'package:my_app/screens/signup_screen.dart';

class SalesCompletedScreen extends StatefulWidget {
  @override
  _SalesCompletedScreenState createState() => _SalesCompletedScreenState();
}

class _SalesCompletedScreenState extends State<SalesCompletedScreen> {
  String? salespersonName;

  @override
  void initState() {
    super.initState();
    getSalespersonName();
  }

  Future<void> getSalespersonName() async {
    String? name = await getName();
    setState(() {
      salespersonName = name;
    });
  }

  Future<String> getName() async {
    DocumentSnapshot salespersonDoc = await FirebaseFirestore.instance
        .collection('salespersons')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (salespersonDoc.exists) {
      return salespersonDoc['name'];
    }

    throw Exception('User name not found');
  }

  Stream<QuerySnapshot> getSalesBillsStream() {
    return FirebaseFirestore.instance
        .collection('bills')
        .where('salespersonName', isEqualTo: salespersonName)
        .orderBy('dealNo', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Sales'),
            IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => SignUpScreen(),
                  ),
                );
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: getSalesBillsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text('No bills found');
                  } else {
                    List<DocumentSnapshot> allBills = snapshot.data!.docs;
                    List<DocumentSnapshot> CompletedBills = allBills
                        .where((doc) =>
                    (doc.data() as Map<String, dynamic>)['status'] ==
                        'Completed')
                        .toList();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildSalesBillCategory('Completed', CompletedBills),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
