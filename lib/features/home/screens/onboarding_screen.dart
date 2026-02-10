// ignore_for_file: public_member_api_docs, sort_constructors_first, sort_child_properties_last, use_build_context_synchronously
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:tasky_app/core/constant/assets_constant.dart';

import '../../auth/screens/login_screen.dart';
import '../model/onboarding_data.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const routeName = 'OnboardingScreen';

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<OnboardingData> onboardingListOfData = dataOnboarding();
  int currentIndex = 0;
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //! image onboarding
            SizedBox(
              height: 240.h,
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (value) => setState(() => currentIndex = value),
                itemBuilder: (context, index) {
                  return CustomAnimatedWidget(
                    currentIndex: currentIndex,
                    delay: currentIndex,
                    child: Image.asset(onboardingListOfData[index].imagePath),
                  );
                },
                itemCount: onboardingListOfData.length,
              ),
            ),
            SizedBox(height: 35.h),
            //! indicator onboarding
            SmoothPageIndicator(
              controller: pageController,
              count: onboardingListOfData.length,
              effect: ExpandingDotsEffect(
                spacing: 10.w,
                activeDotColor: Color(0xff5F33E1),
                dotColor: Color(0xffAFAFAF),
                radius: 10.r,
                dotHeight: 4.h,
                dotWidth: 15.w,
              ),
            ),
            SizedBox(height: 50.h),

            //! title onboarding and description onboarding
            CustomAnimatedWidget(
              currentIndex: currentIndex,
              delay: (currentIndex + 1) * 300,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 40.w),
                width: double.infinity,
                child: Column(
                  children: [
                    Text(
                      onboardingListOfData[currentIndex].title,
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff404147),
                      ),
                    ),
                    SizedBox(height: 45.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                      child: Text(
                        onboardingListOfData[currentIndex].description,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff817D8D),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 100.h),

            //! button onboarding
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: MaterialButton(
                    onPressed: () async {
                      if (currentIndex < onboardingListOfData.length - 1) {
                        pageController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      } else {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool("seenOnboarding", true);
                        Navigator.pushReplacementNamed(
                          context,
                          LoginScreen.routeName,
                        );
                      }
                    },
                    color: Color(0xff5F33E1),
                    elevation: 0,
                    hoverElevation: 0,
                    height: 48.h,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.all(16.w),

                    child: Text(
                      currentIndex < onboardingListOfData.length - 1
                          ? 'Next'
                          : 'Get Started',
                      style: TextStyle(
                        color: Color(0xffFFFFFF),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// data class OnboardingData

List<OnboardingData> dataOnboarding() {
  return [
    OnboardingData(
      imagePath: AssetsConstant.onboarding1,
      title: 'Manage your tasks',
      description:
          'You can easily manage all of your daily tasks in DoMe for free',
    ),
    OnboardingData(
      imagePath: AssetsConstant.onboarding2,
      title: 'Create daily routine',
      description:
          'In Tasky  you can create your personalized routine to stay productive',
    ),
    OnboardingData(
      imagePath: AssetsConstant.onboarding3,
      title: 'Organize your tasks',
      description:
          'You can organize your daily tasks by adding your tasks into separate categories',
    ),
  ];
}

class CustomAnimatedWidget extends StatelessWidget {
  const CustomAnimatedWidget({
    super.key,
    required this.currentIndex,
    required this.delay,
    required this.child,
  });
  final int currentIndex;
  final int delay;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (currentIndex == 1) {
      return FadeInDown(
        child: child,
        delay: Duration(milliseconds: delay),
      );
    } else {
      return FadeInUp(
        child: child,
        delay: Duration(milliseconds: delay),
      );
    }
  }
}
