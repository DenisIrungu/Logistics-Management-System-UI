import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final String? errorMsg;
  final String? Function(String?)? onChanged;

  String? errorText;

  MyTextField(
      {required this.controller,
      required this.labelText,
      required this.hintText,
      required this.obscureText,
      this.keyboardType,
      this.suffixIcon,
      this.onTap,
      this.prefixIcon,
      this.validator,
      this.focusNode,
      this.errorMsg,
      this.onChanged,
      super.key});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        validator: widget.validator,
        obscureText: widget.obscureText,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          fillColor: Color(0xFFDFDEE8),
          filled: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.black),
          labelText: widget.labelText,
          suffix: widget.suffixIcon,
          prefix: widget.prefixIcon,
          errorText: widget.errorMsg,
          labelStyle: TextStyle(color: Color(0xFF303F9F)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFFF9500)),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey)),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        style: TextStyle(color: Colors.black, fontSize: 20),
      ),
    );
  }
}
