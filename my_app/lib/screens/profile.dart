import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Future<String> getName() async {
    DocumentSnapshot agentDoc = await FirebaseFirestore.instance
        .collection('agents')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (agentDoc.exists) {
      return agentDoc['name'];
    }

    DocumentSnapshot salespersonDoc = await FirebaseFirestore.instance
        .collection('salespersons')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (salespersonDoc.exists) {
      return salespersonDoc['name'];
    }

    throw Exception('User name not found');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 150),
              const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 50),
              FutureBuilder<String>(
                future: getName(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return Text(
                      snapshot.data!,
                      style: TextStyle(fontSize: 24),
                    );
                  } else {
                    return const Text('No name found');
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
