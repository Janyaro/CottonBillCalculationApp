import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReUseBtn extends StatelessWidget {
  final String btnTitle;
  final VoidCallback onpress;
  final bool isloading;
  final Color color;
  const ReUseBtn(
      {Key? key,
      required this.btnTitle,
      required this.onpress,
      this.isloading = false, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onpress,
      child: Container(
        width: 150.r,
        height: 40.r,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(4.r))),
        child: Center(
            child: isloading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: Center(
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    ),
                  )
                : Text(
                    btnTitle, // Use btnTitle here instead of hardcoded text
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  )),
      ),
    );
  }
}
/*
            
*/