// ignore_for_file: unnecessary_underscores

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/features/auth/screens/register_screen.dart';
import 'package:tasky_app/features/home/screens/splash_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/home/screens/onboarding_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // String startRoute;
  // if (FirebaseAuth.instance.currentUser != null) {
  //   startRoute = HomeScreen.routeName;
  // } else {
  //   startRoute = LoginScreen.routeName;
  // }
  // runApp(TaskyApp(routeName: startRoute));

  runApp(TaskyApp());
}

class TaskyApp extends StatelessWidget {
  const TaskyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return MaterialApp(
          
          initialRoute: SplashScreen.routeName,
          routes: {
            LoginScreen.routeName: (_) => LoginScreen(),
            RegisterScreen.routeName: (_) => RegisterScreen(),
            HomeScreen.routeName: (_) => HomeScreen(),
            SplashScreen.routeName: (_) => SplashScreen(),
            OnboardingScreen.routeName: (_) => OnboardingScreen(),
            
          },
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
