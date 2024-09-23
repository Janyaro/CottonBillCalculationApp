import 'package:agriculture/Screen/homescreen.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void splash(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    });
  }
}
