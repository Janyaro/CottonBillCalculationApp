import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HiveOperations {
  Box? localBox;
  late Future<List<Map<String, dynamic>>> dataFuture;
  // open the local
  Future<void> openHiveBox() async {
    localBox = await Hive.openBox('agricultureData');
  }

  Future<void> saveData(
    BuildContext context,
    String zamendarName,
    String productWeight,
    String finalWeight,
    String totalAmount,
    String totalLabourWage,
    String totalChundae,
    String totalFare,
    String currentRate,
    String onefourthAmount,
    String afterjaman,
    String jamanAmount
  ) async {
    final box = await Hive.openBox('agricultureData');
    final entry = {
      'Date': DateTime.now().toIso8601String(),
      'ZamendarName': zamendarName,
      'productWeight': productWeight,
      'finalWeight': finalWeight,
      'totalAmount': totalAmount,
      'totalLabourWage': totalLabourWage,
      'totalChundae': totalChundae,
      'totalFare': totalFare,
      'currentRate': currentRate,
      '1/4 Amount':onefourthAmount,
      'balanceAmount' : afterjaman,
      'jamanAmount' : jamanAmount
    };

    // Save data to Hive with auto-incremented key
    await box.add(entry);

    // Save data to Firebase
    final firestore = FirebaseFirestore.instance;
    String id = DateTime.now().toString();
    await firestore.collection('dataEntries').doc(id).set(entry).then((val) {});
  }
}
