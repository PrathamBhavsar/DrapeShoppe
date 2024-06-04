import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/constants/agent_fetch.dart';
import 'package:my_app/screens/signup_screen.dart';

class AgentHomeScreen extends StatefulWidget {
  @override
  _AgentHomeScreenState createState() => _AgentHomeScreenState();
}

class _AgentHomeScreenState extends State<AgentHomeScreen> {
  String? agentName;

  @override
  void initState() {
    super.initState();
    getAgentName();
  }

  Future<void> getAgentName() async {
    String? name = await getName();
    setState(() {
      agentName = name;
    });
  }

  Future<String> getName() async {
    DocumentSnapshot agentDoc = await FirebaseFirestore.instance
        .collection('agents')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (agentDoc.exists) {
      return agentDoc['name'];
    }

    throw Exception('User name not found');
  }

  Stream<QuerySnapshot> getAgentBillsStream() {
    return FirebaseFirestore.instance
        .collection('bills')
        .where('agentName', isEqualTo: agentName)
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
            const Text('Agency'),
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
                stream: getAgentBillsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text('No bills found');
                  } else {
                    List<DocumentSnapshot> allBills = snapshot.data!.docs;
                    List<DocumentSnapshot> openBills = allBills
                        .where((doc) =>
                            (doc.data() as Map<String, dynamic>)['status'] ==
                            'Open')
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
                        buildAgentBillCategory('Open', openBills),
                        buildAgentBillCategory('Approved', submittedBills),
                        buildAgentBillCategory('Completed', acceptedBills),
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
