import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class ReuseTextForm extends StatelessWidget {
  TextEditingController controller;
  bool readOnly;

  String labelText;
  String validatorMessage;
  final TextInputType keyboardType;
  ReuseTextForm({
    super.key,
    required this.controller,
    this.readOnly = false,
    required this.labelText,
    required this.validatorMessage,
    required this.keyboardType,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.black, fontSize: 18.sp),
        contentPadding: EdgeInsets.all(10.r),
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      validator: readOnly
          ? null
          : (value) {
              if (value == null || value.isEmpty) {
                return validatorMessage;
              }
              return null;
            },
    );
  }
}
