// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky_app/core/constant/assets_constant.dart';
import 'package:tasky_app/features/auth/screens/login_screen.dart';

import 'home_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
  static const String routeName = "SplashScreen";
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate;
    // Future.delayed(const Duration(seconds: 2), () {
    //   Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    // });
  }

  Future<void> get _navigate async {
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();

    final bool seenOnboarding = prefs.getBool("seenOnboarding") ?? false;
    final user = FirebaseAuth.instance.currentUser;

    if (!seenOnboarding) {
      Navigator.pushReplacementNamed(context, OnboardingScreen.routeName);
    } else if (user != null) {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } else {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff5F33E1),
      body: Center(
        child: Row(
          spacing: 2.w,
          mainAxisAlignment: .center,
          children: [
            FadeInLeft(
              duration: const Duration(milliseconds: 1000),
              delay: const Duration(milliseconds: 300),
              child: Image.asset(AssetsConstant.taskIcon),
            ),
            BounceInDown(
              delay: const Duration(milliseconds: 1300),
              duration: const Duration(milliseconds: 700),
              from: 50,
              child: Image.asset(AssetsConstant.yIcon),
            ),
          ],
        ),
      ),
    );
  }
}
