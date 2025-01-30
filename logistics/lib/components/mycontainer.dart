import 'package:flutter/material.dart';

class MyContainer extends StatelessWidget {
  final String text;

  const MyContainer({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 350,
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFFF9500)),
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10)),
      child: Center(
          child: Text(
        text,
        style: TextStyle(fontSize: 25, color: Color(0xFFFFFFFF)),
      )),
    );
  }
}
