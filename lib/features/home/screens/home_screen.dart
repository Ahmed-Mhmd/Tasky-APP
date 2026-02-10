// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tasky_app/core/constant/assets_constant.dart';

import '../../auth/screens/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const String routeName = "HomeScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
        backgroundColor: Color(0xffFFFFFF),
        leadingWidth: 120.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.0.w),
          child: SvgPicture.asset(
            AssetsConstant.logoIcon,
            width: 78.22.w,
            height: 28.39.h,
          ),
        ),
        actionsPadding: EdgeInsets.only(right: 16.w),
        actions: [
          InkWell(
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text("Logout"),
                  content: Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text("Logout"),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await FirebaseAuth.instance.signOut();

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  LoginScreen.routeName,
                  (_) => false,
                );
              }
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  AssetsConstant.logoutIcon,
                  width: 24.w,
                  height: 24.w,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Log out',
                  style: TextStyle(fontSize: 16.sp, color: Color(0xffFF4949)),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
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
        ),
      ),
      floatingActionButton: SizedBox(
        width: 60.w,
        height: 60.w,
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Color(0xff404147),
          shape: CircleBorder(),
          child: Icon(Icons.add, color: Color(0xff5F33E1)),
        ),
      ),
    );
  }
}
