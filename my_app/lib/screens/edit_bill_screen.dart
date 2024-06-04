import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/models/bill.dart';

class EditBillScreen extends StatefulWidget {
  final Bill bill;

  EditBillScreen({required this.bill});

  @override
  _EditBillScreenState createState() => _EditBillScreenState();
}

class _EditBillScreenState extends State<EditBillScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _customerNameController;
  late TextEditingController _salesRemarksController;
  late TextEditingController _agentNameController;
  final _agentRemarksController = TextEditingController();
  final _agencyCostController = TextEditingController();
  bool isAccepted = true;
  bool isUpdateVisible = false;

  @override
  void initState() {
    super.initState();
    _customerNameController =
        TextEditingController(text: widget.bill.customerName);
    _salesRemarksController =
        TextEditingController(text: widget.bill.salesRemarks);
    _agentNameController = TextEditingController(text: widget.bill.agentName);
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _salesRemarksController.dispose();
    _agentNameController.dispose();
    super.dispose();
  }

  Future<void> _updateBill() async {
    if (_formKey.currentState!.validate()) {
      Bill updatedBill = Bill(
          salespersonName: widget.bill.salespersonName,
          customerName: _customerNameController.text,
          agentName: _agentNameController.text,
          salesRemarks: _salesRemarksController.text,
          dealNo: widget.bill.dealNo,
          agentRemarks: _agentRemarksController.text,
          agentCost: _agencyCostController.text,
          status: 'Submitted');

      await FirebaseFirestore.instance
          .collection('bills')
          .doc(widget.bill.dealNo)
          .update(updatedBill.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bill updated successfully'),
        ),
      );

      Navigator.pop(context);
    }
  }

  Future<void> _acceptOrDeclineBill() async {
    if (_formKey.currentState!.validate()) {
      String status = isAccepted ? 'Accepted' : 'Declined';

      await FirebaseFirestore.instance
          .collection('bills')
          .doc(widget.bill.dealNo)
          .update({'status': status});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bill $status'),
        ),
      );

      setState(() {
        isUpdateVisible = true;
      });
    }
  }

  Future<void> _completeBill() async {
    if (_formKey.currentState!.validate()) {
      String status = 'Completed';

      await FirebaseFirestore.instance
          .collection('bills')
          .doc(widget.bill.dealNo)
          .update({'status': status});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bill $status'),
        ),
      );

      setState(() {
        isUpdateVisible = true;
      });
    }

  }  Future<void> _approvedBill() async {
    if (_formKey.currentState!.validate()) {
      String status = 'Unbilled';

      await FirebaseFirestore.instance
          .collection('bills')
          .doc(widget.bill.dealNo)
          .update({'status': status});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bill $status'),
        ),
      );

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Bill'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  enabled: false,
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  controller: _customerNameController,
                  decoration: InputDecoration(labelText: 'Customer Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a customer name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  enabled: false,
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  controller: _agentNameController,
                  decoration: InputDecoration(labelText: 'Agent Name'),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  enabled: false,
                  controller: _salesRemarksController,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    isCollapsed: false,
                    labelText: 'Sales Remarks',
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  controller: _agentRemarksController,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    isCollapsed: false,
                    labelText: 'Agent Remarks',
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  controller: _agencyCostController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    isCollapsed: false,
                    labelText: 'Agency Cost',
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Visibility(
                      visible: widget.bill.status == 'Open' ||
                          widget.bill.status == 'Declined',
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isAccepted = false;
                              });
                              _acceptOrDeclineBill();
                            },
                            child: Text('Decline'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isAccepted = true;
                              });
                              _acceptOrDeclineBill();
                            },
                            child: Text('Accept'),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: isUpdateVisible,
                      child: TextButton(
                        onPressed: _updateBill,
                        child: Text('Update Bill'),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: widget.bill.status == 'Submitted',
                  child: TextButton(
                    onPressed: _completeBill,
                    child: Text('Mark job as complete'),
                  ),
                ),
                Visibility(
                  visible: widget.bill.status == 'Completed',
                  child: TextButton(
                    onPressed: _approvedBill,
                    child: Text('Approve'),
                  ),
                ),
                Visibility(
                  visible: widget.bill.status == 'Unbilled',
                  child: TextButton(
                    onPressed: _completeBill,
                    child: Text('Bill this'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
