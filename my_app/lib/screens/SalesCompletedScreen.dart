import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    getSalesPersonName();
  }

  Future<void> getSalesPersonName() async {
    String? name = await getName();
    setState(() {
      salespersonName = name;
    });
  }

  Future<String> getName() async {
    DocumentSnapshot salesPersonDoc = await FirebaseFirestore.instance
        .collection('salespersons')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (salesPersonDoc.exists) {
      return salesPersonDoc['name'];
    }

    throw Exception('User name not found');
  }

  Stream<QuerySnapshot> _getBillsStream() {
    return FirebaseFirestore.instance
        .collection('bills')
        .where('salespersonName', isEqualTo: salespersonName)
        .where('status', isEqualTo: 'Completed')
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
              Text(
                'Completed Bills:',
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: _getBillsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text('No bills found');
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot billDoc = snapshot.data!.docs[index];
                        Map<String, dynamic> billData =
                        billDoc.data() as Map<String, dynamic>;
                        Bill bill = Bill.fromMap(billData);

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    EditBillScreen(bill: bill),
                              ),
                            );
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(bill.customerName),
                              subtitle: Text('Deal No: ${bill.dealNo}'),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Salesperson: ${bill.salespersonName}'),
                                  Text('Status: ${bill.status}'),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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
