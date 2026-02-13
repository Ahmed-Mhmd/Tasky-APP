import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/assets_constant.dart';

class EmptyHome extends StatelessWidget {
  const EmptyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 85.h),
        Image.asset(AssetsConstant.emptyHome, fit: BoxFit.fitWidth),
        SizedBox(height: 15.h),

        Text(
          'What do you want to do today?',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w400,
            color: Color(0xff404147),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          'Tap + to add your tasks',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: Color(0xff404147),
          ),
        ),
      ],
    );
  }
}
