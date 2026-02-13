// ignore_for_file: sort_child_properties_last

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

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
