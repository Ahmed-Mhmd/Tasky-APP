import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/network/result.dart';
import '../../../core/utils/app_dialog.dart';
import '../../../core/utils/assets_constant.dart';
import '../../../core/utils/date_formatter.dart';
import '../data/firebase/home_firebase.dart';
import '../data/model/task_model.dart';
import '../screens/task_details_screen.dart';

class FilledHome extends StatefulWidget {
  const FilledHome({super.key});

  @override
  State<FilledHome> createState() => _FilledHomeState();
}

class _FilledHomeState extends State<FilledHome> {
  List<TaskModel> tasks = [];
  List<TaskModel> pendingTasks = [];
  List<TaskModel> completedTasks = [];
  TextEditingController searchController = TextEditingController();
  List<TaskModel> filteredPending = [];
  List<TaskModel> filteredCompleted = [];
  String searchText = '';
  bool isLoading = true;
  DateTime selectedDate = DateTime.now();
  void applySearch(String value) {
    searchText = value.toLowerCase().trim();

    if (searchText.isEmpty) {
      filteredPending = pendingTasks;
      filteredCompleted = completedTasks;
    } else {
      filteredPending = pendingTasks.where((task) {
        return (task.title ?? '').toLowerCase().contains(searchText) ||
            (task.description ?? '').toLowerCase().contains(searchText);
      }).toList();

      filteredCompleted = completedTasks.where((task) {
        return (task.title ?? '').toLowerCase().contains(searchText) ||
            (task.description ?? '').toLowerCase().contains(searchText);
      }).toList();
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAllTasks(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: TextField(
            controller: searchController,
            onChanged: applySearch,
            decoration: InputDecoration(
              hintText: "Search for your task...",
              hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xff6E6A7C),
              ),
              prefixIcon: Image.asset(
                AssetsConstant.searchIcon,
                width: 24.w,
                height: 24.w,
              ),
              filled: true,
              fillColor: Color(0xffFFFFFF),
              contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Color(0xff6E6A7C)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Color(0xff6E6A7C)),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 18.w),
          child: DatePicker(
            DateTime.now(),
            initialSelectedDate: selectedDate,
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
        ),
        SizedBox(height: 16.h),
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  children: [
                    ...filteredPending.map((task) => _taskItem(task)),

                    if (completedTasks.isNotEmpty ||
                        filteredCompleted.isNotEmpty) ...[
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

                      ...filteredCompleted.map((task) => _taskItem(task)),
                    ],
                  ],
                ),
        ),
      ],
    );
  }

  Future<void> getAllTasks(DateTime date) async {
    if (!mounted) return;
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

        applySearch(searchController.text);
        setState(() {
          tasks = all;
          isLoading = false;
        });

      case ErrorState<List<TaskModel>>():
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
        AppDialog.showError(context, error: result.error);
    }
  }

  Widget _taskItem(TaskModel task) {
    return InkWell(
      onTap: () async {
        final updated = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TaskDetailsScreen(task: task)),
        );

        if (!mounted) return;

        if (updated == true) {
          getAllTasks(selectedDate);
        }
      },
      child: Container(
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
                if (!mounted) return;
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
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text(
                      task.title ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff404147),
                      ),
                    ),

                    Text(
                      DateFormatter.format(context, task.date),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff6E6A7C),
                      ),
                    ),
                  ],
                ),
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
      ),
    );
  }
}
