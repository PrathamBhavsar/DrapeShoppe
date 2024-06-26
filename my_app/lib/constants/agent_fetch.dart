import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/constants/status_colors.dart';
import 'package:my_app/models/bill.dart';
import 'package:my_app/screens/edit_bill_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget buildAgentBillCategory(String category, List<DocumentSnapshot> bills) {
  if (bills.isEmpty) {
    return Container();
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '$category Bills:',
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10),
      ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: bills.length,
        itemBuilder: (context, index) {
          DocumentSnapshot billDoc = bills[index];
          Map<String, dynamic> billData =
              billDoc.data() as Map<String, dynamic>;
          Bill bill = Bill.fromMap(billData);

          return GestureDetector(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String userType = prefs.getString('userType') ?? 'Salesperson';

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => EditBillScreen(bill: bill),
                ),
              );
              if (userType == 'Agent' && bill.status == 'New') {
                await FirebaseFirestore.instance
                    .collection('bills')
                    .doc(bill.dealNo)
                    .update({'status': 'Opened'});
                return;
              }
            },
            child: Card(
              color: getCardColor(bill.status),
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
      ),
      SizedBox(height: 20),
    ],
  );
}
