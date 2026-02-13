// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/network/result.dart';
import '../../../core/utils/app_dialog.dart';
import '../../../core/utils/validators.dart';
import '../data/firebase/auth_firebase_database.dart';
import '../data/model/user_model.dart';
import '../widgets/custom_material_button.dart';
import '../widgets/navigator_register_login_widget.dart';
import '../widgets/text_form_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const String routeName = "RegisterScreen";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController userName = TextEditingController();
  final formKey = GlobalKey<FormState>();
  void _register() async {
    AppDialog.showLoading(context);
    final result = await AuthFunctions.registerUser(
      user: UserModel(
        email: email.text.trim(),
        password: password.text.trim(),
        userName: userName.text.trim(),
      ),
    );
    Navigator.of(context).pop();
    switch (result) {
      case Success<UserModel>():
        AppDialog.showSuccess(
          context,
          message: "Account Created Successfully ✨",
        );
        await Future.delayed(const Duration(milliseconds: 700));
        Navigator.of(context).pop();
        break;

      case ErrorState<UserModel>():
        AppDialog.showError(context, error: result.error);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 100.h, left: 24.w, right: 25.w),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,

          child: Column(
            crossAxisAlignment: .start,
            spacing: 11.h,
            children: [
              Text(
                'Register',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff404147),
                ),
              ),
              SizedBox(height: 12.h),

              TextFormFieldWidget(
                title: 'Username',
                hintText: 'enter username...',
                controller: userName,
                myValidator: Validators.validateName,
                keyboardType: TextInputType.name,
              ),
              TextFormFieldWidget(
                title: 'Email',
                hintText: 'enter email...',
                controller: email,
                myValidator: Validators.validateEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormFieldWidget(
                title: 'Password',
                hintText: 'enter password...',
                controller: password,
                myValidator: Validators.validatePassword,
                obscureText: true,

                isPassword: true,
              ),
              TextFormFieldWidget(
                title: 'Confirm Password',
                hintText: 'enter confirm password...',
                controller: confirmPassword,
                keyboardType: TextInputType.visiblePassword,
                myValidator: (value) =>
                    Validators.validateConfirmPassword(value, password.text),
                obscureText: true,
                isPassword: true,
              ),
              SizedBox(height: 65.h),
              CustomMaterialButton(
                text: "Register",
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    _register();
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: NavigatorRegisterLoginWidget(
        questionTitle: 'Already have an account?',
        actionTitle: 'Login',
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    userName.dispose();
    super.dispose();
  }
}
