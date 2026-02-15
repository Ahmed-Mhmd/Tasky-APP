// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/utils/app_dialog.dart';
import 'package:tasky_app/core/utils/assets_constant.dart';

import '../../../core/utils/app_date_picker.dart';
import '../../../core/utils/core/utils/date_formatter.dart';
import '../../auth/widgets/custom_material_button.dart';
import '../data/firebase/home_firebase.dart';
import '../data/model/task_model.dart';
import '../widgets/alert_dialog_priority.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({super.key, required this.task});
  final TaskModel task;
  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  TextEditingController? titleController;
  TextEditingController? descriptionController;
  late DateTime selectedDate;
  late int priority;
  Widget _clickableWidget(String text, {void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xffF1F1F5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xff24252C),
          ),
        ),
      ),
    );
  }

  Future<void> saveTask() async {
    widget.task.title = titleController?.text;
    widget.task.description = descriptionController?.text;
    widget.task.priority = priority;
    widget.task.date = selectedDate;
    try {
      await HomeFirebase.updateTask(widget.task);
      if (!mounted) return;
      AppDialog.showSuccess(context, message: "Task updated successfully");
      Navigator.pop(context, true);
    } catch (e) {
      AppDialog.showError(context, error: e.toString());
    }
  }

  Future<void> deleteTask() async {
    await HomeFirebase.deleteTask(widget.task.id!);
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  Future<void> pickDate() async {
    final date = await AppDatePicker.pick(context, selectedDate);
    if (!mounted) return;
    if (date != null) {
      selectedDate = DateTime(
        date.year,
        date.month,
        date.day,
        selectedDate.hour,
        selectedDate.minute,
      );
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.task.title ?? '');
    descriptionController = TextEditingController(
      text: widget.task.description ?? '',
    );
    selectedDate = widget.task.date;
    priority = widget.task.priority ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 11.h),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(4.r),
                    child: Image.asset(
                      AssetsConstant.closeIcon,
                      width: 32.w,
                      height: 32.h,
                      fit: .contain,
                    ),
                  ),
                ),

                SizedBox(height: 45.h),
                Row(
                  crossAxisAlignment: .start,
                  children: [
                    InkWell(
                      onTap: () async {
                        setState(() {
                          widget.task.isDone = !(widget.task.isDone ?? false);
                        });

                        await HomeFirebase.isDoneHandle(widget.task);
                      },
                      child: Image.asset(
                        widget.task.isDone!
                            ? AssetsConstant.completedIcon
                            : AssetsConstant.notCompleteIcon,
                      ),
                    ),

                    SizedBox(width: 12.w),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        mainAxisAlignment: .start,
                        children: [
                          /// TITLE
                          SizedBox(
                            width: double.infinity,
                            child: TextField(
                              controller: titleController!,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff24252C),
                              ),
                            ),
                          ),

                          SizedBox(height: 6.h),

                          /// DESCRIPTION
                          SizedBox(
                            width: double.infinity,
                            child: TextField(
                              controller: descriptionController!,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintText: "Description",
                                border: InputBorder.none,
                                isDense: true,
                                hintStyle: TextStyle(
                                  color: Color(0xff6E6A7C),
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Color(0xff6E6A7C),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 23.h),
                Row(
                  children: [
                    Image.asset(
                      AssetsConstant.timerIcon,
                      width: 24.w,
                      height: 24.h,
                    ),
                    const SizedBox(width: 12),

                    Text(
                      "Task Time :",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Color(0xff24252C),
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const Spacer(),

                    _clickableWidget(
                      DateFormatter.format(context, selectedDate),
                      onTap: pickDate,
                    ),
                  ],
                ),
                SizedBox(height: 29.h),
                Row(
                  children: [
                    Image.asset(AssetsConstant.flagIcon, width: 24, height: 24),
                    SizedBox(width: 12.w),

                    Text(
                      "Task Priority :",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Color(0xff24252C),
                        fontWeight: .w400,
                      ),
                    ),

                    const Spacer(),

                    _clickableWidget(
                      priority == 1 ? 'Default' : '$priority',
                      onTap: () async {
                        final value = await showDialog<int>(
                          context: context,
                          builder: (_) => const AlertDialogPriority(),
                        );

                        if (!mounted) return;
                        if (value != null) {
                          setState(() => priority = value);
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 29.h),
                InkWell(
                  onTap: deleteTask,
                  child: Row(
                    children: [
                      Image.asset(
                        AssetsConstant.trashIcon,
                        width: 24,
                        height: 24,
                      ),

                      SizedBox(width: 8),
                      Text(
                        "Delete Task",
                        style: TextStyle(
                          color: Color(0xffFF4949),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 28.w),
        child: CustomMaterialButton(
          text: 'Edit Task',
          onPressed: () async {
            saveTask();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController?.dispose();
    descriptionController?.dispose();
    super.dispose();
  }
}
