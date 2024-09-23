import 'package:agriculture/wigdet/Reusetext.dart';
import 'package:agriculture/wigdet/reuse_btn.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpdateScreen extends StatefulWidget {
  final Map<String, dynamic> datauser;
  final Function(Map<String, dynamic>) onUpdate; // Callback to pass updated data

  const UpdateScreen({super.key, required this.datauser, required this.onUpdate});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  late TextEditingController _zamendarNameController;
  late TextEditingController _currentRateController;
  late TextEditingController _productWeightController;
  late TextEditingController _totalChundaeController;
  late TextEditingController _totalFareController;
  late TextEditingController _totalLabourWageController;
  late TextEditingController _finalWeightController;
  late TextEditingController _totalAmountController;

  @override
  void initState() {
    super.initState();

    _zamendarNameController = TextEditingController(text: widget.datauser['ZamendarName']);
    _currentRateController = TextEditingController(text: widget.datauser['currentRate'].toString());
    _productWeightController = TextEditingController(text: widget.datauser['productWeight'].toString());
    _totalChundaeController = TextEditingController(text: widget.datauser['totalChundae'].toString());
    _totalFareController = TextEditingController(text: widget.datauser['totalFare'].toString());
    _totalLabourWageController = TextEditingController(text: widget.datauser['totalLabourWage'].toString());
    _finalWeightController = TextEditingController(text: widget.datauser['finalWeight'].toString());
    _totalAmountController = TextEditingController(text: widget.datauser['totalAmount'].toString());
  }

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool deleteLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 30.sp),
        ),
        title: Text(
          widget.datauser['ZamendarName'] ?? 'Edit Entry',
          style: const TextStyle(color: Colors.white),
        ),
        toolbarHeight: 70.h,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ReuseTextForm(
                  controller: _zamendarNameController,
                  labelText: 'Zamendar Name',
                  validatorMessage: 'Enter Zamendar Name',
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 20.h),
                ReuseTextForm(
                  controller: _currentRateController,
                  labelText: 'Current Rate',
                  validatorMessage: 'Enter Current Rate',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20.h),
                ReuseTextForm(
                  controller: _productWeightController,
                  labelText: 'Product Weight',
                  validatorMessage: 'Enter Product Weight',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20.h),
                ReuseTextForm(
                  controller: _totalChundaeController,
                  labelText: 'Chundae',
                  validatorMessage: 'Enter Chundae',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20.h),
                ReuseTextForm(
                  controller: _totalFareController,
                  labelText: 'Total Fare',
                  validatorMessage: 'Enter Total Fare',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20.h),
                ReuseTextForm(
                  controller: _totalLabourWageController,
                  labelText: 'Total Labour Wage',
                  validatorMessage: 'Enter Total Labour Wage',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20.h),
                ReuseTextForm(
                  controller: _finalWeightController,
                  labelText: 'Final Weight',
                  validatorMessage: 'Enter Final Weight',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20.h),
                ReuseTextForm(
                  controller: _totalAmountController,
                  labelText: 'Total Amount',
                  validatorMessage: 'Enter Total Amount',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ReUseBtn(
                      btnTitle: 'Update',
                      isloading: isLoading,
                      color: Colors.teal,
                      onpress: _updateData,
                    ),
                    ReUseBtn(
                      btnTitle: 'Delete',
                      isloading: deleteLoading,
                      color: Colors.red,
                      onpress: _deleteData,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateData() async {
    if (!_formKey.currentState!.validate()) return; // Validate form
    setState(() {
      isLoading = true;
    });

    final box = await Hive.openBox('agricultureData');
    final updatedData = {
      'ZamendarName': _zamendarNameController.text,
      'currentRate': double.tryParse(_currentRateController.text) ?? 0.0,
      'productWeight': double.tryParse(_productWeightController.text) ?? 0.0,
      'totalChundae': double.tryParse(_totalChundaeController.text) ?? 0.0,
      'totalFare': double.tryParse(_totalFareController.text) ?? 0.0,
      'totalLabourWage': double.tryParse(_totalLabourWageController.text) ?? 0.0,
      'finalWeight': double.tryParse(_finalWeightController.text) ?? 0.0,
      'totalAmount': double.tryParse(_totalAmountController.text) ?? 0.0,
    };

    // Find and update the specific entry in Hive
    final index = box.values.toList().indexWhere(
      (item) => item['ZamendarName'] == widget.datauser['ZamendarName'],
    );

    if (index != -1) {
      await box.putAt(index, updatedData);

      // Update Firebase Firestore as well
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore
          .collection('dataEntries')
          .where('ZamendarName', isEqualTo: widget.datauser['ZamendarName'])
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final documentId = querySnapshot.docs.first.id;
        await firestore.collection('dataEntries').doc(documentId).update(updatedData);
        
        // Notify parent to refresh and pass updated data
        widget.onUpdate(updatedData); 
        Navigator.pop(context);
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _deleteData() async {
    setState(() {
      deleteLoading = true;
    });
    final box = await Hive.openBox('agricultureData');

    // Find and delete the specific entry from Hive
    final index = box.values.toList().indexWhere(
      (item) => item['ZamendarName'] == widget.datauser['ZamendarName'],
    );

    if (index != -1) {
      await box.deleteAt(index);

      // Delete from Firebase Firestore as well
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore
          .collection('dataEntries')
          .where('ZamendarName', isEqualTo: widget.datauser['ZamendarName'])
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final documentId = querySnapshot.docs.first.id;
        await firestore.collection('dataEntries').doc(documentId).delete();
        setState(() {
          deleteLoading = false;
        });
        widget.onUpdate({}); // Notify parent to refresh
        Navigator.pop(context); // Close the screen after deletion
      }
    } else {
      setState(() {
        deleteLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item not found')),
      );
    }
  }
}
