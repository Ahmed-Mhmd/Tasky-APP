// ignore_for_file: unused_local_variable, unused_element, unused_catch_clause, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/network/result.dart';
import 'package:tasky_app/core/utils/app_dialog.dart';
import 'package:tasky_app/features/auth/data/firebase/auth_firebase_database.dart';
import '../../../core/utils/validators.dart';
import '../../home/screens/home_screen.dart';
import '../widgets/custom_material_button.dart';
import '../widgets/navigator_register_login_widget.dart';
import '../widgets/text_form_field.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routeName = "LoginScreen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  var formKey = GlobalKey<FormState>();
  void _login() async {
    AppDialog.showLoading(context);
    final result = await AuthFunctions.loginUser(
      email: email.text.trim(),
      password: password.text.trim(),
    );
    Navigator.of(context).pop();
    switch (result) {
      case Success<String>():
        AppDialog.showSuccess(context, message: "Login Successfully ✅");
        await Future.delayed(const Duration(milliseconds: 700));
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        break;
      case ErrorState<String>():
        AppDialog.showError(context, error: result.error);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),

      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 120.h, left: 24.w, right: 25.w),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: .start,
            spacing: 30.h,
            children: [
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff404147),
                ),
              ),
              SizedBox(height: 12.h),

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
                keyboardType: TextInputType.visiblePassword,
              ),

              SizedBox(height: 40.h),
              CustomMaterialButton(
                text: "Login",
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    _login();
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: NavigatorRegisterLoginWidget(
        questionTitle: 'Don\'t have an account?',
        actionTitle: 'Register',
        onTap: () {
          Navigator.of(context).pushNamed(RegisterScreen.routeName);
        },
      ),
    );
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
