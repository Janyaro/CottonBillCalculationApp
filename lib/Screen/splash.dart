import 'package:agriculture/services/splash_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SplashServices().splash(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: 50.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 200.h),
            child: Container(
              child: Image.asset(
                'assets/agri.gif',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 50.h, // Position it at the bottom
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Nazeer and Dawood Agri Store',
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight
                        .bold), // Using ScreenUtil for responsive text size
              ),
            ),
          ),
        ],
      ),
    );
  }
}
