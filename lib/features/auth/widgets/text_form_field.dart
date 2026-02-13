// ignore_for_file: unused_field

import 'package:flutter/material.dart';

typedef Validator = String? Function(String?);

class TextFormFieldWidget extends StatefulWidget {
  final String title;
  final String hintText;
  final TextInputType keyboardType;
  final bool isPassword;
  final TextEditingController controller;
  final Validator myValidator;
  final bool obscureText;
  final TextStyle? hintStyle;
  const TextFormFieldWidget({
    super.key,
    required this.title,
    required this.hintText,
    required this.controller,
    required this.myValidator,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.obscureText = false,
    this.hintStyle,
  });

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  late bool _obscureText;
  late bool _touched = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: .start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xff817D8D),
          ),
        ),
        // const SizedBox(height: 4),
        TextFormField(
          onTap: () => setState(() => _touched = true),
          controller: widget.controller,
          validator: widget.myValidator,
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle:
                widget.hintStyle ??
                const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff7F7F7F),
                ),
            filled: true,
            fillColor: Color(0xffFFFFFF),
            contentPadding: const EdgeInsets.all(15),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xffBABABA),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
            enabledBorder: _border(const Color(0xff716C7E)),
            focusedBorder: _border(const Color(0xff5F33E1)),
            errorBorder: _border(const Color(0xffFF4949)),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: 1),
    );
  }
}
