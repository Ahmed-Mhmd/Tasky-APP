// ignore_for_file: use_build_context_synchronously

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tasky_app/core/network/result.dart';
import 'package:tasky_app/core/utils/app_dialog.dart';
import '../../../core/utils/assets_constant.dart';
import '../../auth/screens/login_screen.dart';
import '../data/firebase/home_firebase.dart';
import '../data/model/task_model.dart';
import '../widgets/custom_bottom_sheet_add.dart';
import '../widgets/empty_home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = "HomeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TaskModel> tasks = [];
  List<TaskModel> pendingTasks = [];
  List<TaskModel> completedTasks = [];
  TextEditingController searchController = TextEditingController();

  

  bool isLoading = true;
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    getAllTasks(selectedDate);
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
      body: Column(
        crossAxisAlignment: .start,
        mainAxisSize: .min,
        children: [
          DatePicker(
            DateTime.now(),
            initialSelectedDate: DateTime.now(),
            selectionColor: Color(0xff000000),
            selectedTextColor: Color(0xffFFFFFF),
            height: 100.h,
            onDateChange: (date) {
              setState(() {
                selectedDate = date;
              });
              getAllTasks(selectedDate);
            },
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : tasks.isEmpty
                ? const EmptyHome()
                : ListView(
                    children: [
                      ...pendingTasks.map((task) => _taskItem(task)),

                      if (completedTasks.isNotEmpty) ...[
                        SizedBox(height: 20.h),

                        Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: .start,
                          mainAxisSize: .max,
                          children: [
                            Container(
                              width: 85.w,
                              height: 40.h,
                              margin: EdgeInsets.symmetric(horizontal: 21.w),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 10.h,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xffFFFFFF),
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(
                                  color: Color(0xff6E6A7C),
                                  width: 1.w,
                                ),
                              ),
                              child: Text(
                                "Completed",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff404147),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 18.h),

                        ...completedTasks.map((task) => _taskItem(task)),
                      ],
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 60.w,
        height: 60.w,
        child: FloatingActionButton(
          onPressed: () async {
            final added = await showModalBottomSheet<bool>(
              context: context,
              isScrollControlled: true,
              builder: (context) => CustomBottomSheetAdd(),
            );

            if (added == true) {
              await getAllTasks(selectedDate);
            }
          },
          backgroundColor: Color(0xff404147),
          shape: CircleBorder(),
          child: Icon(Icons.add, color: Color(0xff5F33E1)),
        ),
      ),
    );
  }

  Future<void> getAllTasks(DateTime date) async {
    setState(() {
      isLoading = true;
    });
    final result = await HomeFirebase.getTasks(date);
    if (!mounted) return;
    switch (result) {
      case Success<List<TaskModel>>():
        final all = result.value;
        pendingTasks = all.where((t) => !(t.isDone ?? false)).toList();
        completedTasks = all.where((t) => (t.isDone ?? false)).toList();
        pendingTasks.sort((a, b) => a.priority!.compareTo(b.priority!));
        completedTasks.sort((a, b) => a.priority!.compareTo(b.priority!));
        setState(() {
          tasks = all;
          isLoading = false;
        });

      case ErrorState<List<TaskModel>>():
        setState(() {
          isLoading = false;
        });
        AppDialog.showError(context, error: result.error);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();

    if (date.day == now.day &&
        date.month == now.month &&
        date.year == now.year) {
      return "Today At ${TimeOfDay.fromDateTime(date).format(context)}";
    }

    return "${date.day}/${date.month}/${date.year}";
  }

  Widget _taskItem(TaskModel task) {
    return Container(
      height: 72.h,
      width: 327,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Color(0xffFFFFFF),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Color(0xff6E6A7C), width: 1.w),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () async {
              await HomeFirebase.isDoneHandle(task);
              await getAllTasks(selectedDate);
            },
            child: Image.asset(
              task.isDone!
                  ? AssetsConstant.completedIcon
                  : AssetsConstant.notCompleteIcon,
            ),
          ),

          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title ?? "",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff404147),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  _formatDate(task.date).toString(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff6E6A7C),
                  ),
                ),
              ],
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(height: 25.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(color: Color(0xff5F33E1), width: 1.w),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      AssetsConstant.flagIcon,
                      width: 14.h,
                      height: 14.h,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      task.priority.toString(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff24252C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
