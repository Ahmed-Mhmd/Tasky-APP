import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/assets_constant.dart';
import 'custom_save_cancel_widget.dart';

class AlertDialogPriority extends StatefulWidget {
  const AlertDialogPriority({super.key, required this.getPriority});
  final void Function(int) getPriority;

  @override
  State<AlertDialogPriority> createState() => _AlertDialogPriorityState();
}

class _AlertDialogPriorityState extends State<AlertDialogPriority> {
  final List<int> priorities = List.generate(10, (index) => index + 1);
  int selectedPriority = 1;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xffFFFFFF),
      title: Column(
        mainAxisSize: .min,
        children: [
          Text(
            'Task Priority',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Color(0xff404147),
            ),
          ),
          const Divider(),
        ],
      ),
      content: SizedBox(
        width: 350.w,
        child: Column(
          mainAxisSize: .min,
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: priorities.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12.h,
                crossAxisSpacing: 16.w,
                childAspectRatio: 0.77.w,
              ),
              itemBuilder: (context, index) {
                final value = priorities[index];
                return _ItemTaskPriority(
                  value,
                  selectedPriority == index + 1,
                  onTap: () {
                    setState(() {
                      selectedPriority = index + 1;
                      widget.getPriority(selectedPriority);
                    });
                  },
                );
              },
            ),
            SizedBox(height: 12.h),
            CustomSaveCancelWidget(selectedValue: selectedPriority),
          ],
        ),
      ),
    );
  }
}

class _ItemTaskPriority extends StatelessWidget {
  const _ItemTaskPriority(this.index, this.isSelected, {this.onTap});
  final int index;
  final bool isSelected;
  // final String priority;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 3.h),
        // margin: EdgeInsets.only(right: 16.w, bottom: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xff5F33E1) : Color(0xffFFFFFF),
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(
            color: isSelected ? Color(0xff5F33E1) : Color(0xff6E6A7C),
            width: 1,
          ),
        ),
        child: Column(
          // spacing: 7,
          children: [
            Image.asset(
              AssetsConstant.flagIcon,
              width: 24,
              height: 24,
              color: isSelected ? Color(0xffFFFFFF) : Color(0xff5F33E1),
            ),
            SizedBox(height: 7.h),
            Text(
              index.toString(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: isSelected ? Color(0xffFFFFFF) : Color(0xff404147),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
Wrap(
        children: priorities
            .map<_ItemTaskPriority>((e) => _ItemTaskPriority(e, false))
            .toList(),
      ),
 */
