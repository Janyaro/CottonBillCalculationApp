import 'package:agriculture/wigdet/reuseRow.dart';
import 'package:flutter/material.dart';

class dialog {
  void mydialog(
      BuildContext context,
      double productWeight,
      double finalWeight,
      double totalAmount,
      double totalLabourWage,
      double totalChundae,
      double totalFare,
      double currentRate,
      double onefourthAmount,
      double jamanAmount,
      double afterJaman,
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Total Bill',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: 300, // Set a fixed width for the dialog
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReuseAbleRow(
                      label: 'Current Rate:', value: currentRate.toString()),
                  ReuseAbleRow(
                      label: 'Product Weight:',
                      value: productWeight.toString()),
                  ReuseAbleRow(
                      label: 'Final Weight:', value: finalWeight.toString()),
                  ReuseAbleRow(
                      label: 'Total Labour Wage:', value: '$totalLabourWage'),
                  ReuseAbleRow(label: 'Total Chundae:', value: '$totalChundae'),
                  ReuseAbleRow(label: 'Total Fare:', value: '$totalFare'),
                  ReuseAbleRow(label: 'Total Amount:', value: '$totalAmount'),
                  ReuseAbleRow(label: '1/4 Amount', value: '$onefourthAmount'),
                  ReuseAbleRow(label: 'Jaman Amount', value: '$jamanAmount'),
                  ReuseAbleRow(label: 'BalanceAmount', value: '$afterJaman'),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Ok',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void bottomDialog(BuildContext context, String sms) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 80,
          padding: const EdgeInsets.all(4.0),
          child: Center(
            child: Text(
              sms,
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
        );
      },
    );
  }
}
