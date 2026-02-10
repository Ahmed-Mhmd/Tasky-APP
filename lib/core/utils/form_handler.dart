// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'app_dialog.dart';

class FormHandler {
  static Future<void> submit({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required Future<void> Function() action,
    VoidCallback? onSuccess,
  }) async {
    if (!formKey.currentState!.validate()) return;
    AppDialog.showLoading(context);

    try {
      await action();
      Navigator.of(context).pop();
      onSuccess?.call();
    } catch (e) {
      /// close loading
      Navigator.of(context).pop();

      /// show error
      AppDialog.showError(context, error: e.toString());
    }
  }
}







/*
CustomMaterialButton(
  text: 'Login',
  onPressed: () async {
    await FormHandler.submit(
      context: context,
      formKey: formKey,
      action: () => _login(
        email: email.text,
        password: password.text,
      ),
    );
  },
),




CustomMaterialButton(
  text: 'Register',
  onPressed: () async {

    final user = UserModel(
      email: email.text,
      password: password.text,
      name: userName.text,
    );

    await FormHandler.submit(
      context: context,
      formKey: formKey,
      action: () => _register(user: user),

      onSuccess: () {
        userName.clear();
        email.clear();
        password.clear();
        confirmPassword.clear();
        Navigator.of(context).pop();
      },
    );
  },
),

 */