import 'package:agriculture/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MyHiveOperations {
  Box? localBox;
  late Future<List<Map<String, dynamic>>> dataFuture;
  // open the local
  Future<void> openHiveBox() async {
    localBox = await Hive.openBox('agricultureData');
  }

  void saveData(
      BuildContext context,
      String ZamendarName,
      String productWeight,
      String finalWeight,
      String totalAmount,
      String totalLabourWage,
      String totalChundae,
      String totalFare,
      String currentRate,
      String onefourthAmount,
      String balanceAmount,
      String jamanAmount) async {
    dialog().mydialog(
      context,
      double.tryParse(productWeight) ?? 0.0,
      double.tryParse(finalWeight) ?? 0.0,
      double.tryParse(totalAmount) ?? 0.0,
      double.tryParse(totalLabourWage) ?? 0.0,
      double.tryParse(totalChundae) ?? 0.0,
      double.tryParse(totalFare) ?? 0.0,
      double.tryParse(currentRate) ?? 0.0,
      double.parse(onefourthAmount) ?? 0.0,
      double.parse(jamanAmount) ?? 0.0,
      double.parse(balanceAmount) ?? 0.0,
    );
  }
}
