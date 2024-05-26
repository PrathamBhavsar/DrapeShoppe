import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/bottom_app_bar.dart';
import 'package:my_app/screens/signup_screen.dart';

class AgentHomeScreen extends StatefulWidget {
  @override
  _AgentHomeScreenState createState() => _AgentHomeScreenState();
}

class _AgentHomeScreenState extends State<AgentHomeScreen> {
  String selectedField = '';
  List<String> fields = [];
  String customerName = '';
  bool isSpecialDeal = false;

  @override
  void initState() {
    super.initState();
    _fetchAgents();
  }

  Future<void> _fetchAgents() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('salespersons').get();
      List<String> agentEmails = querySnapshot.docs.map((doc) => doc['email'] as String).toList();
      setState(() {
        fields = agentEmails;
        if (fields.isNotEmpty) {
          selectedField = fields[0]; // Set default selected field
        }
      });
    } catch (e) {
      print('Error fetching salesperson: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Deal Form Agent'),
            IconButton(onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => SignUpScreen(),
                ),
              );
            }, icon: Icon(Icons.logout))
          ],
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Deal No: ${DateTime.now().millisecondsSinceEpoch}',
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Customer Name',
              ),
              onChanged: (value) {
                setState(() {
                  customerName = value;
                });
              },
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Is Agent Required:',
              style: TextStyle(fontSize: 16.0),
            ),
            Row(
              children: [
                Radio(
                  value: false,
                  groupValue: isSpecialDeal,
                  onChanged: (value) {
                    setState(() {
                      isSpecialDeal = value!;
                    });
                  },
                ),
                const Text('No'),
                Radio(
                  value: true,
                  groupValue: isSpecialDeal,
                  onChanged: (value) {
                    setState(() {
                      isSpecialDeal = value!;
                    });
                  },
                ),
                const Text('Yes'),
              ],
            ),
            const SizedBox(height: 20.0),
            if (isSpecialDeal)
              Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedField,
                    onChanged: (newValue) {
                      setState(() {
                        selectedField = newValue!;
                      });
                    },
                    items: fields.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
