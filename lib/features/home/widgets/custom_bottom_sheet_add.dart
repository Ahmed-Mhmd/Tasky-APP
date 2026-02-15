// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/utils/app_date_picker.dart';
import '../../../core/network/result.dart';
import '../../../core/utils/app_dialog.dart';
import '../../../core/utils/assets_constant.dart';
import '../../../core/utils/validators.dart';
import '../../auth/widgets/text_form_field.dart';
import '../data/firebase/home_firebase.dart';
import '../data/model/task_model.dart';
import 'alert_dialog_priority.dart';

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
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(25).r,
        child: Form(
          key: formKey,
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
                    onTap: () async {
                      // _pickDate();
                      final result = await AppDatePicker.pick(
                        context,
                        pickedDate,
                      );
                      if (result != null) {
                        setState(() {
                          pickedDate = result;
                        });
                      }
                    },
                  ),
                  SizedBox(width: 12.w),
                  _TaskIcon(
                    imagePath: AssetsConstant.flagIcon,
                    onTap: () async {
                      final value = await showDialog<int>(
                        context: context,
                        builder: (context) => const AlertDialogPriority(),
                      );

                      if (!mounted) return;

                      if (value != null) {
                        setState(() {
                          selectedPriority = value;
                        });
                      }
                    },
                  ),
                  const Spacer(),
                  _TaskIcon(
                    imagePath: AssetsConstant.sendIcon,
                    onTap: () {
                      if (!formKey.currentState!.validate()) return;
                      _addTaskToFirebase();
                    },
                  ),
                ],
              ),
            ],
          ),
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
