import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isLogout;
  final VoidCallback? onTap;

  const DrawerItem(
      {super.key, required this.icon,
      required this.text,
      this.isLogout = false,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(icon, color: isLogout ? Color(0xFF0F0156) : Colors.black),
        title: Text(text,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        onTap: onTap);
  }
}
