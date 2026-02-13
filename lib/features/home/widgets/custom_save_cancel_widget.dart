// ignore_for_file: strict_top_level_inference, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSaveCancelWidget extends StatefulWidget {
  const CustomSaveCancelWidget({super.key, this.selectedValue});
  final  selectedValue;

  @override
  State<CustomSaveCancelWidget> createState() => _CustomSaveCancelWidgetState();
}

class _CustomSaveCancelWidgetState extends State<CustomSaveCancelWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Cancel",
            style: TextStyle(
              fontSize: 16.sp,
              color: Color(0xff5F33E1),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: Size(153.w, 48.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),

            backgroundColor: const Color(0xff5F33E1),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: () => Navigator.pop(context, widget.selectedValue),
          child: Text(
            "Save",
            style: TextStyle(
              fontSize: 16.sp,
              color: Color(0xffEAE4FB),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
