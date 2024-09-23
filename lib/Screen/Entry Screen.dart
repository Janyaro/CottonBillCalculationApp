import 'package:agriculture/Screen/allDataScreen.dart';
import 'package:agriculture/services/hive_operations.dart';
import 'package:agriculture/utility/utility.dart';
import 'package:agriculture/wigdet/Reusetext.dart';
import 'package:agriculture/wigdet/reuse_btn.dart';
import 'package:agriculture/wigdet/total_bill_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DataEntry extends StatefulWidget {
  const DataEntry({super.key});

  @override
  State<DataEntry> createState() => _DataEntryState();
}

class _DataEntryState extends State<DataEntry> {
  HiveOperations hiveOperations = HiveOperations();
  final currentRateController = TextEditingController();
  final productWeightController = TextEditingController();
  final labourWageController = TextEditingController();
  final chundaeController = TextEditingController();
  final fareController = TextEditingController();
  final jamanController = TextEditingController();
  // ignore: non_constant_identifier_names
  final ZamendarNameController = TextEditingController();

  double? productWeight;
  double? finalWeight;
  double? totalAmount;
  double? totalLabourWage;
  double? totalChundae;
  double? totalFare;
  double? currentRate;
  double? onefourth;
  double? balanceAmount;
  double? jamanAmount;
  double? afterJaman;
  @override
  void initState() {
    super.initState();
    hiveOperations.openHiveBox();
    // Add listeners to controllers to update the UI as the user types
    productWeightController.addListener(_updateCalculations);
    currentRateController.addListener(_updateCalculations);
    labourWageController.addListener(_updateCalculations);
    chundaeController.addListener(_updateCalculations);
    fareController.addListener(_updateCalculations);
    jamanController.addListener(_updateCalculations);
  }

  void _updateCalculations() {
    setState(() {
      // Update productWeight
      productWeight = double.tryParse(productWeightController.text);
      if (productWeight == null || productWeight! <= 0) {
        finalWeight = 0;
        totalAmount = 0;
        onefourth = 0;
        balanceAmount = 0;

        return;
      }

      // Final weight calculation
      double numUnits = (productWeight! / 40.0);
      double totalSubtract = (numUnits * 2).roundToDouble();
      finalWeight = (productWeight! - totalSubtract).roundToDouble();

      // Calculate total amount
      double labourWage = double.tryParse(labourWageController.text) ?? 0.0;
      totalLabourWage = (productWeight! / 40) * labourWage;

      double chundaeAmount = double.tryParse(chundaeController.text) ?? 0.0;
      totalChundae = chundaeAmount * productWeight!;

      double fareAmount = double.tryParse(fareController.text) ?? 0.0;
      totalFare = (productWeight! / 40) * fareAmount;

      currentRate = double.tryParse(currentRateController.text) ?? 0.0;
      totalAmount = currentRate! * (finalWeight! / 40);
      totalAmount =
          totalAmount! - totalLabourWage! - totalChundae! - totalFare!;
      onefourth = totalAmount! / 4;
      jamanAmount = double.tryParse(jamanController.text) ?? 0.0;
      balanceAmount = totalAmount! - onefourth!;
      afterJaman = balanceAmount! - jamanAmount!;
    });
  }

  final formkey = GlobalKey<FormState>();
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Entry Screen',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          toolbarHeight: 70.h,
          backgroundColor: Colors.teal,
          automaticallyImplyLeading: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DataDisplayScreen()));
                },
                icon: Icon(
                  Icons.file_copy_sharp,
                  color: Colors.white,
                  size: 30.sp,
                )),
            SizedBox(
              width: 10.w,
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              Form(
                  key: formkey,
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),
                      ReuseTextForm(
                        controller: ZamendarNameController,
                        labelText: 'Zamendar Name',
                        validatorMessage: 'Enter Zamendar Name',
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 10.h),
                      ReuseTextForm(
                        controller: currentRateController,
                        labelText: 'Current Rate per 40kg',
                        validatorMessage: 'Enter Rate per 40kg',
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 10.h),
                      ReuseTextForm(
                        controller: productWeightController,
                        labelText: 'Product Weight in Kgs',
                        validatorMessage: 'Enter Product Weight in Kgs',
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 10.h),
                      ReuseTextForm(
                        controller: labourWageController,
                        labelText: 'Labour Wage -per 40kg',
                        validatorMessage: 'Enter Labour Wage per 40kg',
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 10.h),
                      ReuseTextForm(
                        controller: chundaeController,
                        labelText: 'Chundae per kilo',
                        validatorMessage: 'Enter Chundae per kilo',
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 10.h),
                      ReuseTextForm(
                        controller: fareController,
                        labelText: 'Fare per 40kg',
                        validatorMessage: 'Enter Fare per 40kh',
                        keyboardType: TextInputType.number,
                      ),

                      SizedBox(height: 10.h),
                      ReuseTextForm(
                        controller: jamanController,
                        labelText: 'Jaman Amount',
                        validatorMessage: 'Enter Jaman Amount',
                        keyboardType: TextInputType.number,
                      ),

                      SizedBox(height: 10.h),

                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                width: 2, color: Colors.grey.shade400)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Final Weight ',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18.sp),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10.h),
                                child: Text(
                                  finalWeight != null
                                      ? finalWeight!.toStringAsFixed(2)
                                      : '0',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18.sp),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                width: 2, color: Colors.grey.shade400)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Amount',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18.sp),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10.h),
                                child: Text(
                                  totalAmount != null
                                      ? totalAmount!.toStringAsFixed(2)
                                      : '0',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18.sp),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      // one fourth on total Income
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                width: 2, color: Colors.grey.shade400)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '1/4 Amount',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18.sp),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10.h),
                                child: Text(
                                  onefourth != null
                                      ? onefourth!.toStringAsFixed(2)
                                      : '0',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18.sp),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      // amount after subtract the 1/4 from total Amount
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                width: 2, color: Colors.grey.shade400)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Balance Amount',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18.sp),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10.h),
                                child: Text(
                                  afterJaman != null
                                      ? afterJaman!.toStringAsFixed(2)
                                      : '0',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18.sp),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ReUseBtn(
                            btnTitle: 'Save',
                            color: Colors.teal,
                            isloading: isloading,
                            onpress: () async {
                              // Validate the form and ensure all required fields are filled
                              if (formkey.currentState!.validate() &&
                                  ZamendarNameController.text.isNotEmpty &&
                                  productWeight != null &&
                                  finalWeight != null &&
                                  totalAmount != null &&
                                  totalLabourWage != null &&
                                  totalChundae != null &&
                                  totalFare != null &&
                                  currentRate != null) {
                                // Set loading to true while processing the request
                                setState(() {
                                  isloading = true;
                                });

                                // Ensure totalAmount is not null and is greater than or equal to 0
                                if (totalAmount != null &&
                                    totalAmount! < 0.00) {
                                  dialog().bottomDialog(
                                      context, 'total amount is less than 0');
                                  // Hide the bottom sheet after 1 second
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    Navigator.of(context)
                                        .pop(); // Close the bottom sheet
                                  });

                                  setState(() {
                                    isloading = false;
                                  });
                                  return; // Exit if the total amount is invalid
                                } else if (jamanAmount! > balanceAmount!) {
                                  dialog().bottomDialog(
                                      context, 'Jaman Amount is not valid');
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    Navigator.of(context).pop();
                                  });
                                  setState(() {
                                    isloading = false;
                                  });
                                  return;
                                }

                                try {
                                  // Save data using hiveOperations and await for completion
                                  await hiveOperations.saveData(
                                      context,
                                      ZamendarNameController.text,
                                      productWeight.toString(),
                                      finalWeight.toString(),
                                      totalAmount.toString(),
                                      totalLabourWage.toString(),
                                      totalChundae.toString(),
                                      totalFare.toString(),
                                      currentRate.toString(),
                                      onefourth.toString(),
                                      afterJaman.toString(),
                                      jamanAmount.toString());

                                  // Optionally save data using MyHiveOperations if different
                                  MyHiveOperations().saveData(
                                      context,
                                      ZamendarNameController.text,
                                      productWeight.toString(),
                                      finalWeight.toString(),
                                      totalAmount.toString(),
                                      totalLabourWage.toString(),
                                      totalChundae.toString(),
                                      totalFare.toString(),
                                      currentRate.toString(),
                                      onefourth.toString(),
                                      afterJaman.toString(),
                                      jamanAmount.toString());

                                  // Successfully saved the data, set loading to false
                                  setState(() {
                                    isloading = false;
                                  });
                                } catch (error) {
                                  // Handle any errors that occur during the save process

                                  dialog()
                                      .bottomDialog(context, error.toString());
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    Navigator.of(context)
                                        .pop(); // Close the bottom sheet
                                  });
                                  setState(() {
                                    isloading = false;
                                  });
                                }
                              } else {
                                setState(() {
                                  isloading = false;
                                });

                                dialog().bottomDialog(context,
                                    'Form validation failed or some fields are null');
                              }
                            },
                          ),
                          ReUseBtn(
                              btnTitle: 'Clear',
                              color: Colors.red,
                              onpress: () {
                                ZamendarNameController.clear();
                                currentRateController.clear();
                                productWeightController.clear();
                                labourWageController.clear();
                                chundaeController.clear();
                                fareController.clear();
                              })
                        ],
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
