import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/constants/sales_fetch.dart';
import 'package:my_app/models/bill.dart';
import 'package:my_app/screens/generate_bill_screen.dart';
import 'package:my_app/screens/signup_screen.dart';

class SalesHomeScreen extends StatefulWidget {
  @override
  _SalesHomeScreenState createState() => _SalesHomeScreenState();
}

class _SalesHomeScreenState extends State<SalesHomeScreen> {
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => GenerateBillScreen(),
            ),
          );
        },
      ),
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
              FutureBuilder<String>(
                future: getName(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return Text(
                      'Hi, ${snapshot.data!}',
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    );
                  } else {
                    return const Text('No name found');
                  }
                },
              ),
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
                    List<DocumentSnapshot> newBills = allBills
                        .where((doc) =>
                    (doc.data() as Map<String, dynamic>)['status'] ==
                        'New')
                        .toList();
                    List<DocumentSnapshot> submittedBills = allBills
                        .where((doc) =>
                    (doc.data() as Map<String, dynamic>)['status'] ==
                        'Submitted')
                        .toList();
                    List<DocumentSnapshot> acceptedBills = allBills
                        .where((doc) =>
                    (doc.data() as Map<String, dynamic>)['status'] ==
                        'Accepted')
                        .toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildSalesBillCategory('New', newBills),
                        buildSalesBillCategory('Approved', submittedBills),
                        buildSalesBillCategory('Completed', acceptedBills),
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
