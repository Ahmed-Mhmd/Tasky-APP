// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/network/result.dart';
import '../../../core/utils/app_dialog.dart';
import '../../../core/utils/assets_constant.dart';
import '../../../core/utils/validators.dart';
import '../../auth/widgets/text_form_field.dart';
import '../data/firebase/home_firebase.dart';
import '../data/model/task_model.dart';
import 'alert_dialog_priority.dart';
import 'custom_save_cancel_widget.dart';

class CustomBottomSheetAdd extends StatefulWidget {
  const CustomBottomSheetAdd({super.key});

  @override
  State<CustomBottomSheetAdd> createState() => _CustomBottomSheetAddState();
}

class _CustomBottomSheetAddState extends State<CustomBottomSheetAdd> {
  DateTime pickedDate = DateTime.now();
  int selectedPriority = 1;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> _pickDate() async {
    DateTime selectedDay = DateTime.now();
    DateTime focusedDay = DateTime.now();

    final result = await showDialog<DateTime>(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _monthName(focusedDay.month).toUpperCase(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("${focusedDay.year}"),

                    const SizedBox(height: 10),

                    TableCalendar(
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().add(const Duration(days: 30)),
                      focusedDay: focusedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(selectedDay, day),

                      onDaySelected: (selected, focused) {
                        setState(() {
                          selectedDay = selected;
                          focusedDay = focused;
                        });
                      },

                      headerVisible: false,

                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(6.r),
                        ),

                        selectedDecoration: BoxDecoration(
                          color: Color(0xff5F33E1),
                          borderRadius: BorderRadius.circular(6.r),
                        ),

                        defaultDecoration: BoxDecoration(
                          color: Color(0xff272727),
                          borderRadius: BorderRadius.circular(6.r),
                        ),

                        weekendDecoration: BoxDecoration(
                          color: Color(0xff272727),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        outsideDecoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        disabledDecoration: BoxDecoration(
                          color: Colors.transparent,
                        ),

                        defaultTextStyle: const TextStyle(
                          color: Color(0xffE3E3E3),
                        ),
                        weekendTextStyle: const TextStyle(
                          color: Color(0xffE3E3E3),
                        ),
                        selectedTextStyle: TextStyle(color: Color(0xffEAE4FB)),
                        todayTextStyle: TextStyle(color: Color(0xffEAE4FB)),
                        outsideTextStyle: TextStyle(color: Color(0xffBDBDBD)),
                        disabledTextStyle: TextStyle(color: Color(0xffBDBDBD)),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    CustomSaveCancelWidget(selectedValue: selectedDay),
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        pickedDate = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(25).r,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              'Add Task',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Color(0xff404147),
              ),
            ),
            SizedBox(height: 15.h),
            TextFormFieldWidget(
              title: 'Title',
              hintText: 'Enter task title',
              hintStyle: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff6E6A7C),
              ),
              controller: titleController,
              myValidator: Validators.validateName,
            ),
            SizedBox(height: 12.h),
            TextFormFieldWidget(
              title: 'Description',
              hintText: 'Enter task description',
              hintStyle: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff6E6A7C),
              ),
              controller: descriptionController,
              myValidator: Validators.validateName,
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                _TaskIcon(
                  imagePath: AssetsConstant.timerIcon,
                  onTap: () {
                    _pickDate();
                    // showDatePicker(
                    //   context: context,
                    //   firstDate: DateTime.now(),
                    //   lastDate: DateTime.now().add(const Duration(days: 30)),
                    // );
                  },
                ),
                SizedBox(width: 12.w),
                _TaskIcon(
                  imagePath: AssetsConstant.flagIcon,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialogPriority(
                        getPriority: (priority) {
                          // print("Selected priority: $priority");
                          setState(() {
                            selectedPriority = priority;
                          });
                        },
                      ),
                    );
                  },
                ),
                const Spacer(),
                _TaskIcon(
                  imagePath: AssetsConstant.sendIcon,
                  onTap: _addTaskToFirebase,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addTaskToFirebase() async {
    AppDialog.showLoading(context);

    final taskData = TaskModel(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      date: pickedDate,
      priority: selectedPriority,
    );
    final result = await HomeFirebase.addTask(taskData);
    Navigator.of(context).pop();
    switch (result) {
      case Success<TaskModel>():
        AppDialog.showSuccess(context, message: "Task Added Successfully ✅");
        Navigator.pop(context, true);

      // Navigator.of(context).pop();

      case ErrorState<TaskModel>():
        AppDialog.showError(context, error: result.error);
    }
  }
}

class _TaskIcon extends StatelessWidget {
  const _TaskIcon({required this.imagePath, required this.onTap});
  final String imagePath;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Image.asset(imagePath, width: 24, height: 24, fit: .contain),
    );
  }
}

String _monthName(int month) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return months[month - 1];
}
