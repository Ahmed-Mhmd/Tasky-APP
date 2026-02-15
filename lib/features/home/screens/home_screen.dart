// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tasky_app/core/network/result.dart';
import '../../../core/utils/assets_constant.dart';
import '../../auth/screens/login_screen.dart';
import '../data/firebase/home_firebase.dart';
import '../data/model/task_model.dart';
import '../widgets/custom_bottom_sheet_add.dart';
import '../widgets/empty_home.dart';
import '../widgets/filled_home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = "HomeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool hasTasks = false;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    checkIfHasTasks();
  }

  Future<void> checkIfHasTasks() async {
    final result = await HomeFirebase.getTasks(DateTime.now());

    if (!mounted) return;

    switch (result) {
      case Success<List<TaskModel>>():
        setState(() {
          hasTasks = result.value.isNotEmpty;
          isLoading = false;
        });

      case ErrorState<List<TaskModel>>():
        setState(() => isLoading = false);
    }
  }

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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasTasks
          ? FilledHome(key: UniqueKey())
          : const EmptyHome(),
      floatingActionButton: SizedBox(
        width: 60.w,
        height: 60.w,
        child: FloatingActionButton(
          elevation: 0,
          onPressed: () async {
            final added = await showModalBottomSheet<bool>(
              backgroundColor: Color(0xffFFFFFF),
              context: context,
              isScrollControlled: true,
              builder: (context) => CustomBottomSheetAdd(),
            );

            if (added == true) {
              await checkIfHasTasks();
            }
          },
          backgroundColor: Color(0xff404147),
          shape: CircleBorder(),
          child: Icon(Icons.add, color: Color(0xff5F33E1)),
        ),
      ),
    );
  }
}

 