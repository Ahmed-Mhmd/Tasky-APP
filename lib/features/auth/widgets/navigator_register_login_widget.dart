import 'package:flutter/material.dart';

class NavigatorRegisterLoginWidget extends StatelessWidget {
  const NavigatorRegisterLoginWidget({
    super.key,
    required this.questionTitle,
    required this.actionTitle,
    required this.onTap,
  });

  final void Function()? onTap;
  final String questionTitle;
  final String actionTitle;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: .center,
        children: [
          Text(
            questionTitle,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xff6E6A7C),
            ),
          ),
          const SizedBox(width: 3),
          Text(
            actionTitle,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xff744EE5),
            ),
          ),
        ],
      ),
    );
  }
}
