import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SalesHomeScreen extends StatefulWidget {
  @override
  _SalesHomeScreenState createState() => _SalesHomeScreenState();
}

class _SalesHomeScreenState extends State<SalesHomeScreen> {
  String selectedField = 'Agent 1';
  List<String> fields = ['Agent 1', 'Agent 2', 'Agent 3'];
  String customerName = '';
  bool isSpecialDeal = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deal Form'),
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
