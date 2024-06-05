import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/bill.dart';

class GenerateBillScreen extends StatefulWidget {
  @override
  _GenerateBillScreenState createState() => _GenerateBillScreenState();
}

class _GenerateBillScreenState extends State<GenerateBillScreen> {
  String selectedField = '';
  List<String> fields = [];
  bool isSpecialDeal = false;
  bool isDraft = false;
  final cNameController = TextEditingController();
  final sRemarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAgents();
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

  Future<void> _fetchAgents() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('agents').get();
      List<String> agentEmails =
          querySnapshot.docs.map((doc) => doc['name'] as String).toList();
      setState(() {
        fields = agentEmails;
        if (fields.isNotEmpty) {
          selectedField = fields[0]; // Set default selected field
        }
      });
    } catch (e) {
      print('Error fetching agents: $e');
    }
  }

  Future<void> _submitBill(String salespersonName) async {
    try {
      String customerName = cNameController.text.trim();
      String salesRemarks = sRemarkController.text.trim();
      String agentName = isSpecialDeal ? selectedField : '';
      String dealNo = DateTime.now().millisecondsSinceEpoch.toString();

      Bill bill = Bill(
        salespersonName: salespersonName,
        customerName: customerName,
        agentName: agentName,
        salesRemarks: salesRemarks,
        dealNo: dealNo,
        status: isDraft ? 'Draft' : 'New',
      );

      await FirebaseFirestore.instance
          .collection('bills')
          .doc(dealNo)
          .set(bill.toMap());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bill submitted successfully'),
        ),
      );

      cNameController.clear();
      sRemarkController.clear();
      setState(() {
        isSpecialDeal = false;
        if (fields.isNotEmpty) {
          selectedField = fields[0];
        }
      });
    } catch (e) {
      print('Error submitting bill: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting bill')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deal Form Sales'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Deal No: ${DateTime.now().millisecondsSinceEpoch}',
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              TextField(
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                controller: cNameController,
                decoration: const InputDecoration(
                  labelText: 'Customer Name',
                ),
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
                fields.isEmpty
                    ? CircularProgressIndicator()
                    : DropdownButtonFormField<String>(
                        value: selectedField,
                        onChanged: (newValue) {
                          setState(() {
                            selectedField = newValue!;
                          });
                        },
                        items: fields
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
              const SizedBox(height: 20.0),
              TextFormField(
                maxLines: null,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                controller: sRemarkController,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  isCollapsed: false,
                  label: Text('Sales Remarks'),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  TextButton(
                    onPressed: () async {
                      if (cNameController.text.isEmpty ||
                          sRemarkController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Please fill out all required fields'),
                          ),
                        );
                        return;
                      }

                      String salespersonName = await getName();
                      _submitBill(salespersonName);
                    },
                    child: Text('Submit'),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (cNameController.text.isEmpty ||
                          sRemarkController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Please fill out all required fields'),
                          ),
                        );
                        return;
                      }
                      setState(() {
                        isDraft = !isDraft;
                      });
                      String salespersonName = await getName();
                      _submitBill(salespersonName);
                    },
                    child: Text('Save as Draft'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
