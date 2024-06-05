import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
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
  late TextEditingController _agentRemarksController;
  late TextEditingController _agencyCostController;
  bool isAccepted = true;
  bool isUpdateVisible = false;
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFiles = [];

  @override
  void initState() {
    super.initState();
    _customerNameController =
        TextEditingController(text: widget.bill.customerName);
    _salesRemarksController =
        TextEditingController(text: widget.bill.salesRemarks);
    _agentNameController = TextEditingController(text: widget.bill.agentName);
    _agentRemarksController = TextEditingController(text: widget.bill.agentRemarks);
    _agencyCostController = TextEditingController(text: widget.bill.agentCost);
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _salesRemarksController.dispose();
    _agentNameController.dispose();
    _agentRemarksController.dispose();
    _agencyCostController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFiles = await _picker.pickMultiImage(imageQuality: 50);

      if (pickedFiles != null) {
        setState(() {
          _imageFiles!.addAll(pickedFiles);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('From Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? photo = await _picker.pickImage(
                      source: ImageSource.camera, imageQuality: 50);
                  if (photo != null) {
                    setState(() {
                      _imageFiles!.add(photo);
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('From Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
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
          status: 'Measured');

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

  Future<void> _billedBill() async {
    if (_formKey.currentState!.validate()) {
      String status = 'Billed';

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

  Future<void> _installedBill() async {
    if (_formKey.currentState!.validate()) {
      String status = 'Installed';

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

  Future<void> _approvedBill() async {
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
                SizedBox(
                  height: 15,
                ),
                // Visibility(
                //   visible: widget.bill.status == 'Accepted',
                //   child: Container(
                //     color: Colors.red,
                //     height: 200,
                //     // width: 400,
                //     child: Center(
                //       child: Column(
                //         children: [
                //           Container(
                //             padding: EdgeInsets.all(20),
                //             child: ElevatedButton(
                //               onPressed: () => _showImagePickerOptions(context),
                //               child: Text('Add Images'),
                //             ),
                //           ),
                //           Expanded(
                //             child: GridView.builder(
                //               gridDelegate:
                //                   SliverGridDelegateWithFixedCrossAxisCount(
                //                 crossAxisCount: 3,
                //                 crossAxisSpacing: 4.0,
                //                 mainAxisSpacing: 4.0,
                //               ),
                //               itemCount: _imageFiles!.length,
                //               itemBuilder: (BuildContext context, int index) {
                //                 return Image.file(File(_imageFiles![index].path));
                //               },
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Visibility(
                      visible: widget.bill.status == 'New' ||
                          widget.bill.status == 'Declined' && !isUpdateVisible,
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
                    onPressed: _billedBill,
                    child: Text('Mark job as complete'),
                  ),
                ),
                Visibility(
                  visible: widget.bill.status == 'Measured',
                  child: TextButton(
                    onPressed: _installedBill,
                    child: Text('Installed'),
                  ),
                ),
                Visibility(
                  visible: widget.bill.status == 'Installed',
                  child: TextButton(
                    onPressed: _approvedBill,
                    child: Text('Approve'),
                  ),
                ),
                Visibility(
                  visible: widget.bill.status == 'Unbilled',
                  child: TextButton(
                    onPressed: _billedBill,
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
