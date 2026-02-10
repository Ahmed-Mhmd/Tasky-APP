import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomMaterialButton extends StatelessWidget {
  final String text;
  final Future<void> Function() onPressed;
  final Color backgroundColor;
  final Color textColor;

  const CustomMaterialButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = const Color(0xff5F33E1),
    this.textColor = const Color(0xffFFFFFF),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: MaterialButton(
        elevation: 0,
        hoverElevation: 0,
        onPressed: () async {
          await onPressed();
        },
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
