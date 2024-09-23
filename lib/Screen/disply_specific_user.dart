import 'package:agriculture/Screen/update_screen.dart';
import 'package:agriculture/wigdet/reuseRow.dart';
import 'package:agriculture/wigdet/reuse_btn.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DisplySpecificPerson extends StatefulWidget {
  final Map<String, dynamic> datauser;
  final VoidCallback onUpdate; // Callback to notify when data is updated

  const DisplySpecificPerson({
    Key? key,
    required this.datauser,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<DisplySpecificPerson> createState() => _DisplySpecificPersonState();
}

class _DisplySpecificPersonState extends State<DisplySpecificPerson> {
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
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(children: [
          SizedBox(height: 30.h),
          ReuseAbleRow(
            label: 'Current Rate',
            value: widget.datauser['currentRate'].toString(),
          ),
          ReuseAbleRow(
            label: 'Product Weight',
            value: widget.datauser['productWeight'].toString(),
          ),
          ReuseAbleRow(
            label: 'Total Chundae',
            value: widget.datauser['totalChundae'].toString(),
          ),
          ReuseAbleRow(
            label: 'Total Fare',
            value: widget.datauser['totalFare'].toString(),
          ),
          ReuseAbleRow(
            label: 'Total Labour Wage',
            value: widget.datauser['totalLabourWage'].toString(),
          ),
          ReuseAbleRow(
            label: 'Final Weight',
            value: widget.datauser['finalWeight'].toString(),
          ),
          ReuseAbleRow(
            label: 'Total Amount',
            value: widget.datauser['totalAmount'].toString(),
          ),
          ReuseAbleRow(
            label: '1/4 of Total Amount',
            value: widget.datauser['1/4 Amount'].toString(),
          ),
          ReuseAbleRow(
            label: 'Balance Amount',
            value: widget.datauser['balanceAmount'].toString(),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ReUseBtn(
                btnTitle: 'Update',
                isloading: isLoading,
                color: Colors.teal,
                onpress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateScreen(
                        datauser: widget.datauser,
                        onUpdate: (updatedData) {
                          setState(() {
                            widget.datauser
                                .addAll(updatedData); // Update the data
                          });
                          widget.onUpdate(); // Notify parent to refresh
                        },
                      ),
                    ),
                  );
                },
              ),
              ReUseBtn(
                btnTitle: 'Delete',
                isloading: deleteLoading,
                color: Colors.red,
                onpress: _deleteData,
              ),
            ],
          ),
        ]),
      ),
    );
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
        await firestore
            .collection('dataEntries')
            .doc(documentId)
            .delete()
            .then((_) {
          setState(() {
            deleteLoading = false;
          });
          widget.onUpdate(); // Notify parent to refresh immediately
          Navigator.pop(context); // Close the screen after deletion
        });
      }
    } else {
      setState(() {
        deleteLoading = false;
      });
      // Handle case when item is not found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item not found')),
      );
    }
  }
}
